USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_DEL_CAT_MARCAS]    Script Date: 23/04/2025 07:46:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA REALIZAR UN BORRADO LÓGICO DE UNA MARCA
	Desarrolló: Jairo Martínez López
--  PA_DEL_CAT_MARCAS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_DEL_CAT_MARCAS] (
    @idMarca INT,
	@IdPantalla INT,
    @IdGeneral INT    
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID de la marca existe
    IF NOT EXISTS (SELECT 1 FROM dbo.CAT_MARCAS WHERE idMarca = @idMarca)
    BEGIN
        RAISERROR('El ID de la marca especificada no existe.', 16, 1);
        RETURN;
    END

    -- Realizar el borrado lógico (marcar como inactivo)
    UPDATE dbo.CAT_MARCAS
    SET
        Activo = 0
    WHERE
        idMarca = @idMarca;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_MARCAS SET Activo = 0 WHERE idMarca = '+CONVERT(NVARCHAR(50),ISNULL(@idMarca,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'D', 
        'CAT_MARCAS',
        @idMarca,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
