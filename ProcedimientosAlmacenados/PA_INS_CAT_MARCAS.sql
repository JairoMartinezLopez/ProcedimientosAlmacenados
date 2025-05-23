USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_CAT_MARCAS]    Script Date: 23/04/2025 07:46:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA INSERTAR UNA MARCA
	Desarrolló: Jairo Martínez López
--  PA_INS_CAT_MARCAS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_CAT_MARCAS] (
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

    -- Verificar si el nombre de la marca ya existe
    IF EXISTS (SELECT 1 FROM dbo.CAT_MARCAS WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre de la marca ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar la nueva marca
    INSERT INTO dbo.CAT_MARCAS (Nombre, Activo, Descripcion, Clave, Bloqueado)
    VALUES (@Nombre, ISNULL(@Activo, 1), @Descripcion, @Clave, @Bloqueado);

    -- Obtener el ID de la marca recién insertada
    DECLARE @idMarcaInsertado INT;
    SET @idMarcaInsertado = SCOPE_IDENTITY();

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO dbo.CAT_MARCAS (Nombre, Activo, Descripcion, Clave, Bloqueado) VALUES (''' + REPLACE(@Nombre, '''', '''''') + ''', ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), '1') + ''', ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', ''' + ISNULL(@Clave, 'NULL') + ''', ''' + ISNULL(@Bloqueado, 'NULL') + ''');';

    EXEC dbo.PA_ADM_INS_BITACORA
        'I',
        'CAT_MARCAS',
        @idMarcaInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
