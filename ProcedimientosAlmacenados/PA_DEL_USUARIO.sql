USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_USUARIO]    Script Date: 23/04/2025 03:59:13 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ELIMINACIÓN LÓGICA EN LA TABLA USUARIOS
	Desarrolló: Jairo Martinez
--  PA_DEL_USUARIOS 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_USUARIO]
    @idUsuario INT,
    @IdPantalla INT,
    @IdGeneral INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE idUsuario = @idUsuario)
    BEGIN
        RAISERROR('Usuario no encontrado.', 16, 1);
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM USUARIOS WHERE idUsuario = @idUsuario AND Activo = 0)
    BEGIN
        RAISERROR('El usuario ya está dado de baja.', 16, 1);
        RETURN;
    END
    UPDATE USUARIOS
    SET Activo = 0
    WHERE idUsuario = @idUsuario;

	DECLARE @Consulta NVARCHAR(255)=''
	SET @Consulta='UPDATE USUARIOS SET Activo = 0 WHERE idUsuario = '+CONVERT(NVARCHAR(50),ISNULL(@idUsuario,0))

    EXEC PA_ADM_INS_BITACORA
        'D',
        'USUARIOS',
        @idUsuario,
        @IdGeneral,
        @IdPantalla,
		@Consulta;
END;
