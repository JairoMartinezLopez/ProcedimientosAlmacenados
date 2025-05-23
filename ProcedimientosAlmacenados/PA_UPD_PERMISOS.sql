USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_PERMISOS]    Script Date: 23/04/2025 04:10:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ACTUALIZACION EN LA TABLA PERMISOS
	Desarrolló: Jairo Martinez
--  PA_UPD_PERMISOS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_PERMISOS] (
    @idPermiso INT,
    @IdPantalla INT,
    @IdGeneral INT,
    @Clave VARCHAR(50) = NULL,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255) = NULL,
    @idModulo INT,
    @idAccion INT,
    @Activo BIT,
    @Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el permiso existe
    IF NOT EXISTS (SELECT 1 FROM PERMISOS WHERE idPermiso = @idPermiso)
    BEGIN
        RAISERROR('El permiso con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si ya existe un permiso para el mismo módulo y acción (para otro permiso)
    IF EXISTS (SELECT 1 FROM PERMISOS WHERE idModulo = @idModulo AND idAccion = @idAccion AND idPermiso <> @idPermiso)
    BEGIN
        RAISERROR('Ya existe un permiso definido para este Módulo y Acción.', 16, 1);
        RETURN;
    END

    -- Verificar si la nueva Clave ya existe para otro permiso
    IF @Clave IS NOT NULL AND EXISTS (SELECT 1 FROM PERMISOS WHERE Clave = @Clave AND idPermiso <> @idPermiso)
    BEGIN
        RAISERROR('La Clave del permiso ya existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el nuevo Nombre ya existe para otro permiso
    IF EXISTS (SELECT 1 FROM PERMISOS WHERE Nombre = @Nombre AND idPermiso <> @idPermiso)
    BEGIN
        RAISERROR('El Nombre del permiso ya existe.', 16, 1);
        RETURN;
    END

    -- Actualizar el permiso
    UPDATE PERMISOS
    SET
        Clave = @Clave,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        idModulo = @idModulo,
        idAccion = @idAccion,
        Activo = @Activo,
        Bloqueado = @Bloqueado
    WHERE
        idPermiso = @idPermiso;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE PERMISOS SET Clave = ''' + ISNULL(@Clave, 'NULL') + ''', Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', idModulo = ' + CAST(@idModulo AS VARCHAR(10)) + ', idAccion = ' + CAST(@idAccion AS VARCHAR(10)) + ', Activo = ''' + CONVERT(VARCHAR(1), @Activo) + ''', Bloqueado = ''' + CONVERT(VARCHAR(1), @Bloqueado) + ''' WHERE idPermiso = '+ CAST(@idPermiso AS VARCHAR(10));

    EXEC PA_ADM_INS_BITACORA
        'U',
        'PERMISOS',
        @idPermiso,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
