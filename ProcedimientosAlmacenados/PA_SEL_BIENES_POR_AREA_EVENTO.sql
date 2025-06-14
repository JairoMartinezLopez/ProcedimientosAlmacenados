USE [bdInventario]
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 22/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR BIENES ASIGNADOS AL ÁREA DE UN EVENTO DE INVENTARIO
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_SEL_BIENES_POR_AREA_EVENTO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_SEL_BIENES_POR_AREA_EVENTO (
    @idEventoInventario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que idEventoInventario exista en la tabla EVENTOSINVENTARIO
    IF NOT EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario)
    BEGIN
        RAISERROR('El ID de Evento de Inventario especificado no existe.', 16, 1);
        RETURN;
    END

    -- Obtener el idArea del evento de inventario actual
    DECLARE @AreaDelEvento INT;
    SELECT @AreaDelEvento = idArea FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario;

    -- CTE para obtener la ÚNICA ubicación ACTIVA de cada bien
    WITH UbicacionActivaActual AS (
        SELECT
            UF.idBien,
            T.idAreaDestino AS AreaActualBien
        FROM
            dbo.UBICACIONESFISICAS AS UF
        INNER JOIN
            dbo.TRANSFERENCIAS AS T ON UF.idTransferencia = T.idTransferencia
        WHERE
            UF.Activo = 1
    )
    SELECT
        B.idBien,
        B.NoInventario,
        B.Serie,
        B.Modelo,
		CC.Nombre AS Color,
		CM.Nombre AS Marca,
		F.NumeroFactura AS NoFactura,
        --B.Observaciones, -- Observaciones del bien
        B.Activo,        -- Estado activo del bien
        B.Disponibilidad,
        -- Información del levantamiento si existe para este bien en este evento
        LI.idLevantamientoInventario,
        LI.ExisteElBien,
        LI.FechaVerificacion,
        --LI.FueActualizado,
        LI.Observaciones AS ObservacionesLevantamiento, -- Observaciones de la verificación
        CASE WHEN LI.idLevantamientoInventario IS NOT NULL THEN 1 ELSE 0 END AS YaVerificado
    FROM
        dbo.BIENES AS B
    INNER JOIN
        UbicacionActivaActual AS UAA ON B.idBien = UAA.idBien
	INNER JOIN
        dbo.CAT_COLORES AS CC ON B.idColor = CC.idColor
	INNER JOIN
        dbo.CAT_MARCAS AS CM ON B.idMarca = CM.idMarca
	INNER JOIN
        dbo.FACTURAS AS F ON B.idFactura = F.idFactura
    LEFT JOIN
        dbo.LEVANTAMIENTOSINVENTARIO AS LI ON B.idBien = LI.idBien AND LI.idEventoInventario = @idEventoInventario
    WHERE
        UAA.AreaActualBien = @AreaDelEvento -- Que pertenezca al área del evento
        AND B.Activo = 1 -- Solo bienes que están activos en el patrimonio
		

    RETURN 0;
END
GO