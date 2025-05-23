USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_CAT_MARCAS]    Script Date: 23/04/2025 07:47:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA MODIFICAR UNA MARCA
	Desarrolló: Jairo Martínez López
--  PA_UPD_CAT_MARCAS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_CAT_MARCAS] (
    @idMarca INT, 
	@IdPantalla INT,
    @IdGeneral INT,
    @Nombre NVARCHAR(50),
    @Activo BIT = NULL,
    @Descripcion VARCHAR(255) = NULL,
    @Clave VARCHAR(10) = NULL,
    @Bloqueado NCHAR(10) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID de la marca existe
    IF NOT EXISTS (SELECT 1 FROM dbo.CAT_MARCAS WHERE idMarca = @idMarca)
    BEGIN
        RAISERROR('El ID de la marca especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el nuevo nombre de la marca ya existe para otra marca
    IF EXISTS (SELECT 1 FROM dbo.CAT_MARCAS WHERE Nombre = @Nombre AND idMarca <> @idMarca)
    BEGIN
        RAISERROR('El nombre de la marca ya existe para otra marca.', 16, 1);
        RETURN;
    END

    -- Actualizar la marca
    UPDATE dbo.CAT_MARCAS
    SET
        Nombre = @Nombre,
        Activo = ISNULL(@Activo, Activo),
        Descripcion = @Descripcion,
        Clave = @Clave,
        Bloqueado = @Bloqueado
    WHERE
        idMarca = @idMarca;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_MARCAS SET Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Activo = ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), 'Activo') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', Clave = ''' + ISNULL(@Clave, 'NULL') + ''', Bloqueado = ''' + ISNULL(@Bloqueado, 'Bloqueado') + ''' WHERE idMarca = '+CONVERT(NVARCHAR(50),ISNULL(@idMarca,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'U',
        'CAT_MARCAS',
        @idMarca,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
