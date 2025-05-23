USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_OtorgarPermisoUsuario]    Script Date: 23/04/2025 04:08:30 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 10/04/2025 07:22:35 p. m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA OTORGAR PERMISOS AL USUARIO
	Desarrolló: Jairo Martinez
--  PA_OtorgarPermusiUsuario
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_OtorgarPermisoUsuario] (
    @IdPantalla INT,
    @IdGeneral INT,
    @idUsuario INT,
    @idPermiso INT,
    @Otorgado BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si ya existe este permiso para el usuario
    IF EXISTS (SELECT 1 FROM UsuariosPermisos WHERE idUsuario = @idUsuario AND idPermiso = @idPermiso)
    BEGIN
        RAISERROR('Este permiso ya ha sido otorgado al usuario.', 16, 1);
        RETURN;
    END

    -- Insertar el permiso del usuario
    INSERT INTO UsuariosPermisos (idUsuario, idPermiso, Otorgado)
    VALUES (@idUsuario, @idPermiso, @Otorgado);

    -- Obtener el ID del registro recién insertado
    DECLARE @idUsuarioPermisoInsertado INT;
    SET @idUsuarioPermisoInsertado = SCOPE_IDENTITY();

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO UsuariosPermisos (idUsuario, idPermiso, Otorgado) VALUES (' + CAST(@idUsuario AS VARCHAR(10)) + ', ' + CAST(@idPermiso AS VARCHAR(10)) + ', ''' + CONVERT(VARCHAR(1), @Otorgado) + ''');';

    EXEC dbo.PA_ADM_INS_BITACORA
        'I',
        'UsuariosPermisos',
        @idUsuarioPermisoInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
