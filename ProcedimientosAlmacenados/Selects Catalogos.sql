USE [bdInventario]
GO
/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_BIENES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_BIENES]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idCatalogoBien,
        idTipoBien,
        Nombre,
        Clave,
        Descripcion,
		Activo,
        Bloqueado
    FROM
        dbo.CAT_BIENES
    ORDER BY
        Nombre; -- Generalmente se ordena por el nombre para cat�logos
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_CAUSALBAJAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_CAUSALBAJAS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idCausalBaja,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_CAUSALBAJAS
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_COLORES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_COLORES]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idColor,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_COLORES
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_DISPOSICIONESFINALES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_DISPOSICIONESFINALES]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idDisposicionFinal,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_DISPOSICIONESFINALES
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_ESTADOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_ESTADOS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idEstado,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_ESTADOS
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_ESTADOSFISICOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_ESTADOSFISICOS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idEstadoFisico,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_ESTADOSFISICOS
    ORDER BY
        Nombre;
END;
GO


/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_FINANCIAMIENTOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_FINANCIAMIENTOS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idFinanciamiento,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_FINANCIAMIENTOS
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_MARCAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_MARCAS]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idMarca,
		Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_MARCAS
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 03/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE CAT_TIPOSBIENES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_CAT_TIPOSBIENES]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        --idTipoBien,
        Clave,
        Nombre,
		Descripcion,
        Activo,
        Bloqueado
    FROM
        dbo.CAT_TIPOSBIENES
    ORDER BY
        Nombre;
END;
GO