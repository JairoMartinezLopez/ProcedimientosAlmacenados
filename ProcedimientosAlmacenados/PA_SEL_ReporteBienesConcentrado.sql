USE [bdInventario]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE DESARROLLO DE SISTEMAS
	Fecha de Creación: 2025-06-22
	Descripción: PROCEDIMIENTO ALMACENADO PARA REPORTE DE BIENES.
    Lista bienes concentrados.
	Desarrolló: JAIRO MARTINEZ LOPEZ
	Ejemplo Uso:	PA_SEL_ReporteBienesConcentrado @IdGeneral=0, @IdPantalla=0, @idFinanciamiento=0, @idTipoBien=0, @idBien=0, @idArea=0, @Umas=0, @UnidadRespondable=0, @idCategoria=0
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_ReporteBienesConcentrado]
(
    @IdGeneral          AS INT,
    @IdPantalla         AS INT,
    @idFinanciamiento   AS INT = 0, 
    @idTipoBien         AS INT = 0,
    @idBien             AS INT = 0,
    @idArea             AS INT = 0,
    @Umas               AS BIT = 0,
    @UnidadResponsable  AS INT = 0
)
AS
BEGIN
    -- Eliminar el conteo de registros afectados para mejorar el rendimiento.
    SET NOCOUNT ON;
	DECLARE @NombreAreaTitulo NVARCHAR(200);
	DECLARE @ClaveArea NVARCHAR(50);
	DECLARE @NombreArea NVARCHAR(150);

	IF @idArea <> 0
	BEGIN
		SELECT 
			@ClaveArea = Clave, 
			@NombreArea = Nombre
		FROM AREAS
		WHERE idArea = @idArea;

		-- Concatena las dos columnas en una sola variable
		SET @NombreAreaTitulo = ISNULL(@ClaveArea, '') + ' - ' + ISNULL(@NombreArea, '');
	END
	ELSE
	BEGIN
		SET @NombreAreaTitulo = 'TODAS LAS ÁREAS';
	END;

    -- Primer conjunto de resultados: El nombre del área
    SELECT @NombreAreaTitulo AS NombreAreaParaTitulo;

    -- Declaración de variable local para almacenar el valor de la UMA.
    DECLARE @ImporteUmas AS FLOAT;

    -- Si el nombre de la tabla o columnas es diferente, ajusta aquí.
    SELECT @ImporteUmas = ValorUMA * 70 FROM UMAS WHERE anio = YEAR(GETDATE()) AND activo = 1;

    -- Selección de los Registros del Reporte
    SELECT
		AREAS.Nombre AS NombreArea,
        -- Combinación de clave y nombre del tipo de bien, y clave y descripción del bien específico.
        CAT_TIPOSBIENES.Clave,
		CAT_TIPOSBIENES.Nombre AS NombreTipoBien,
		CAST(CAT_BIENES.Clave AS NVARCHAR(10)) AS ClaveBien,
		CAT_BIENES.Nombre AS BienDesc, -- 'Nombre' para CAT_TIPOSBIENES
        COUNT(BIENES.idBien) AS Cantidad,
        SUM(BIENES.Costo) AS CostoSuma
    FROM
        BIENES
    -- Se une con UBICACIONESFISICAS para obtener la ubicación actual del bien.
    INNER JOIN UBICACIONESFISICAS
        ON BIENES.idBien = UBICACIONESFISICAS.idBien
        AND BIENES.Activo = 1 -- El bien debe estar activo
        AND UBICACIONESFISICAS.Activo = 1 -- La ubicación física debe estar activa
    -- Se une con CAT_BIENES para obtener la clasificación del bien.
    INNER JOIN TRANSFERENCIAS
		ON TRANSFERENCIAS.idTransferencia = UBICACIONESFISICAS.idTransferencia
	INNER JOIN CAT_BIENES
        ON CAT_BIENES.idCatalogoBien = BIENES.idCatalogoBien AND CAT_BIENES.Activo = 1
    -- Se une con AREAS para obtener la adscripción (área destino) del bien.
    INNER JOIN AREAS
        ON AREAS.idArea = TRANSFERENCIAS.IdAreaDestino
    -- Se une con CAT_TIPOSBIENES para obtener la información del tipo de bien.
    INNER JOIN CAT_TIPOSBIENES
        ON CAT_TIPOSBIENES.IdTipoBien = CAT_BIENES.IdTipoBien
    -- Se une con CAT_COLORES para obtener el nombre del color
    INNER JOIN CAT_COLORES	
		ON CAT_COLORES.idColor = BIENES.idColor
	-- Se une con CAT_MARCAS para obtener la descripción de la marca.
	INNER JOIN CAT_MARCAS
        ON CAT_MARCAS.idMarca = BIENES.idMarca
    -- Se une con FACTURAS para obtener la información de facturación.
    INNER JOIN FACTURAS
        ON FACTURAS.idFactura = BIENES.idFactura AND FACTURAS.Publicar = 1 AND FACTURAS.Activo = 1
    -- Se une con CAT_ESTADOSFISICOS para obtener la descripción del estado físico del bien.
    INNER JOIN CAT_ESTADOSFISICOS
        ON CAT_ESTADOSFISICOS.idEstadoFisico = BIENES.idEstadoFisico
    WHERE
        -- Filtra por ID de Financiamiento. Si 0, incluye todos.
        FACTURAS.idFinanciamiento = CASE WHEN @idFinanciamiento = 0 THEN FACTURAS.idFinanciamiento ELSE @idFinanciamiento END -- 'idFinanciamiento' de FACTURAS
        -- Filtra por ID de Tipo de Bien. Si 0, incluye todos.
        AND CAT_TIPOSBIENES.IdTipoBien = CASE @idTipoBien WHEN 0 THEN CAT_TIPOSBIENES.IdTipoBien ELSE @idTipoBien END
        -- Filtra por ID de Bien (Catálogo de Bienes). Si 0, incluye todos.
        AND CAT_BIENES.idCatalogoBien = CASE @idBien WHEN 0 THEN CAT_BIENES.idCatalogoBien ELSE @idBien END
        -- Filtra por ID de Área de Adscripción (Area Destino). Si 0, incluye todas.
        AND AREAS.idArea = CASE @idArea WHEN 0 THEN AREAS.idArea ELSE @idArea END
        -- Filtra por ID de Unidad Responsable (del área de adscripción). Si 0, incluye todas.
        AND AREAS.IdUnidadResponsable = CASE @UnidadResponsable WHEN 0 THEN AREAS.IdUnidadResponsable ELSE @UnidadResponsable END
        -- Filtra por Costo del Bien en relación con el valor de la UMA.
        -- Si @Umas es 0, no se aplica este filtro y se incluyen todos los costos.
        -- Si @Umas es 1, se incluyen solo bienes cuyo Costo es mayor o igual al @ImporteUmas calculado.
        AND BIENES.Costo >= CASE @Umas WHEN 0 THEN BIENES.Costo ELSE ISNULL(@ImporteUmas, 0) END
    GROUP BY
		AREAS.NOMBRE,
        CAT_TIPOSBIENES.Clave,
        CAT_TIPOSBIENES.Nombre,
        CAT_BIENES.Clave,
        CAT_BIENES.Nombre
    ORDER BY
        CAT_TIPOSBIENES.Clave,
        CAT_BIENES.Clave;

    SET ROWCOUNT 0;

    -- Inserta un registro en la tabla de bitácora.
    EXECUTE PA_ADM_INS_BITACORA
        'S',
        'PA_SEL_ReporteBienesConcentrado',
        '',
        @IdGeneral,
        @IdPantalla;
END;