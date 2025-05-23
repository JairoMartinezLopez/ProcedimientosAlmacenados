USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_CAT_ESTADOSFISICOS]    Script Date: 23/04/2025 06:47:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA REALIZAR UN BORRADO LÓGICO DE UN ESTADO FÍSICO
	Desarrolló: Jairo Martinez Lopez
--  PA_DEL_CAT_ESTADOSFISICOS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_CAT_ESTADOSFISICOS] (
    @IdPantalla INT,
    @IdGeneral INT,
    @idEstadoFisico INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID del estado físico existe
    IF NOT EXISTS (SELECT 1 FROM dbo.CAT_ESTADOSFISICOS WHERE idEstadoFisico = @idEstadoFisico)
    BEGIN
        RAISERROR('El ID del estado físico especificado no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE dbo.CAT_ESTADOSFISICOS
    SET
        Activo = 0
    WHERE
        idEstadoFisico = @idEstadoFisico;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_ESTADOSFISICOS SET Activo = 0 WHERE idEstadoFisico = '+CONVERT(NVARCHAR(50),ISNULL(@idEstadoFisico,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'D', 
        'CAT_ESTADOSFISICOS',
        @idEstadoFisico,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
