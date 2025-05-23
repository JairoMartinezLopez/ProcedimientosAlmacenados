USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_PERMISOS]    Script Date: 23/04/2025 03:58:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ELIMINACION LOGICA EN LA TABLA PERMISOS
	Desarrolló: Jairo Martinez
--  PA_DEL_PERMISOS 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_PERMISOS] (
    @idPermiso INT,
    @IdPantalla INT,
    @IdGeneral INT
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

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE PERMISOS
    SET
        Activo = 0
    WHERE
        idPermiso = @idPermiso;

    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE PERMISOS SET Activo = 0 WHERE idPermiso = ' + CAST(@idPermiso AS VARCHAR(10)) + ';';

    EXEC PA_ADM_INS_BITACORA
        'D',
        'PERMISOS',
        @idPermiso,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
