USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_CAT_COLORES]    Script Date: 23/04/2025 05:15:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA REALIZAR UN BORRADO LÓGICO DE UN COLOR
	Desarrolló: Jairo Martinez Lopez
--  PA_DEL_CAT_COLORES
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_CAT_COLORES] (
    @IdPantalla INT,
    @IdGeneral INT,
    @idColor INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID del color existe
    IF NOT EXISTS (SELECT 1 FROM dbo.CAT_COLORES WHERE idColor = @idColor)
    BEGIN
        RAISERROR('El ID del color especificado no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE dbo.CAT_COLORES
    SET
        Activo = 0
    WHERE
        idColor = @idColor;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_COLORES SET Activo = 0 WHERE idColor = '+CONVERT(NVARCHAR(50),ISNULL(@idColor,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'D',
        'CAT_COLORES',
        @idColor,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
