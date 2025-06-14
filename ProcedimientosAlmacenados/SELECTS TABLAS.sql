USE [bdInventario]
GO
/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE ACCIONES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_ACCIONES]
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
    ORDER BY
        Nombre; -- Se ordena por Nombre, que es una columna descriptiva.
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE AREAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_AREAS]
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
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE BIENES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_BIENES]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        idBien,
        idColor,
        FechaRegistro,
        FechaAlta,
        Aviso,
        Serie,
        Modelo,
        idEstadoFisico,
        idMarca,
        Costo,
        Etiquetado,
        FechaEtiquetado,
        Disponibilidad,
        FechaBaja,
        idCausalBaja,
        idDisposicionFinal,
        idFactura,
        NoInventario,
        idCatalogoBien,
        Observaciones,
        AplicaUMAS,
        Salida,
		Activo
    FROM
        dbo.BIENES
    ORDER BY
        NoInventario; -- Se ordena por el n�mero de inventario para una lista l�gica.
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE EVENTOSESTADO
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_EVENTOSESTADO]
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
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE EVENTOSINVENTARIO
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_EVENTOSINVENTARIO]
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
    ORDER BY
        FechaInicio DESC; -- Ordenar por fecha de inicio m�s reciente
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE EVENTOSINVENTARIO
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_SEL_EVENTOSINVENTARIO_BYIDGENERAL](
	@IdGeneral INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        EI.idEventoInventario,
        EI.Folio,
        EI.FechaInicio,
        EI.FechaTermino,
        -- Ahora seleccionamos el Nombre del �rea en lugar de solo el IdArea
        A.Nombre AS NombreArea, -- Asignamos un alias para mayor claridad en el resultado
        EI.idGeneral,
        EE.Nombre AS NombreEstadoEvento,
        EI.Activo
    FROM
        dbo.EVENTOSINVENTARIO AS EI -- Usamos alias 'EI' para EVENTOSINVENTARIO
    INNER JOIN
        dbo.AREAS AS A ON EI.idArea = A.idArea-- Unimos con la tabla AREAS
	INNER JOIN
        dbo.EVENTOSESTADO AS EE ON EE.idEventoEstado = EI.idEventoEstado
    WHERE
        EI.idGeneral = @IdGeneral
    ORDER BY
        EI.FechaInicio DESC; -- Ordenar por fecha de inicio m�s reciente
	
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE FACTURAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_FACTURAS]
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
    ORDER BY
        FechaFactura DESC; -- Ordenar por fecha de factura m�s reciente
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR REGISTROS DE LEVANTAMIENTOSINVENTARIO FILTRADOS POR ID DE EVENTO
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_LEVANTAMIENTOSINVENTARIO_BY_EVENTO]
    @idEventoInventario INT
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
        idEventoInventario = @idEventoInventario
    ORDER BY
        idLevantamientoInventario; -- O por FechaVerificacion, idBien, etc., seg�n la necesidad de orden
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE MODULOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_MODULOS]
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
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE PERMISOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_PERMISOS]
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
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE REGIONES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_REGIONES]
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
    ORDER BY
        idRegion;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR REGIONES FILTRADAS POR ID GENERAL
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_REGIONES_BY_IDGENERAL]
    @idGeneral INT
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
        idGeneral = @idGeneral
    ORDER BY
        idRegion;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE ROLES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_ROLES]
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
    ORDER BY
        Nombre;
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE TRANSFERENCIAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_TRANSFERENCIAS]
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
    ORDER BY
        Folio DESC; -- Ordenar por la fecha de registro m�s reciente
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE UBICACIONESFISICAS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_UBICACIONESFISICAS]
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
    ORDER BY
        FechaCaptura DESC; -- Ordenar por la fecha de captura m�s reciente
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE UNIDADESRESPONSABLES
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_UNIDADESRESPONSABLES]
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
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE USUARIOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_USUARIOS]
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
END;
GO

/**********************************************************************************
	Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creaci�n: 05/06/2025
	Descripci�n: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR TODOS LOS REGISTROS DE USUARIOSPERMISOS
	Desarroll�: JAIRO MARTINEZ LOPEZ
**********************************************************************************/
CREATE PROCEDURE [dbo].[PA_SEL_USUARIOSPERMISOS]
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
    ORDER BY
        idUsuario, idPermiso;
END;
GO