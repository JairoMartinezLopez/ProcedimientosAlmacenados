USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_RevocarPermisoUsuario]    Script Date: 23/04/2025 04:08:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 10/04/2025 07:22:35 p. m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA REVOCAR PERMISOS EN LA TABLA PERMISOUSUARIO
	Desarrolló: Jairo Martinez
--  PA_RevocarPermisoUsuario
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_RevocarPermisoUsuario] (
    @idUsuarioPermiso INT,
    @IdPantalla INT,
    @IdGeneral INT
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

    DELETE FROM UsuariosPermisos
    WHERE idUsuarioPermiso = @idUsuarioPermiso;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'DELETE FROM UsuariosPermisos WHERE idUsuarioPermiso = ' + CAST(@idUsuarioPermiso AS VARCHAR(10)) + ';';

    EXEC dbo.PA_ADM_INS_BITACORA
        'D',
        'UsuariosPermisos',
        @idUsuarioPermiso,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
