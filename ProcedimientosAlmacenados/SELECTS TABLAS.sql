USE [bdInventario];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE ACCIONES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_ACCIONES]
    @idAccion    INT           = NULL,
    @Clave       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Nombre      NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Descripcion NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idAccion,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.ACCIONES
    WHERE
            (@idAccion    IS NULL OR idAccion    = @idAccion)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@Descripcion IS NULL OR Descripcion LIKE '%' + @Descripcion + '%')
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE AREAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_AREAS]
    @idArea            INT           = NULL,
    @Clave             NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Nombre            NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Direccion         NVARCHAR(255) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @idAreaPadre       INT           = NULL,
    @Activo            BIT           = NULL,
    @IdUnidadResponsable INT         = NULL,
    @idRegion          INT           = NULL,
    @PermitirEntradas  BIT           = NULL,
    @PermitirSalidas   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idArea,
        Clave,
        Nombre,
        Direccion,
        idAreaPadre,
        Activo,
        IdUnidadResponsable,
        idRegion,
        PermitirEntradas,
        PermitirSalidas
    FROM
        dbo.AREAS
    WHERE
            (@idArea            IS NULL OR idArea            = @idArea)
        AND (@Clave             IS NULL OR Clave             LIKE '%' + @Clave + '%')
        AND (@Nombre            IS NULL OR Nombre            LIKE '%' + @Nombre + '%')
        AND (@Direccion         IS NULL OR Direccion         LIKE '%' + @Direccion + '%')
        AND (@idAreaPadre       IS NULL OR idAreaPadre       = @idAreaPadre)
        AND (@Activo            IS NULL OR Activo            = @Activo)
        AND (@IdUnidadResponsable IS NULL OR IdUnidadResponsable = @IdUnidadResponsable)
        AND (@idRegion          IS NULL OR idRegion          = @idRegion)
        AND (@PermitirEntradas  IS NULL OR PermitirEntradas  = @PermitirEntradas)
        AND (@PermitirSalidas   IS NULL OR PermitirSalidas   = @PermitirSalidas)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE BIENES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_BIENES]
    @idBien             INT           = NULL,
    @idColor            INT           = NULL,
    @FechaRegistroDesde DATE          = NULL,
    @FechaRegistroHasta DATE          = NULL,
    @FechaAltaDesde     DATE          = NULL,
    @FechaAltaHasta     DATE          = NULL,
    @Aviso              NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Serie              NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Modelo             NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @idEstadoFisico     INT           = NULL,
    @idMarca            INT           = NULL,
    @CostoMin           DECIMAL(18,2) = NULL, -- Ajustar el tipo y precisión
    @CostoMax           DECIMAL(18,2) = NULL,
    @Etiquetado         BIT           = NULL,
    @FechaEtiquetadoDesde DATE        = NULL,
    @FechaEtiquetadoHasta DATE        = NULL,
    @Disponibilidad     BIT           = NULL,
    @FechaBajaDesde     DATE          = NULL,
    @FechaBajaHasta     DATE          = NULL,
    @idCausalBaja       INT           = NULL,
    @idDisposicionFinal INT           = NULL,
    @idFactura          INT           = NULL,
    @NumeroFactura      NVARCHAR(50)  = NULL, -- Para buscar por número de factura también
    @NoInventario       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @idCatalogoBien     INT           = NULL,
    @Observaciones      NVARCHAR(MAX) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @AplicaUMAS         BIT           = NULL,
    @Salida             BIT           = NULL,
    @Activo             BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

	SELECT
		B.idBien,
        CC.Nombre AS NombreColor,
        B.FechaRegistro,
        B.FechaAlta,
        B.Aviso,
        B.Serie,
        B.Modelo,
        CEF.Nombre AS NombreEstadoFisico,
        CM.Nombre AS NombreMarca,
        B.Costo,
        B.Etiquetado,
        B.FechaEtiquetado,
        B.Disponibilidad,
        B.FechaBaja,
        CCB.Nombre AS NombreCausalBaja,
        CDF.Nombre AS NombreDisposicionFinal,
        F.NumeroFactura AS NumeroFactura,
        B.NoInventario,
        ISNULL(CB.Nombre, 'N/A') AS NombreCatalogoBien,
        B.Observaciones,
        B.AplicaUMAS,
        B.Salida,
        B.Activo
    FROM
        dbo.BIENES AS B
    LEFT JOIN dbo.CAT_COLORES AS CC ON B.idColor = CC.idColor
    LEFT JOIN dbo.CAT_MARCAS AS CM ON B.idMarca = CM.idMarca
    LEFT JOIN dbo.CAT_ESTADOSFISICOS AS CEF ON B.idEstadoFisico = CEF.idEstadoFisico
    LEFT JOIN dbo.CAT_CAUSALBAJAS AS CCB ON B.idCausalBaja = CCB.idCausalBaja
    LEFT JOIN dbo.CAT_DISPOSICIONESFINALES AS CDF ON B.idDisposicionFinal = CDF.idDisposicionFinal
    LEFT JOIN dbo.FACTURAS AS F ON B.idFactura = F.idFactura
    LEFT JOIN dbo.CAT_BIENES AS CB ON B.idCatalogoBien = CB.idCatalogoBien
    WHERE
            (@idBien             IS NULL OR B.idBien             = @idBien)
        AND (@idColor            IS NULL OR B.idColor            = @idColor)
        AND (@FechaRegistroDesde IS NULL OR B.FechaRegistro    >= @FechaRegistroDesde)
        AND (@FechaRegistroHasta IS NULL OR B.FechaRegistro    <= @FechaRegistroHasta)
        AND (@FechaAltaDesde     IS NULL OR B.FechaAlta        >= @FechaAltaDesde)
        AND (@FechaAltaHasta     IS NULL OR B.FechaAlta        <= @FechaAltaHasta)
        AND (@Aviso              IS NULL OR B.Aviso              LIKE '%' + @Aviso + '%')
        AND (@Serie              IS NULL OR B.Serie              LIKE '%' + @Serie + '%')
        AND (@Modelo             IS NULL OR B.Modelo             LIKE '%' + @Modelo + '%')
        AND (@idEstadoFisico     IS NULL OR B.idEstadoFisico     = @idEstadoFisico)
        AND (@idMarca            IS NULL OR B.idMarca            = @idMarca)
        AND (@CostoMin           IS NULL OR B.Costo            >= @CostoMin)
        AND (@CostoMax           IS NULL OR B.Costo            <= @CostoMax)
        AND (@Etiquetado         IS NULL OR B.Etiquetado         = @Etiquetado)
        AND (@FechaEtiquetadoDesde IS NULL OR B.FechaEtiquetado >= @FechaEtiquetadoDesde)
        AND (@FechaEtiquetadoHasta IS NULL OR B.FechaEtiquetado <= @FechaEtiquetadoHasta)
        AND (@Disponibilidad     IS NULL OR B.Disponibilidad     = @Disponibilidad)
        AND (@FechaBajaDesde     IS NULL OR B.FechaBaja        >= @FechaBajaDesde)
        AND (@FechaBajaHasta     IS NULL OR B.FechaBaja        <= @FechaBajaHasta)
        AND (@idCausalBaja       IS NULL OR B.idCausalBaja       = @idCausalBaja)
        AND (@idDisposicionFinal IS NULL OR B.idDisposicionFinal = @idDisposicionFinal)
        AND (@idFactura          IS NULL OR B.idFactura          = @idFactura)
        AND (@NumeroFactura      IS NULL OR F.NumeroFactura      LIKE '%' + @NumeroFactura + '%')
        AND (@NoInventario       IS NULL OR B.NoInventario       LIKE '%' + @NoInventario + '%')
        AND (@idCatalogoBien     IS NULL OR B.idCatalogoBien     = @idCatalogoBien)
        AND (@Observaciones      IS NULL OR B.Observaciones      LIKE '%' + @Observaciones + '%')
        AND (@AplicaUMAS         IS NULL OR B.AplicaUMAS         = @AplicaUMAS)
        AND (@Salida             IS NULL OR B.Salida             = @Salida)
        AND (@Activo             IS NULL OR B.Activo             = @Activo)
    ORDER BY
        NoInventario;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE EVENTOSESTADO CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_EVENTOSESTADO]
    @idEventoEstado INT           = NULL,
    @Clave          NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Nombre         NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Descripcion    NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @Activo         BIT           = NULL,
    @Bloqueado      BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idEventoEstado,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.EVENTOSESTADO
    WHERE
            (@idEventoEstado IS NULL OR idEventoEstado = @idEventoEstado)
        AND (@Clave          IS NULL OR Clave          LIKE '%' + @Clave + '%')
        AND (@Nombre         IS NULL OR Nombre         LIKE '%' + @Nombre + '%')
        AND (@Descripcion    IS NULL OR Descripcion    LIKE '%' + @Descripcion + '%')
        AND (@Activo         IS NULL OR Activo         = @Activo)
        AND (@Bloqueado      IS NULL OR Bloqueado      = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE EVENTOSINVENTARIO CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_EVENTOSINVENTARIO]
    @idEventoInventario INT           = NULL,
    @Folio              NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño según la tabla real
    @FechaInicioDesde   DATE          = NULL,
    @FechaInicioHasta   DATE          = NULL,
    @FechaTerminoDesde  DATE          = NULL,
    @FechaTerminoHasta  DATE          = NULL,
    @idArea             INT           = NULL,
    @idGeneral          INT           = NULL,
    @idEventoEstado     INT           = NULL,
    @Activo             BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idEventoInventario,
        Folio,
        FechaInicio,
        FechaTermino,
        idArea,
        idGeneral,
        idEventoEstado,
        Activo
    FROM
        dbo.EVENTOSINVENTARIO
    WHERE
            (@idEventoInventario IS NULL OR idEventoInventario = @idEventoInventario)
        AND (@Folio              IS NULL OR Folio              LIKE '%' + @Folio + '%')
        AND (@FechaInicioDesde   IS NULL OR FechaInicio      >= @FechaInicioDesde)
        AND (@FechaInicioHasta   IS NULL OR FechaInicio      <= @FechaInicioHasta)
        AND (@FechaTerminoDesde  IS NULL OR FechaTermino     >= @FechaTerminoDesde)
        AND (@FechaTerminoHasta  IS NULL OR FechaTermino     <= @FechaTerminoHasta)
        AND (@idArea             IS NULL OR idArea           = @idArea)
        AND (@idGeneral          IS NULL OR idGeneral        = @idGeneral)
        AND (@idEventoEstado     IS NULL OR idEventoEstado   = @idEventoEstado)
        AND (@Activo             IS NULL OR Activo           = @Activo)
    ORDER BY
        FechaInicio DESC;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR REGISTROS DE EVENTOSINVENTARIO FILTRADOS POR ID GENERAL Y OTROS FILTROS OPCIONALES
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_EVENTOSINVENTARIO_BYIDGENERAL](
	@IdGeneral INT,
    @idEventoInventario INT           = NULL, -- Nuevos filtros opcionales
    @Folio              NVARCHAR(50)  = NULL,
    @FechaInicioDesde   DATE          = NULL,
    @FechaInicioHasta   DATE          = NULL,
    @FechaTerminoDesde  DATE          = NULL,
    @FechaTerminoHasta  DATE          = NULL,
    @idArea             INT           = NULL,
    @idEventoEstado     INT           = NULL,
    @Activo             BIT           = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EI.idEventoInventario,
        EI.Folio,
        EI.FechaInicio,
        EI.FechaTermino,
        A.Nombre AS NombreArea,
        EI.idGeneral,
        EE.Nombre AS NombreEstadoEvento,
        EI.Activo
    FROM
        dbo.EVENTOSINVENTARIO AS EI
    INNER JOIN
        dbo.AREAS AS A ON EI.idArea = A.idArea
	INNER JOIN
        dbo.EVENTOSESTADO AS EE ON EI.idEventoEstado = EE.idEventoEstado -- Corregido el JOIN
    WHERE
            EI.idGeneral = @IdGeneral -- Este es un filtro obligatorio
        AND (@idEventoInventario IS NULL OR EI.idEventoInventario = @idEventoInventario)
        AND (@Folio              IS NULL OR EI.Folio              LIKE '%' + @Folio + '%')
        AND (@FechaInicioDesde   IS NULL OR EI.FechaInicio      >= @FechaInicioDesde)
        AND (@FechaInicioHasta   IS NULL OR EI.FechaInicio      <= @FechaInicioHasta)
        AND (@FechaTerminoDesde  IS NULL OR EI.FechaTermino     >= @FechaTerminoDesde)
        AND (@FechaTerminoHasta  IS NULL OR EI.FechaTermino     <= @FechaTerminoHasta)
        AND (@idArea             IS NULL OR EI.idArea           = @idArea)
        AND (@idEventoEstado     IS NULL OR EI.idEventoEstado   = @idEventoEstado)
        AND (@Activo             IS NULL OR EI.Activo           = @Activo)
    ORDER BY
        EI.FechaInicio DESC;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE FACTURAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_FACTURAS]
    @idFactura          INT           = NULL,
    @NumeroFactura      NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @FolioFiscal        NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @FechaFacturaDesde  DATE          = NULL,
    @FechaFacturaHasta  DATE          = NULL,
    @idFinanciamiento   INT           = NULL,
    @idUnidadResponsable INT          = NULL,
    @idEstado           INT           = NULL,
    @Nota               NVARCHAR(MAX) = NULL, -- Ajustar el tipo y tamaño
    @Publicar           BIT           = NULL,
    @FechaRegistroDesde DATE          = NULL,
    @FechaRegistroHasta DATE          = NULL,
    @CantidadBienesMin  INT           = NULL,
    @CantidadBienesMax  INT           = NULL,
    @Activo             BIT           = NULL,
    @Archivo            NVARCHAR(MAX) = NULL  -- Ajustar el tipo y tamaño (si se busca por nombre de archivo)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idFactura,
        NumeroFactura,
        FolioFiscal,
        FechaFactura,
        idFinanciamiento,
        idUnidadResponsable,
        idEstado,
        Nota,
        Publicar,
        FechaRegistro,
        CantidadBienes,
        Activo,
        Archivo
    FROM
        dbo.FACTURAS
    WHERE
            (@idFactura          IS NULL OR idFactura          = @idFactura)
        AND (@NumeroFactura      IS NULL OR NumeroFactura      LIKE '%' + @NumeroFactura + '%')
        AND (@FolioFiscal        IS NULL OR FolioFiscal        LIKE '%' + @FolioFiscal + '%')
        AND (@FechaFacturaDesde  IS NULL OR FechaFactura     >= @FechaFacturaDesde)
        AND (@FechaFacturaHasta  IS NULL OR FechaFactura     <= @FechaFacturaHasta)
        AND (@idFinanciamiento   IS NULL OR idFinanciamiento   = @idFinanciamiento)
        AND (@idUnidadResponsable IS NULL OR idUnidadResponsable = @idUnidadResponsable)
        AND (@idEstado           IS NULL OR idEstado           = @idEstado)
        AND (@Nota               IS NULL OR Nota               LIKE '%' + @Nota + '%')
        AND (@Publicar           IS NULL OR Publicar           = @Publicar)
        AND (@FechaRegistroDesde IS NULL OR FechaRegistro    >= @FechaRegistroDesde)
        AND (@FechaRegistroHasta IS NULL OR FechaRegistro    <= @FechaRegistroHasta)
        AND (@CantidadBienesMin  IS NULL OR CantidadBienes   >= @CantidadBienesMin)
        AND (@CantidadBienesMax  IS NULL OR CantidadBienes   <= @CantidadBienesMax)
        AND (@Activo             IS NULL OR Activo             = @Activo)
        AND (@Archivo            IS NULL OR Archivo            LIKE '%' + @Archivo + '%')
    ORDER BY
        FechaFactura DESC;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR REGISTROS DE LEVANTAMIENTOSINVENTARIO FILTRADOS POR ID DE EVENTO Y OTROS FILTROS OPCIONALES
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_LEVANTAMIENTOSINVENTARIO_BY_EVENTO]
    @idEventoInventario INT, -- Este parámetro se mantiene obligatorio por el nombre del SP
    @idLevantamientoInventario INT = NULL,
    @idBien             INT           = NULL,
    @Observaciones      NVARCHAR(MAX) = NULL, -- Ajustar el tipo y tamaño
    @ExisteElBien       BIT           = NULL,
    @FechaVerificacionDesde DATE      = NULL,
    @FechaVerificacionHasta DATE      = NULL,
    @FueActualizado     BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el idEventoInventario exista
    IF NOT EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario)
    BEGIN
        RAISERROR('El ID de Evento de Inventario especificado no existe.', 16, 1);
        RETURN;
    END

    SELECT
        idLevantamientoInventario,
        idBien,
        idEventoInventario,
        Observaciones,
        ExisteElBien,
        FechaVerificacion,
        FueActualizado
    FROM
        dbo.LEVANTAMIENTOSINVENTARIO
    WHERE
            idEventoInventario = @idEventoInventario -- Este es el filtro principal y obligatorio
        AND (@idLevantamientoInventario IS NULL OR idLevantamientoInventario = @idLevantamientoInventario)
        AND (@idBien             IS NULL OR idBien             = @idBien)
        AND (@Observaciones      IS NULL OR Observaciones      LIKE '%' + @Observaciones + '%')
        AND (@ExisteElBien       IS NULL OR ExisteElBien       = @ExisteElBien)
        AND (@FechaVerificacionDesde IS NULL OR FechaVerificacion >= @FechaVerificacionDesde)
        AND (@FechaVerificacionHasta IS NULL OR FechaVerificacion <= @FechaVerificacionHasta)
        AND (@FueActualizado     IS NULL OR FueActualizado     = @FueActualizado)
    ORDER BY
        idLevantamientoInventario;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE MODULOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_MODULOS]
    @idModulo    INT           = NULL,
    @Clave       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Nombre      NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @Descripcion NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idModulo,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.MODULOS
    WHERE
            (@idModulo    IS NULL OR idModulo    = @idModulo)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@Descripcion IS NULL OR Descripcion LIKE '%' + @Descripcion + '%')
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE PERMISOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_PERMISOS]
    @idPermiso   INT           = NULL,
    @Clave       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Nombre      NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @Descripcion NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño
    @idModulo    INT           = NULL,
    @idAccion    INT           = NULL,
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idPermiso,
        Clave,
        Nombre,
        Descripcion,
        idModulo,
        idAccion,
        Activo,
        Bloqueado
    FROM
        dbo.PERMISOS
    WHERE
            (@idPermiso   IS NULL OR idPermiso   = @idPermiso)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@Descripcion IS NULL OR Descripcion LIKE '%' + @Descripcion + '%')
        AND (@idModulo    IS NULL OR idModulo    = @idModulo)
        AND (@idAccion    IS NULL OR idAccion    = @idAccion)
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE REGIONES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_REGIONES]
    @idRegion    INT           = NULL,
    @Clave       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Nombre      NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @idGeneral   INT           = NULL,
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idRegion,
        Clave,
        Nombre,
        idGeneral,
        Activo,
        Bloqueado
    FROM
        dbo.REGIONES
    WHERE
            (@idRegion    IS NULL OR idRegion    = @idRegion)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@idGeneral   IS NULL OR idGeneral   = @idGeneral)
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre; -- Cambiado a Nombre para una mejor UX
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR REGIONES FILTRADAS POR ID GENERAL Y OTROS FILTROS OPCIONALES
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_REGIONES_BY_IDGENERAL]
    @idGeneral   INT, -- Este parámetro se mantiene obligatorio por el nombre del SP
    @idRegion    INT           = NULL, -- Nuevos filtros opcionales
    @Clave       NVARCHAR(50)  = NULL,
    @Nombre      NVARCHAR(100) = NULL,
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idRegion,
        Clave,
        Nombre,
        idGeneral,
        Activo,
        Bloqueado
    FROM
        dbo.REGIONES
    WHERE
            idGeneral = @idGeneral -- Este es el filtro principal y obligatorio
        AND (@idRegion    IS NULL OR idRegion    = @idRegion)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre; -- Cambiado a Nombre para una mejor UX
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE ROLES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_ROLES]
    @idRol       INT           = NULL,
    @Clave       NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Nombre      NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @Descripcion NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño
    @Activo      BIT           = NULL,
    @Bloqueado   BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idRol,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.ROLES
    WHERE
            (@idRol       IS NULL OR idRol       = @idRol)
        AND (@Clave       IS NULL OR Clave       LIKE '%' + @Clave + '%')
        AND (@Nombre      IS NULL OR Nombre      LIKE '%' + @Nombre + '%')
        AND (@Descripcion IS NULL OR Descripcion LIKE '%' + @Descripcion + '%')
        AND (@Activo      IS NULL OR Activo      = @Activo)
        AND (@Bloqueado   IS NULL OR Bloqueado   = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE TRANSFERENCIAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_TRANSFERENCIAS]
    @idTransferencia   INT           = NULL,
    @Folio             NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @FechaRegistroDesde DATE         = NULL,
    @FechaRegistroHasta DATE         = NULL,
    @Observaciones     NVARCHAR(MAX) = NULL, -- Ajustar el tipo y tamaño
    @Responsable       NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @idAreaOrigen      INT           = NULL,
    @idAreaDestino     INT           = NULL,
    @idGeneral         INT           = NULL,
    @Activo            BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idTransferencia,
        Folio,
        FechaRegistro,
        Observaciones,
        Responsable,
        idAreaOrigen,
        idAreaDestino,
        idGeneral,
        Activo
    FROM
        dbo.TRANSFERENCIAS
    WHERE
            (@idTransferencia   IS NULL OR idTransferencia   = @idTransferencia)
        AND (@Folio             IS NULL OR Folio             LIKE '%' + @Folio + '%')
        AND (@FechaRegistroDesde IS NULL OR FechaRegistro   >= @FechaRegistroDesde)
        AND (@FechaRegistroHasta IS NULL OR FechaRegistro   <= @FechaRegistroHasta)
        AND (@Observaciones     IS NULL OR Observaciones     LIKE '%' + @Observaciones + '%')
        AND (@Responsable       IS NULL OR Responsable       LIKE '%' + @Responsable + '%')
        AND (@idAreaOrigen      IS NULL OR idAreaOrigen      = @idAreaOrigen)
        AND (@idAreaDestino     IS NULL OR idAreaDestino     = @idAreaDestino)
        AND (@idGeneral         IS NULL OR idGeneral         = @idGeneral)
        AND (@Activo            IS NULL OR Activo            = @Activo)
    ORDER BY
        Folio DESC;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE UBICACIONESFISICAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_UBICACIONESFISICAS]
    @idUbicacionFisica   INT           = NULL,
    @FechaCapturaDesde   DATE          = NULL,
    @FechaCapturaHasta   DATE          = NULL,
    @idBien              INT           = NULL,
    @FechaTransferenciaDesde DATE      = NULL,
    @FechaTransferenciaHasta DATE      = NULL,
    @idTransferencia     INT           = NULL,
    @Activo              BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idUbicacionFisica,
        FechaCaptura,
        idBien,
        FechaTransferencia,
        idTransferencia,
        Activo
    FROM
        dbo.UBICACIONESFISICAS
    WHERE
            (@idUbicacionFisica   IS NULL OR idUbicacionFisica   = @idUbicacionFisica)
        AND (@FechaCapturaDesde   IS NULL OR FechaCaptura      >= @FechaCapturaDesde)
        AND (@FechaCapturaHasta   IS NULL OR FechaCaptura      <= @FechaCapturaHasta)
        AND (@idBien              IS NULL OR idBien              = @idBien)
        AND (@FechaTransferenciaDesde IS NULL OR FechaTransferencia >= @FechaTransferenciaDesde)
        AND (@FechaTransferenciaHasta IS NULL OR FechaTransferencia <= @FechaTransferenciaHasta)
        AND (@idTransferencia     IS NULL OR idTransferencia     = @idTransferencia)
        AND (@Activo              IS NULL OR Activo              = @Activo)
    ORDER BY
        FechaCaptura DESC;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE UNIDADESRESPONSABLES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_UNIDADESRESPONSABLES]
    @IdUnidadResponsable INT           = NULL,
    @Nombre              NVARCHAR(100) = NULL, -- Ajustar el tipo y tamaño
    @Direccion           NVARCHAR(255) = NULL, -- Ajustar el tipo y tamaño
    @RazonSocial         NVARCHAR(200) = NULL, -- Ajustar el tipo y tamaño
    @RFC                 NVARCHAR(20)  = NULL, -- Ajustar el tipo y tamaño
    @Domicilio           NVARCHAR(255) = NULL, -- Ajustar el tipo y tamaño
    @Telefono            NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Fax                 NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @DomicilioFiscal     NVARCHAR(255) = NULL, -- Ajustar el tipo y tamaño
    @CP                  NVARCHAR(10)  = NULL, -- Ajustar el tipo y tamaño
    @Clave               NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @Activo              BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdUnidadResponsable,
        Nombre,
        Direccion,
        RazonSocial,
        RFC,
        Domicilio,
        Telefono,
        Fax,
        DomicilioFiscal,
        CP,
        Clave,
        Activo
    FROM
        dbo.UNIDADESRESPONSABLES
    WHERE
            (@IdUnidadResponsable IS NULL OR IdUnidadResponsable = @IdUnidadResponsable)
        AND (@Nombre              IS NULL OR Nombre              LIKE '%' + @Nombre + '%')
        AND (@Direccion           IS NULL OR Direccion           LIKE '%' + @Direccion + '%')
        AND (@RazonSocial         IS NULL OR RazonSocial         LIKE '%' + @RazonSocial + '%')
        AND (@RFC                 IS NULL OR RFC                 LIKE '%' + @RFC + '%')
        AND (@Domicilio           IS NULL OR Domicilio           LIKE '%' + @Domicilio + '%')
        AND (@Telefono            IS NULL OR Telefono            LIKE '%' + @Telefono + '%')
        AND (@Fax                 IS NULL OR Fax                 LIKE '%' + @Fax + '%')
        AND (@DomicilioFiscal     IS NULL OR DomicilioFiscal     LIKE '%' + @DomicilioFiscal + '%')
        AND (@CP                  IS NULL OR CP                  LIKE '%' + @CP + '%')
        AND (@Clave               IS NULL OR Clave               LIKE '%' + @Clave + '%')
        AND (@Activo              IS NULL OR Activo              = @Activo);
    -- No hay ORDER BY en el original, se deja sin ORDER BY.
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE USUARIOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_USUARIOS]
    @idUsuario     INT           = NULL,
    @NombreUsuario NVARCHAR(50)  = NULL, -- Ajustar el tipo y tamaño
    @NombreApellidos NVARCHAR(150) = NULL, -- Ajustar el tipo y tamaño
    @Password      NVARCHAR(100) = NULL, -- No es común filtrar por password, pero se incluye por consistencia
    @idGeneral     INT           = NULL,
    @idRol         INT           = NULL,
    @Activo        BIT           = NULL,
    @Bloqueado     BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idUsuario,
        NombreUsuario,
        NombreApellidos,
        Password,
        idGeneral,
        idRol,
        Activo,
        Bloqueado
    FROM
        dbo.USUARIOS
    WHERE
            (@idUsuario     IS NULL OR idUsuario     = @idUsuario)
        AND (@NombreUsuario IS NULL OR NombreUsuario LIKE '%' + @NombreUsuario + '%')
        AND (@NombreApellidos IS NULL OR NombreApellidos LIKE '%' + @NombreApellidos + '%')
        AND (@Password      IS NULL OR Password      LIKE '%' + @Password + '%')
        AND (@idGeneral     IS NULL OR idGeneral     = @idGeneral)
        AND (@idRol         IS NULL OR idRol         = @idRol)
        AND (@Activo        IS NULL OR Activo        = @Activo)
        AND (@Bloqueado     IS NULL OR Bloqueado     = @Bloqueado);
    -- No hay ORDER BY en el original, se deja sin ORDER BY.
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 05/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE USUARIOSPERMISOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_USUARIOSPERMISOS]
    @idUsuarioPermiso INT  = NULL,
    @idUsuario        INT  = NULL,
    @idPermiso        INT  = NULL,
    @Otorgado         BIT  = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idUsuarioPermiso,
        idUsuario,
        idPermiso,
        Otorgado
    FROM
        dbo.UsuariosPermisos
    WHERE
            (@idUsuarioPermiso IS NULL OR idUsuarioPermiso = @idUsuarioPermiso)
        AND (@idUsuario        IS NULL OR idUsuario        = @idUsuario)
        AND (@idPermiso        IS NULL OR idPermiso        = @idPermiso)
        AND (@Otorgado         IS NULL OR Otorgado         = @Otorgado)
    ORDER BY
        idUsuario, idPermiso;
END;
GO