USE [bdInventario]
GO

CREATE TYPE dbo.TipoListaNoInventario AS TABLE (
    NoInventario NVARCHAR(30) PRIMARY KEY
);
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 21/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA DAR DE BAJA MÚLTIPLES BIENES DE FORMA MASIVA
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_BAJA_BIENES_MASIVA
**********************************************************************************/
ALTER PROCEDURE dbo.PA_BAJA_BIENES_MASIVA (
    @IdPantalla INT,
    @IdGeneral INT,
    @ListaNoInventario dbo.TipoListaNoInventario READONLY,
    @idCausalBaja INT,
    @FechaBaja DATE,
    @idDisposicionFinal INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar que idCausalBaja exista en la tabla CAT_CAUSALBAJAS
        IF NOT EXISTS (SELECT 1 FROM dbo.CAT_CAUSALBAJAS WHERE idCausalBaja = @idCausalBaja)
        BEGIN
            RAISERROR('No se pueden dar de baja los bienes. El ID de la causal de baja especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que idDisposicionFinal exista en la tabla CAT_DISPOSICIONESFINALES
        IF NOT EXISTS (SELECT 1 FROM dbo.CAT_DISPOSICIONESFINALES WHERE idDisposicionFinal = @idDisposicionFinal)
        BEGIN
            RAISERROR('No se pueden dar de baja los bienes. El ID de la disposición final especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (
            SELECT ln.NoInventario
            FROM @ListaNoInventario AS ln
            LEFT JOIN dbo.BIENES AS b ON ln.NoInventario = b.NoInventario
            WHERE b.NoInventario IS NULL OR b.Activo = 0
        )
        BEGIN
            DECLARE @NoInventariosInvalidos NVARCHAR(MAX) = '';
            SELECT @NoInventariosInvalidos = @NoInventariosInvalidos + ln.NoInventario + ', '
            FROM @ListaNoInventario AS ln
            LEFT JOIN dbo.BIENES AS b ON ln.NoInventario = b.NoInventario
            WHERE b.NoInventario IS NULL OR b.Activo = 0;

            -- Eliminar la última coma y espacio
            SET @NoInventariosInvalidos = LEFT(@NoInventariosInvalidos, LEN(@NoInventariosInvalidos) - 1);

            RAISERROR('Los siguientes bienes no existen o ya han sido dados de baja: %s', 16, 1, @NoInventariosInvalidos);
            ROLLBACK TRANSACTION;
            RETURN;
        END


        -- Actualizar los bienes para darlos de baja
        UPDATE b
        SET
            Activo = 0,             -- Marcar como inactivo
            Disponibilidad = 0,     -- Marcar como no disponible
            FechaBaja = @FechaBaja,
            idCausalBaja = @idCausalBaja,
            idDisposicionFinal = @idDisposicionFinal
        FROM
            dbo.BIENES AS b
        INNER JOIN
            @ListaNoInventario AS ln ON b.NoInventario = ln.NoInventario;

        -- Registrar en la bitácora para cada bien dado de baja
        DECLARE @idBienAfectado BIGINT;
        DECLARE @CurrentNoInventario NVARCHAR(30);
        DECLARE @CursorNoInventario CURSOR;

        SET @CursorNoInventario = CURSOR FOR
        SELECT NoInventario FROM @ListaNoInventario;

        OPEN @CursorNoInventario;
        FETCH NEXT FROM @CursorNoInventario INTO @CurrentNoInventario;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @idBienAfectado = idBien FROM dbo.BIENES WHERE NoInventario = @CurrentNoInventario;

            DECLARE @ConsultaIndividual NVARCHAR(MAX);
            SET @ConsultaIndividual = 'UPDATE dbo.BIENES SET Activo = 0, Disponibilidad = 0, FechaBaja = ''' + CONVERT(VARCHAR(10), @FechaBaja, 120) + ''', idCausalBaja = ' + CAST(@idCausalBaja AS VARCHAR(10)) + ', idDisposicionFinal = ' + CAST(@idDisposicionFinal AS VARCHAR(10)) + ' WHERE NoInventario = ''' + @CurrentNoInventario + ''';';

            EXEC dbo.PA_ADM_INS_BITACORA
                'D', -- Tipo de operación: Baja
                'BIENES',
                @idBienAfectado,
                @IdGeneral,
                @IdPantalla,
                @ConsultaIndividual;

            FETCH NEXT FROM @CursorNoInventario INTO @CurrentNoInventario;
        END

        CLOSE @CursorNoInventario;
        DEALLOCATE @CursorNoInventario;

        COMMIT TRANSACTION;
        RETURN 0;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN 1; -- Indicar que hubo un error
    END CATCH
END
GO