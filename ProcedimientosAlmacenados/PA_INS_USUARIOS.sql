USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_USUARIOS]    Script Date: 23/04/2025 04:07:32 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA INSERCIÓN EN LA TABLA USUARIOS
	Desarrolló: Jairo Martinez
--  PA_INS_USUARIOS 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_USUARIOS]
	@IdPantalla INT,
	@IdGeneralUsuario INT,
	@Nombre VARCHAR(100),
    @Apellidos VARCHAR(100),
    @Password NVARCHAR(100),
    @idGeneral INT,
    @idRol VARCHAR(50),
    @Activo BIT,
    @Bloqueado BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que idGeneral no exista
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE idGeneral = @idGeneral)
    BEGIN
        RAISERROR('El idGeneral ya está registrado.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo usuario con contraseña cifrada
    INSERT INTO USUARIOS (Nombre, Apellidos, Password, idGeneral, idRol, Activo, Bloqueado)
    VALUES (
        @Nombre,
        @Apellidos,
        HASHBYTES('SHA2_256', CONVERT(NVARCHAR(MAX), @Password)),
        @idGeneral,
        @idRol,
        @Activo,
        @Bloqueado
    );
	DECLARE @idUsuarioInsertado INT;
    SET @idUsuarioInsertado = SCOPE_IDENTITY();

	DECLARE @Consulta NVARCHAR(255)=''
	SET @Consulta='INSERT INTO USUARIOS (Nombre, Apellidos, Password, idGeneral, idRol, Activo, Bloqueado) VALUES ('+@Nombre+', '+@Apellidos+', 
		@Password), '+CONVERT(NVARCHAR(50),ISNULL(@IdGeneral,0))+', '+CONVERT(NVARCHAR(50),ISNULL(@idRol,0))+', '+CONVERT(VARCHAR(1), @Activo)+', '+CONVERT(VARCHAR(1), @Bloqueado)+');'


	EXEC PA_ADM_INS_BITACORA
        'I',
        'USUARIOS',
        @idUsuarioInsertado,
        @IdGeneralUsuario,
        @IdPantalla,
		@Consulta;

END
