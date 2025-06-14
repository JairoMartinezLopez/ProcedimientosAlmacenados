USE [bdInventario]
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 30/05/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR VARIOS LEVANTAMIENTOS DE INVENTARIO DE FORMA MASIVA
	Desarroll�: JAIRO MARTINEZ LOPEZ
-- PA_UPD_LEVANTAMIENTOSINVENTARIO_MASIVO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_UPD_LEVANTAMIENTOSINVENTARIO_MASIVO (
    @IdPantalla INT,
    @IdGeneral INT,
    @ListaLevantamientos dbo.TipoLevantamientoInventarioUpdate READONLY -- Usamos el TVP
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Iniciar el bloque TRY para manejar errores y transacciones
    BEGIN TRY
        BEGIN TRANSACTION; -- Iniciar la transacci�n

        -- Validar estado del evento
        DECLARE @idEventoInventarioParaBitacora INT;
        SELECT TOP 1 @idEventoInventarioParaBitacora = LI.idEventoInventario
        FROM @ListaLevantamientos AS LLI
        INNER JOIN dbo.LEVANTAMIENTOSINVENTARIO AS LI ON LLI.idLevantamientoInventario = LI.idLevantamientoInventario;

        -- Validar que se encontr� un idEventoInventario v�lido
        IF @idEventoInventarioParaBitacora IS NULL
        BEGIN
            RAISERROR('No se pudo determinar el Evento de Inventario asociado a los levantamientos proporcionados.', 16, 1);
            ROLLBACK TRANSACTION; -- Revertir si no se encuentra el evento asociado
            RETURN;
        END

        -- Validar el estado del evento (usando el idEventoInventario obtenido)
        IF EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventarioParaBitacora AND idEventoEstado IN (4,5))
        BEGIN
            RAISERROR('No se pueden realizar cambios en este levantamiento de inventario porque el evento asociado ha sido terminado o finalizado.', 16, 1);
            ROLLBACK TRANSACTION; -- Revertir si el evento ya est� terminado/finalizado
            RETURN;
        END

        -- Validar que todos los idLevantamientoInventario de la TVP existan
        IF EXISTS (
            SELECT LLI.idLevantamientoInventario
            FROM @ListaLevantamientos AS LLI
            LEFT JOIN dbo.LEVANTAMIENTOSINVENTARIO AS LI ON LLI.idLevantamientoInventario = LI.idLevantamientoInventario
            WHERE LI.idLevantamientoInventario IS NULL
        )
        BEGIN
            -- Opcional: Podr�as construir un mensaje con los IDs inv�lidos si es �til para el log.
            RAISERROR('Uno o m�s IDs de Levantamiento de Inventario proporcionados para actualizar no existen en la base de datos.', 16, 1);
            ROLLBACK TRANSACTION; -- Revertir si hay IDs de levantamiento inv�lidos
            RETURN;
        END

        -- Realizar la actualizaci�n masiva
        UPDATE LI
        SET
            Observaciones = ISNULL(LLI.Observaciones, LI.Observaciones),
            ExisteElBien = ISNULL(LLI.ExisteElBien, LI.ExisteElBien),
            FechaVerificacion = ISNULL(LLI.FechaVerificacion, GETDATE()), -- Usar GETDATE() si LLI.FechaVerificacion es NULL
            FueActualizado = ISNULL(LLI.FueActualizado, LI.FueActualizado)
        FROM
            dbo.LEVANTAMIENTOSINVENTARIO AS LI
        INNER JOIN
            @ListaLevantamientos AS LLI ON LI.idLevantamientoInventario = LLI.idLevantamientoInventario;

        -- Registrar en la bit�cora (esto es m�s complejo para una actualizaci�n masiva)
        DECLARE @NumRegistrosActualizados INT = @@ROWCOUNT;
        DECLARE @Consulta NVARCHAR(MAX);

        SET @Consulta = 'UPDATE masivo dbo.LEVANTAMIENTOSINVENTARIO: ' + CAST(@NumRegistrosActualizados AS NVARCHAR(10)) + ' registros actualizados para Evento ID: ' + CAST(@idEventoInventarioParaBitacora AS NVARCHAR(10)) + '.';

        EXEC dbo.PA_ADM_INS_BITACORA
            'U',
            'LEVANTAMIENTOSINVENTARIO_MASIVO',
            @idEventoInventarioParaBitacora, -- Se usa el ID del evento como referencia principal para el registro masivo
            @IdGeneral,
            @IdPantalla,
            @Consulta;

        COMMIT TRANSACTION; -- Confirmar todos los cambios si todo fue exitoso
        RETURN 0;

    END TRY
    BEGIN CATCH
        -- Si ocurre alg�n error, se ejecuta este bloque
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; -- Revertir todos los cambios si hay una transacci�n abierta

        -- Propagar el error original
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN 1; -- Retornar un c�digo de error para indicar fallo
    END CATCH
END;