USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_ModificarPermisoUsuario]    Script Date: 23/04/2025 04:08:18 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 10/04/2025 07:22:35 p. m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA MODIFICAR LOS PERMISOS EN EL USUARIO
	Desarrolló: Jairo Martinez
--  PA_ModificarPermisoUsuario
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_ModificarPermisoUsuario] (
    @idUsuarioPermiso INT,
    @IdPantalla INT,
    @IdGeneral INT,
    @idUsuario INT,
    @idPermiso INT,
    @Otorgado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el registro existe
    IF NOT EXISTS (SELECT 1 FROM UsuariosPermisos WHERE idUsuarioPermiso = @idUsuarioPermiso)
    BEGIN
        RAISERROR('El registro de permiso de usuario con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si ya existe este permiso para el usuario (para otro registro)
    IF EXISTS (SELECT 1 FROM UsuariosPermisos WHERE idUsuario = @idUsuario AND idPermiso = @idPermiso AND idUsuarioPermiso <> @idUsuarioPermiso)
    BEGIN
        RAISERROR('Este permiso ya ha sido asignado al usuario.', 16, 1);
        RETURN;
    END

    -- Actualizar el estado del permiso del usuario
    UPDATE UsuariosPermisos
    SET
        idUsuario = @idUsuario,
        idPermiso = @idPermiso,
        Otorgado = @Otorgado
    WHERE
        idUsuarioPermiso = @idUsuarioPermiso;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE UsuariosPermisos SET idUsuario = ' + CAST(@idUsuario AS VARCHAR(10)) + ', idPermiso = ' + CAST(@idPermiso AS VARCHAR(10)) + ', Otorgado = ''' + CONVERT(VARCHAR(1), @Otorgado) + ''' WHERE idUsuarioPermiso = ' + CAST(@idUsuarioPermiso AS VARCHAR(10));

    EXEC PA_ADM_INS_BITACORA
        'U',
        'UsuariosPermisos',
        @idUsuarioPermiso,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
