USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_LOGIN_USUARIO]    Script Date: 23/04/2025 04:08:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 10/04/2025 07:22:35 p. m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA INICIAR SESIÓN
	Desarrolló: Jairo Martinez
--  PA_LOGIN_USUARIO
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_LOGIN_USUARIO] (
    @Usuario INT,
    @Password VARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PasswordAlmacenado VARBINARY(MAX);
    DECLARE @idUsuario INT;
    DECLARE @Nombre VARCHAR(50);
    DECLARE @Apellidos VARCHAR(50);
    DECLARE @idGeneral INT;
    DECLARE @idRol INT;
    DECLARE @Activo BIT;
	DECLARE @Bloqueado BIT;
    DECLARE @RolNombre VARCHAR(50);

    SELECT
        @PasswordAlmacenado = u.Password,
        @idUsuario = u.idUsuario,
        @Nombre = u.Nombre,
        @Apellidos = u.Apellidos,
        @idGeneral = u.idGeneral,
        @idRol = u.idRol,
        @Activo = u.Activo,
		@Bloqueado = u.Bloqueado,
        @RolNombre = r.Nombre
    FROM USUARIOS u
    LEFT JOIN ROLES r ON u.idRol = r.idRol
    WHERE u.idGeneral = @Usuario;

    IF @PasswordAlmacenado IS NULL
    BEGIN
        SELECT 0 AS Resultado, 'Usuario y/o contraseña incorrectos' AS Mensaje;
        RETURN;
    END

	-- Verificar si el usuario está inactivo
    IF @Activo = 0
    BEGIN
        SELECT 0 AS Resultado, 'Este usuario está inactivo y no puede iniciar sesión.' AS Mensaje;
        RETURN;
    END

    -- Verificar si el usuario está bloqueado
    IF @Bloqueado = 1
    BEGIN
        SELECT 0 AS Resultado, 'Este usuario está bloqueado y no puede iniciar sesión.' AS Mensaje;
        RETURN;
    END

    -- Verificar la contraseña

    IF HASHBYTES('SHA2_256', CONVERT(NVARCHAR(MAX), @Password)) = @PasswordAlmacenado
    BEGIN
        SELECT
            1 AS Resultado,
            'Inicio de sesión exitoso' AS Mensaje,
            @idUsuario AS idUsuario,
            @Nombre AS Nombre,
            @Apellidos AS Apellidos,
            @idGeneral AS idGeneral,
            @idRol AS idRol,
            @RolNombre AS RolNombre,
            @Activo AS Activo;
        RETURN;
    END
    ELSE
    BEGIN
        SELECT 0 AS Resultado, 'Usuario y/o contraseña incorrectos' AS Mensaje;
        RETURN;
    END
END
