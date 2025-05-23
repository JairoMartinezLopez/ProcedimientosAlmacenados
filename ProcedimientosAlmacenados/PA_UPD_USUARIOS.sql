USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_USUARIOS]    Script Date: 23/04/2025 04:10:31 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ACTUALIZACION EN LA TABLA USUARIOS
	Desarrolló: Jairo Martinez
--  PA_UPD_USUARIOS 
**********************************************************************************/

ALTER PROCEDURE [dbo].[PA_UPD_USUARIOS]
    @idUsuario INT,
	@IdPantalla INT,
	@Nombre VARCHAR(50),
	@Apellidos VARCHAR(100),
	@idGeneral INT,
    @idRol VARCHAR(50),
    @Activo BIT,
    @Bloqueado BIT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE idUsuario = @idUsuario)
    BEGIN
        RAISERROR('Usuario no encontrado.', 16, 1);
        RETURN;
    END

    UPDATE USUARIOS SET Nombre = @Nombre, Apellidos=@Apellidos, idRol = @idRol, Activo = @Activo, Bloqueado = @Bloqueado WHERE idUsuario = @idUsuario;

	-- Construir la consulta para la bitácora (de forma segura)
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE USUARIOS SET ' +
                'Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', ' +
                'Apellidos = ''' + REPLACE(@Apellidos, '''', '''''') + ''', ' +
                'idRol = ' + CONVERT(NVARCHAR(50), ISNULL(@idRol, 0)) + ', ' +
                'Activo = ''' + CONVERT(VARCHAR(1), @Activo) + ''', ' +
                'Bloqueado = ''' + CONVERT(VARCHAR(1), @Bloqueado) + ''' ' +
                'WHERE idUsuario = ' + CONVERT(NVARCHAR(50), ISNULL(@idUsuario, 0));

    -- Llamar al procedimiento almacenado de la bitácora
    EXEC PA_ADM_INS_BITACORA
        'U',           
        'USUARIOS',       
        @idUsuario, 
        @IdGeneral,    
        @IdPantalla,   
        @Consulta;  

END
