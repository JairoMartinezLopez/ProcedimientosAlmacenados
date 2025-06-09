USE [bdInventario]
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 30/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA ACTUALIZAR VARIOS LEVANTAMIENTOS DE INVENTARIO DE FORMA MASIVA
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_UPD_LEVANTAMIENTOSINVENTARIO_MASIVO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_UPD_LEVANTAMIENTOSINVENTARIO_MASIVO (
    @IdPantalla INT,
    @IdGeneral INT,
    @ListaLevantamientos dbo.TipoLevantamientoInventarioUpdate READONLY -- Usamos el TVP
)
AS
BEGIN
    SET NOCOUNT ON;

	--Validar estado del evento
    DECLARE @idEventoInventarioParaBitacora INT;
    SELECT TOP 1 @idEventoInventarioParaBitacora = LI.idEventoInventario
    FROM @ListaLevantamientos AS LLI
    INNER JOIN dbo.LEVANTAMIENTOSINVENTARIO AS LI ON LLI.idLevantamientoInventario = LI.idLevantamientoInventario;

	-- Validar que se encontró un idEventoInventario válido
    IF @idEventoInventarioParaBitacora IS NULL
    BEGIN
        RAISERROR('No se pudo determinar el Evento de Inventario asociado a los levantamientos proporcionados.', 16, 1);
        RETURN;
    END

    -- Validar el estado del evento (usando el idEventoInventario obtenido)
    IF EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventarioParaBitacora AND idEventoEstado IN (4,5))
    BEGIN
        RAISERROR('No se pueden realizar cambios en este levantamiento de inventario porque el evento asociado ha sido terminado o finalizado.', 16, 1);
        RETURN;
    END

    -- Realizar la actualización masiva
    UPDATE LI
    SET
        Observaciones = ISNULL(LLI.Observaciones, LI.Observaciones),
        ExisteElBien = ISNULL(LLI.ExisteElBien, LI.ExisteElBien),
        FechaVerificacion = ISNULL(LLI.FechaVerificacion, GETDATE()),
        FueActualizado = ISNULL(LLI.FueActualizado, LI.FueActualizado)
    FROM
        dbo.LEVANTAMIENTOSINVENTARIO AS LI
    INNER JOIN
        @ListaLevantamientos AS LLI ON LI.idLevantamientoInventario = LLI.idLevantamientoInventario;

    -- Registrar en la bitácora (esto es más complejo para una actualización masiva)
	-- Se usara solo en base al id del levantamiento inventario

    DECLARE @NumRegistrosActualizados INT = @@ROWCOUNT;
    DECLARE @Consulta NVARCHAR(MAX);

    SET @Consulta = 'UPDATE masivo dbo.LEVANTAMIENTOSINVENTARIO: ' + CAST(@NumRegistrosActualizados AS NVARCHAR(10)) + ' registros actualizados.';

    EXEC dbo.PA_ADM_INS_BITACORA
        'U',
        'LEVANTAMIENTOSINVENTARIO_MASIVO',
        @idEventoInventarioParaBitacora,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
GO