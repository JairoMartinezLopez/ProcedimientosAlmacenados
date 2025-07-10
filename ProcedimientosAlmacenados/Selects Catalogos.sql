USE [bdInventario];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_BIENES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_BIENES]
    @idCatalogoBien INT         = NULL,
    @idTipoBien     INT         = NULL,
    @Nombre         NVARCHAR(100) = NULL,
    @Clave          NVARCHAR(50)  = NULL,
    @Descripcion    NVARCHAR(200) = NULL,
    @Activo         BIT           = NULL,
    @Bloqueado      BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idCatalogoBien, 
        idTipoBien,
        Nombre,
        Clave,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_BIENES
    WHERE
            (@idCatalogoBien IS NULL OR idCatalogoBien = @idCatalogoBien)
        AND (@idTipoBien     IS NULL OR idTipoBien     = @idTipoBien)
        AND (@Nombre         IS NULL OR Nombre         LIKE '%' + @Nombre + '%')
        AND (@Clave          IS NULL OR Clave          LIKE '%' + @Clave + '%')
        AND (@Descripcion    IS NULL OR Descripcion    LIKE '%' + @Descripcion + '%')
        AND (@Activo         IS NULL OR Activo         = @Activo)
        AND (@Bloqueado      IS NULL OR Bloqueado      = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_CAUSALBAJAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_CAUSALBAJAS]
    @idCausalBaja INT           = NULL,
    @Clave        NVARCHAR(50)  = NULL,
    @Nombre       NVARCHAR(100) = NULL,
    @Descripcion  NVARCHAR(200) = NULL,
    @Activo       BIT           = NULL,
    @Bloqueado    BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idCausalBaja,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_CAUSALBAJAS
    WHERE
            (@idCausalBaja IS NULL OR idCausalBaja = @idCausalBaja)
        AND (@Clave        IS NULL OR Clave        LIKE '%' + @Clave + '%')
        AND (@Nombre       IS NULL OR Nombre       LIKE '%' + @Nombre + '%')
        AND (@Descripcion  IS NULL OR Descripcion  LIKE '%' + @Descripcion + '%')
        AND (@Activo       IS NULL OR Activo       = @Activo)
        AND (@Bloqueado    IS NULL OR Bloqueado    = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_COLORES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_COLORES]
    @idColor      INT           = NULL,
    @Clave        NVARCHAR(50)  = NULL,
    @Nombre       NVARCHAR(100) = NULL,
    @Descripcion  NVARCHAR(200) = NULL,
    @Activo       BIT           = NULL,
    @Bloqueado    BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idColor,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_COLORES
    WHERE
            (@idColor      IS NULL OR idColor      = @idColor)
        AND (@Clave        IS NULL OR Clave        LIKE '%' + @Clave + '%')
        AND (@Nombre       IS NULL OR Nombre       LIKE '%' + @Nombre + '%')
        AND (@Descripcion  IS NULL OR Descripcion  LIKE '%' + @Descripcion + '%')
        AND (@Activo       IS NULL OR Activo       = @Activo)
        AND (@Bloqueado    IS NULL OR Bloqueado    = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_DISPOSICIONESFINALES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_DISPOSICIONESFINALES]
    @idDisposicionFinal INT           = NULL,
    @Clave              NVARCHAR(50)  = NULL,
    @Nombre             NVARCHAR(100) = NULL,
    @Descripcion        NVARCHAR(200) = NULL,
    @Activo             BIT           = NULL,
    @Bloqueado          BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idDisposicionFinal,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_DISPOSICIONESFINALES
    WHERE
            (@idDisposicionFinal IS NULL OR idDisposicionFinal = @idDisposicionFinal)
        AND (@Clave              IS NULL OR Clave              LIKE '%' + @Clave + '%')
        AND (@Nombre             IS NULL OR Nombre             LIKE '%' + @Nombre + '%')
        AND (@Descripcion        IS NULL OR Descripcion        LIKE '%' + @Descripcion + '%')
        AND (@Activo             IS NULL OR Activo             = @Activo)
        AND (@Bloqueado          IS NULL OR Bloqueado          = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_ESTADOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_ESTADOS]
    @idEstado     INT           = NULL,
    @Clave        NVARCHAR(50)  = NULL,
    @Nombre       NVARCHAR(100) = NULL,
    @Descripcion  NVARCHAR(200) = NULL,
    @Activo       BIT           = NULL,
    @Bloqueado    BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idEstado,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_ESTADOS
    WHERE
            (@idEstado     IS NULL OR idEstado     = @idEstado)
        AND (@Clave        IS NULL OR Clave        LIKE '%' + @Clave + '%')
        AND (@Nombre       IS NULL OR Nombre       LIKE '%' + @Nombre + '%')
        AND (@Descripcion  IS NULL OR Descripcion  LIKE '%' + @Descripcion + '%')
        AND (@Activo       IS NULL OR Activo       = @Activo)
        AND (@Bloqueado    IS NULL OR Bloqueado    = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_ESTADOSFISICOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_ESTADOSFISICOS]
    @idEstadoFisico INT           = NULL,
    @Clave          NVARCHAR(50)  = NULL,
    @Nombre         NVARCHAR(100) = NULL,
    @Descripcion    NVARCHAR(200) = NULL,
    @Activo         BIT           = NULL,
    @Bloqueado      BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idEstadoFisico,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_ESTADOSFISICOS
    WHERE
            (@idEstadoFisico IS NULL OR idEstadoFisico = @idEstadoFisico)
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
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_FINANCIAMIENTOS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_FINANCIAMIENTOS]
    @idFinanciamiento INT           = NULL, 
    @Clave            NVARCHAR(50)  = NULL,
    @Nombre           NVARCHAR(100) = NULL,
    @Descripcion      NVARCHAR(200) = NULL,
    @Activo           BIT           = NULL,
    @Bloqueado        BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idFinanciamiento,
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_FINANCIAMIENTOS
    WHERE
            (@idFinanciamiento IS NULL OR idFinanciamiento = @idFinanciamiento)
        AND (@Clave            IS NULL OR Clave            LIKE '%' + @Clave + '%')
        AND (@Nombre           IS NULL OR Nombre           LIKE '%' + @Nombre + '%')
        AND (@Descripcion      IS NULL OR Descripcion      LIKE '%' + @Descripcion + '%')
        AND (@Activo           IS NULL OR Activo           = @Activo)
        AND (@Bloqueado        IS NULL OR Bloqueado        = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_MARCAS CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_MARCAS]
    @idMarca      INT           = NULL, 
    @Clave        NVARCHAR(50)  = NULL,
    @Nombre       NVARCHAR(100) = NULL,
    @Descripcion  NVARCHAR(200) = NULL,
    @Activo       BIT           = NULL,
    @Bloqueado    BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idMarca, 
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_MARCAS
    WHERE
            (@idMarca      IS NULL OR idMarca      = @idMarca)
        AND (@Clave        IS NULL OR Clave        LIKE '%' + @Clave + '%')
        AND (@Nombre       IS NULL OR Nombre       LIKE '%' + @Nombre + '%')
        AND (@Descripcion  IS NULL OR Descripcion  LIKE '%' + @Descripcion + '%')
        AND (@Activo       IS NULL OR Activo       = @Activo)
        AND (@Bloqueado    IS NULL OR Bloqueado    = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 03/06/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_TIPOSBIENES CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_TIPOSBIENES]
    @idTipoBien   INT           = NULL, 
    @Clave        NVARCHAR(50)  = NULL,
    @Nombre       NVARCHAR(100) = NULL,
    @Descripcion  NVARCHAR(200) = NULL,
    @Activo       BIT           = NULL,
    @Bloqueado    BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idTipoBien, 
        Clave,
        Nombre,
        Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_TIPOSBIENES
    WHERE
            (@idTipoBien   IS NULL OR idTipoBien   = @idTipoBien)
        AND (@Clave        IS NULL OR Clave        LIKE '%' + @Clave + '%')
        AND (@Nombre       IS NULL OR Nombre       LIKE '%' + @Nombre + '%')
        AND (@Descripcion  IS NULL OR Descripcion  LIKE '%' + @Descripcion + '%')
        AND (@Activo       IS NULL OR Activo       = @Activo)
        AND (@Bloqueado    IS NULL OR Bloqueado    = @Bloqueado)
    ORDER BY
        Nombre;
END;
GO