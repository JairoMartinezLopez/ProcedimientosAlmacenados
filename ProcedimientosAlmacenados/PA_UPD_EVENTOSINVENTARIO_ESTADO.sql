USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_EVENTOSINVENTARIO]    Script Date: 20/05/2025 08:26:32 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA MODIFICAR EL ESTADO DE UN EVENTO DE INVENTARIO
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_UPD_EVENTOSINVENTARIO_ESTADO
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_EVENTOSINVENTARIO_ESTADO] (
    @IdPantalla INT,
	@IdGeneral INT,
    @idEventoInventario BIGINT,
    @idEventoEstado INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID del evento de inventario existe
    IF NOT EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario)
    BEGIN
        RAISERROR('El ID del evento de inventario especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el registro está inactivo
    IF EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario AND Activo = 0)
    BEGIN
        RAISERROR('El estado físico que intenta modificar se encuentra inactivo y no puede ser actualizado.', 16, 1);
        RETURN;
    END

    -- Validar que idEventoEstado exista en la tabla EVENTOSESTADO
    IF NOT EXISTS (SELECT 1 FROM dbo.EVENTOSESTADO WHERE idEventoEstado = @idEventoEstado)
    BEGIN
        RAISERROR('No se puede modificar el evento de inventario. El ID de Estado de Evento especificado no existe.', 16, 1);
        RETURN;
    END

	DECLARE @EstadoEvento INT;
	SELECT @EstadoEvento = idEventoEstado FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario;

	IF @EstadoEvento IN (4, 5) -- Asumiendo que 4 y 5 son los IDs de estado "Terminado" o "Finalizado"
	BEGIN
		RAISERROR('No se pueden realizar cambios en este levantamiento de inventario porque el evento asociado ha sido terminado o finalizado.', 16, 1);
		RETURN;
	END

    -- Actualizar el evento de inventario
    UPDATE dbo.EVENTOSINVENTARIO
    SET
        idEventoEstado = @idEventoEstado
    WHERE
        idEventoInventario = @idEventoInventario;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.EVENTOSINVENTARIO SET idEventoEstado = ' + CAST(@idEventoEstado AS VARCHAR(10)) + ' WHERE idEventoInventario = ' + CAST(@idEventoInventario AS VARCHAR(20)) + ';';

    EXEC dbo.PA_ADM_INS_BITACORA
        'U',
        'EVENTOSINVENTARIO',
        @idEventoInventario,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
