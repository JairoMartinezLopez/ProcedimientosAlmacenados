USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_ACCIONES]    Script Date: 23/04/2025 03:57:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 11/04/2025 05:32:58 p. m
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ELIMINACON LOGICA EN LA TABLA ACCIONES
	Desarrolló: Jairo Martinez
--  PA_DEL_ACCIONES
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_ACCIONES] (
    @idAccion INT,
    @IdPantalla INT,
    @IdGeneral INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el módulo existe
    IF NOT EXISTS (SELECT 1 FROM ACCIONES WHERE idAccion = @idAccion)
    BEGIN
        RAISERROR('La accion con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE ACCIONES
    SET
        Activo = 0
    WHERE
        idAccion = @idAccion;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE ACCIONES SET Activo = 0 WHERE idAccion = '+CONVERT(NVARCHAR(50),ISNULL(@idAccion,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'D',
        'ACCIONES',
        @idAccion,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
