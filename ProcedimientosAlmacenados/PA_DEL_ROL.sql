USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_ROL]    Script Date: 23/04/2025 03:58:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ELIMINACIÓN LÓGICA EN LA TABLA ROLES
	Desarrolló: Jairo Martinez
--  PA_DEL_ROL 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_ROL] (
    @idRol INT,
    @IdPantalla INT,
    @IdGeneral INT
)
AS
BEGIN
    SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM ROLES WHERE idRol = @idRol)
    BEGIN
        RAISERROR('ROL no encontrado.', 16, 1);
        RETURN;
    END
	IF EXISTS (SELECT 1 FROM ROLES WHERE IdRol = @IdRol AND Activo = 0)
BEGIN
    RAISERROR('El ROL con ID %d ya está dado de baja.', 16, 1, @IdRol);
    RETURN;
END
    UPDATE ROLES
    SET Activo = 0
    WHERE idRol = @idRol;

	DECLARE @Consulta NVARCHAR(255)=''
	SET @Consulta='UPDATE ROLES SET Activo = 0 WHERE idRol = '+CONVERT(NVARCHAR(50),ISNULL(@idRol,0))

    EXEC PA_ADM_INS_BITACORA
        'D',
        'ROLES',
        @idRol,
        @IdGeneral,
        @IdPantalla,
		@Consulta;

END