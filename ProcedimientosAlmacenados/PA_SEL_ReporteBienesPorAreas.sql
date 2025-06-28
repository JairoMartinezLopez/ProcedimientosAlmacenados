USE [bdInventario]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE DESARROLLO DE SISTEMAS
	Fecha de Creaci�n: 2025-06-22
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA REPORTE DE BIENES.
    Lista bienes detallados con varios criterios de filtrado.
	Desarroll�: JAIRO MARTINEZ LOPEZ
	Ejemplo Uso:	PA_SEL_ReporteBienesPorAreas @IdGeneral=0, @IdPantalla=0, @idFinanciamiento=0, @idTipoBien=0, @idBien=0, @idArea=0, @Umas=0, @UnidadRespondable=0, @idCategoria=0
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_ReporteBienesPorAreas]
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

	IF @idArea <> 0
    BEGIN
        SELECT @NombreAreaTitulo = Nombre
        FROM AREAS
        WHERE idArea = @idArea;
    END
    ELSE
    BEGIN
        SET @NombreAreaTitulo = 'TODAS LAS �REAS';
    END;

    -- Primer conjunto de resultados: El nombre del �rea
    SELECT @NombreAreaTitulo AS NombreAreaParaTitulo;

    -- Declaraci�n de variable local para almacenar el valor de la UMA.
    DECLARE @ImporteUmas AS FLOAT;

    -- Si el nombre de la tabla o columnas es diferente, ajusta aqu�.
    SELECT @ImporteUmas = ValorUMA * 70 FROM UMAS WHERE anio = YEAR(GETDATE()) AND activo = 1;

    -- Selecci�n de los Registros del Reporte
    SELECT
        BIENES.idBien,
        -- Combinaci�n de clave y nombre del tipo de bien, y clave y descripci�n del bien espec�fico.
        CAT_TIPOSBIENES.Clave,
		CAT_TIPOSBIENES.Nombre AS NombreTipoBien,
		CAST(CAT_BIENES.Clave AS NVARCHAR(10)) AS ClaveBien,
		CAT_BIENES.Nombre AS BienDesc, -- 'Nombre' para CAT_TIPOSBIENES
        -- N�mero de inventario del bien, con l�gica para ajustar el prefijo si no aplica UMAS.
		CASE WHEN BIENES.AplicaUMAS = 0 THEN '2' + SUBSTRING(BIENES.NoInventario, 2, 24) ELSE BIENES.NoInventario END AS NoInventario,
		BIENES.Aviso,
        BIENES.Costo,
        FACTURAS.NumeroFactura,
        FACTURAS.FolioFiscal,
		BIENES.Salida,
		CAT_COLORES.Nombre AS Color,
        BIENES.Serie,
        CAT_MARCAS.Nombre AS Marca, -- 'Nombre' para CAT_MARCAS
        BIENES.Modelo,
        UPPER(CAT_ESTADOSFISICOS.Nombre) AS EdoFisico, -- 'Nombre' para CAT_ESTADOSFISICOS
		BIENES.Observaciones
    FROM
        BIENES
    -- Se une con UBICACIONESFISICAS para obtener la ubicaci�n actual del bien.
    INNER JOIN UBICACIONESFISICAS
        ON BIENES.idBien = UBICACIONESFISICAS.idBien
        AND BIENES.Activo = 1 -- El bien debe estar activo
        AND UBICACIONESFISICAS.Activo = 1 -- La ubicaci�n f�sica debe estar activa
    -- Se une con CAT_BIENES para obtener la clasificaci�n del bien.
    INNER JOIN TRANSFERENCIAS
		ON TRANSFERENCIAS.idTransferencia = UBICACIONESFISICAS.idTransferencia
	INNER JOIN CAT_BIENES
        ON CAT_BIENES.idCatalogoBien = BIENES.idCatalogoBien AND CAT_BIENES.Activo = 1
    -- Se une con AREAS para obtener la adscripci�n (�rea destino) del bien.
    INNER JOIN AREAS
        ON AREAS.idArea = TRANSFERENCIAS.IdAreaDestino
    -- Se une con CAT_TIPOSBIENES para obtener la informaci�n del tipo de bien.
    INNER JOIN CAT_TIPOSBIENES
        ON CAT_TIPOSBIENES.IdTipoBien = CAT_BIENES.IdTipoBien
    -- Se une con CAT_COLORES para obtener el nombre del color
    INNER JOIN CAT_COLORES	
		ON CAT_COLORES.idColor = BIENES.idColor
	-- Se une con CAT_MARCAS para obtener la descripci�n de la marca.
	INNER JOIN CAT_MARCAS
        ON CAT_MARCAS.idMarca = BIENES.idMarca
    -- Se une con FACTURAS para obtener la informaci�n de facturaci�n.
    INNER JOIN FACTURAS
        ON FACTURAS.idFactura = BIENES.idFactura AND FACTURAS.Publicar = 1 AND FACTURAS.Activo = 1
    -- Se une con CAT_ESTADOSFISICOS para obtener la descripci�n del estado f�sico del bien.
    INNER JOIN CAT_ESTADOSFISICOS
        ON CAT_ESTADOSFISICOS.idEstadoFisico = BIENES.idEstadoFisico
    WHERE
        -- Filtra por ID de Financiamiento. Si 0, incluye todos.
        FACTURAS.idFinanciamiento = CASE WHEN @idFinanciamiento = 0 THEN FACTURAS.idFinanciamiento ELSE @idFinanciamiento END -- 'idFinanciamiento' de FACTURAS
        -- Filtra por ID de Tipo de Bien. Si 0, incluye todos.
        AND CAT_TIPOSBIENES.IdTipoBien = CASE @idTipoBien WHEN 0 THEN CAT_TIPOSBIENES.IdTipoBien ELSE @idTipoBien END
        -- Filtra por ID de Bien (Cat�logo de Bienes). Si 0, incluye todos.
        AND CAT_BIENES.idCatalogoBien = CASE @idBien WHEN 0 THEN CAT_BIENES.idCatalogoBien ELSE @idBien END
        -- Filtra por ID de �rea de Adscripci�n (Area Destino). Si 0, incluye todas.
        AND AREAS.idArea = CASE @idArea WHEN 0 THEN AREAS.idArea ELSE @idArea END
        -- Filtra por ID de Unidad Responsable (del �rea de adscripci�n). Si 0, incluye todas.
        AND AREAS.IdUnidadResponsable = CASE @UnidadResponsable WHEN 0 THEN AREAS.IdUnidadResponsable ELSE @UnidadResponsable END
        -- Filtra por Costo del Bien en relaci�n con el valor de la UMA.
        -- Si @Umas es 0, no se aplica este filtro y se incluyen todos los costos.
        -- Si @Umas es 1, se incluyen solo bienes cuyo Costo es mayor o igual al @ImporteUmas calculado.
        AND BIENES.Costo >= CASE @Umas WHEN 0 THEN BIENES.Costo ELSE ISNULL(@ImporteUmas, 0) END
    ORDER BY
        CAT_TIPOSBIENES.Clave,
        CAT_BIENES.Clave,
        SUBSTRING(BIENES.NoInventario, 13, 8); -- Ajustado a BIENES.NoInventario

    SET ROWCOUNT 0;

    -- Inserta un registro en la tabla de bit�cora.
    EXECUTE PA_ADM_INS_BITACORA
        'S',
        'PA_SEL_ReporteTipoBien',
        '',
        @IdGeneral,
        @IdPantalla;
END;