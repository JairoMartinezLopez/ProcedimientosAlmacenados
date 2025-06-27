USE [bdInventario]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE DESARROLLO DE SISTEMAS
	Fecha de Creación: 2025-06-26 (Adaptación)
	Descripción: PROCEDIMIENTO ALMACENADO PARA REPORTE DE TIPOS DE BIENES CONCENTRADO.
    Muestra la suma de los costos de bienes agrupados por tipo de bien, aplicando diversos filtros.
	Desarrolló: JAIRO MARTINEZ LOPEZ (Adaptado al esquema de DB proporcionado)
	Ejemplo Uso:	PA_SEL_ReporteTipoBienPesos @IdGeneral=0, @IdPantalla=0, @idFinanciamiento=0, @idTipoBien=0, @idBien=0, @idArea=0, @Umas=0, @UnidadRespondable=0
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_ReporteTipoBienPesos]
(
    @IdGeneral          AS INT,
    @IdPantalla         AS INT,
    @idFinanciamiento   AS INT = 0,
    @idTipoBien         AS INT = 0,
	@Anio				AS INT = 0,
	@Mes				AS INT = 0,
    --@idBien             AS INT = 0,
    @idArea             AS INT = 0,
    @Umas               AS BIT,
    @UnidadResponsable  AS INT = 0
)
AS
BEGIN
    -- Eliminar el conteo de registros afectados para mejorar el rendimiento.
    SET NOCOUNT ON;

	-- Declaración de variables locales para almacenar el rango de fechas de la consulta.
    DECLARE @fechaIni AS DATE, @fechaFin AS DATE;

    -- Lógica para determinar el rango de fechas (mes o año completo) basado en el parámetro @Mes.
    IF (@Mes = 0)
    BEGIN
        SET @fechaIni = CONVERT(DATE, CAST(@Anio AS NVARCHAR(4)) + '-01-01', 23);
        SET @fechaFin = CONVERT(DATE, CAST(@Anio AS NVARCHAR(4)) + '-12-31', 23);
    END
    ELSE
    BEGIN
        SET @fechaIni = CONVERT(DATE, CAST(@Anio AS NVARCHAR(4)) + '-' + CAST(@Mes AS NVARCHAR(2)) + '-01', 23);
        SET @fechaFin = EOMONTH(CONVERT(DATE, CAST(@Anio AS NVARCHAR(4)) + '-' + CAST(@Mes AS NVARCHAR(4)) + '-01', 23));
    END

    -- Declaración de variable local para almacenar el valor de la UMA.
    DECLARE @ImporteUmas AS FLOAT;

    -- Se asume que existe una tabla 'UMAS' con 'ValorUMA' y 'anio'.
    -- Si el nombre de la tabla o columnas es diferente, ajusta aquí.
    SELECT @ImporteUmas = ValorUMA * 70 FROM UMAS WHERE anio = YEAR(GETDATE()) AND activo = 1;

    -- Selección de los Registros del Reporte Concentrado
    SELECT
        CAT_TIPOSBIENES.Clave,
        CAT_TIPOSBIENES.Nombre AS NombreTipoBien,
        SUM(BIENES.Costo) AS SumaCostosPorTipoBien -- Suma todos los costos de los bienes por cada tipo de bien
    FROM
        BIENES
    -- Se une con UBICACIONESFISICAS para obtener la ubicación actual del bien.
    INNER JOIN UBICACIONESFISICAS
        ON BIENES.idBien = UBICACIONESFISICAS.idBien
        AND BIENES.Activo = 1 -- El bien debe estar activo
        AND UBICACIONESFISICAS.Activo = 1 -- La ubicación física debe estar activa
    -- Se une con TRANSFERENCIAS para obtener los detalles de la transferencia si la ubicación lo requiere.
    -- Es crucial si IdAreaDestino se obtiene de TRANSFERENCIAS, como en las adaptaciones previas.
    INNER JOIN TRANSFERENCIAS
        ON TRANSFERENCIAS.idTransferencia = UBICACIONESFISICAS.idTransferencia
    -- Se une con CAT_BIENES para obtener la clasificación del bien.
    INNER JOIN CAT_BIENES
        ON CAT_BIENES.idCatalogoBien = BIENES.idCatalogoBien AND CAT_BIENES.Activo = 1
    -- Se une con AREAS para obtener la adscripción (área destino) del bien.
    INNER JOIN AREAS
        ON AREAS.idArea = TRANSFERENCIAS.IdAreaDestino
    -- Se une con CAT_TIPOSBIENES para obtener la información del tipo de bien para agrupar.
    INNER JOIN CAT_TIPOSBIENES
        ON CAT_TIPOSBIENES.IdTipoBien = CAT_BIENES.IdTipoBien
    -- Se une con CAT_MARCAS (La unión se mantiene por si los filtros dependen de ella, aunque no se seleccionan columnas).
    INNER JOIN CAT_MARCAS
        ON CAT_MARCAS.idMarca = BIENES.idMarca
    -- Se une con FACTURAS para obtener la información de facturación y aplicar filtros.
    INNER JOIN FACTURAS
        ON FACTURAS.idFactura = BIENES.idFactura AND FACTURAS.Publicar = 1 AND FACTURAS.Activo = 1
    -- Se une con CAT_ESTADOSFISICOS (La unión se mantiene por si los filtros dependen de ella, aunque no se seleccionan columnas).
    INNER JOIN CAT_ESTADOSFISICOS
        ON CAT_ESTADOSFISICOS.idEstadoFisico = BIENES.idEstadoFisico
    WHERE
		BIENES.FechaAlta >= @fechaIni AND BIENES.FechaBaja < DATEADD(day, 1, @fechaFin)
        -- Filtra por ID de Financiamiento. Si 0, incluye todos.
        AND FACTURAS.idFinanciamiento = CASE WHEN @idFinanciamiento = 0 THEN FACTURAS.idFinanciamiento ELSE @idFinanciamiento END
        -- Filtra por ID de Tipo de Bien. Si 0, incluye todos.
        AND CAT_TIPOSBIENES.IdTipoBien = CASE @idTipoBien WHEN 0 THEN CAT_TIPOSBIENES.IdTipoBien ELSE @idTipoBien END
        -- Filtra por ID de Bien (Catálogo de Bienes). Si 0, incluye todos.
        --AND CAT_BIENES.idCatalogoBien = CASE @idBien WHEN 0 THEN CAT_BIENES.idCatalogoBien ELSE @idBien END
        -- Filtra por ID de Área de Adscripción (Area Destino). Si 0, incluye todas.
        AND AREAS.idArea = CASE @idArea WHEN 0 THEN AREAS.idArea ELSE @idArea END
        -- Filtra por ID de Unidad Responsable (del área de adscripción). Si 0, incluye todas.
        AND AREAS.IdUnidadResponsable = CASE @UnidadResponsable WHEN 0 THEN AREAS.IdUnidadResponsable ELSE @UnidadResponsable END
        -- Filtra por Costo del Bien en relación con el valor de la UMA.
        AND BIENES.Costo >= CASE @Umas WHEN 0 THEN BIENES.Costo ELSE ISNULL(@ImporteUmas, 0) END
    GROUP BY
        CAT_TIPOSBIENES.Clave,
        CAT_TIPOSBIENES.Nombre -- Agrupa por estas columnas para sumar los costos por cada tipo de bien
    ORDER BY
        CAT_TIPOSBIENES.Clave ASC;

    -- Asegura que no se limite el número de filas devueltas.
    SET ROWCOUNT 0;

    -- Inserta un registro en la tabla de bitácora.
    EXECUTE PA_ADM_INS_BITACORA
        'S', -- Tipo de evento o acción
        'PA_SEL_ReporteTipoBienPrecio', -- Nombre del procedimiento almacenado ejecutado (actualizado)
        '', -- Mensaje adicional
        @IdGeneral, -- ID general, usualmente del usuario o proceso que ejecuta
        @IdPantalla; -- ID de la pantalla o módulo desde donde se invocó el procedimiento
END;