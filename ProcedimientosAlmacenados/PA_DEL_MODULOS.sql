USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_MODULOS]    Script Date: 23/04/2025 03:58:25 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 11/04/2025 05:32:58 p. m
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ELIMINACION LOGICA EN LA TABLA MODULOS
	Desarrolló: Jairo Martinez
--  PA_DEL_USUARIOS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_MODULOS] (
    @idModulo INT,
    @IdPantalla INT,
    @IdGeneral INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el módulo existe
    IF NOT EXISTS (SELECT 1 FROM MODULOS WHERE idModulo = @idModulo)
    BEGIN
        RAISERROR('El módulo con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE dbo.MODULOS
    SET
        Activo = 0
    WHERE
        idModulo = @idModulo;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.MODULOS SET Activo = 0 WHERE idModulo = '+CONVERT(NVARCHAR(50),ISNULL(@idModulo,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'D', -- Considera usar 'L' para Lógico si tienes un tipo específico
        'MODULOS',
        @idModulo,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
