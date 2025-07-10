USE [bdInventario]
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 22/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR BIENES ASIGNADOS AL ÁREA DE UN EVENTO DE INVENTARIO CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_SEL_BIENES_POR_AREA_EVENTO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_SEL_BIENES_POR_AREA_EVENTO (
    @idEventoInventario INT,
    -- Parámetros opcionales para filtros
    @idBien              INT           = NULL,
    @NoInventario        NVARCHAR(50)  = NULL, 
    @Serie               NVARCHAR(100) = NULL, 
    @Modelo              NVARCHAR(100) = NULL, 
    @NombreColor         NVARCHAR(100) = NULL, -- Para filtrar por el nombre del color
    @NombreMarca         NVARCHAR(100) = NULL, -- Para filtrar por el nombre de la marca
    @NumeroFactura       NVARCHAR(50)  = NULL, -- Para filtrar por el número de factura
    @Disponibilidad      BIT           = NULL,
    @ExisteElBien        BIT           = NULL, -- Filtro para el estado del levantamiento
    @FechaVerificacionDesde DATE       = NULL,
    @FechaVerificacionHasta DATE       = NULL,
    @YaVerificado        BIT           = NULL, -- Filtro para saber si ya fue verificado o no
    @ObservacionesLevantamiento NVARCHAR(MAX) = NULL -- Para filtrar por observaciones del levantamiento
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
        B.Activo,        -- Estado activo del bien
        B.Disponibilidad,
        LI.idLevantamientoInventario,
        LI.ExisteElBien,
        LI.FechaVerificacion,
        LI.Observaciones AS ObservacionesLevantamiento,
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
        -- Filtros
        AND (@idBien             IS NULL OR B.idBien           = @idBien)
        AND (@NoInventario       IS NULL OR B.NoInventario     LIKE '%' + @NoInventario + '%')
        AND (@Serie              IS NULL OR B.Serie            LIKE '%' + @Serie + '%')
        AND (@Modelo             IS NULL OR B.Modelo           LIKE '%' + @Modelo + '%')
        AND (@NombreColor        IS NULL OR CC.Nombre          LIKE '%' + @NombreColor + '%')
        AND (@NombreMarca        IS NULL OR CM.Nombre          LIKE '%' + @NombreMarca + '%')
        AND (@NumeroFactura      IS NULL OR F.NumeroFactura    LIKE '%' + @NumeroFactura + '%')
        AND (@Disponibilidad     IS NULL OR B.Disponibilidad   = @Disponibilidad)
        AND (@ExisteElBien       IS NULL OR LI.ExisteElBien    = @ExisteElBien)
        AND (@FechaVerificacionDesde IS NULL OR LI.FechaVerificacion >= @FechaVerificacionDesde)
        AND (@FechaVerificacionHasta IS NULL OR LI.FechaVerificacion <= @FechaVerificacionHasta)
        AND (@ObservacionesLevantamiento IS NULL OR LI.Observaciones LIKE '%' + @ObservacionesLevantamiento + '%')
        -- El filtro @YaVerificado es especial, ya que depende del CASE WHEN en el SELECT
        AND (@YaVerificado IS NULL OR CASE WHEN LI.idLevantamientoInventario IS NOT NULL THEN 1 ELSE 0 END = @YaVerificado)
    ORDER BY
        B.NoInventario; -- Se mantiene el orden por número de inventario
END
GO