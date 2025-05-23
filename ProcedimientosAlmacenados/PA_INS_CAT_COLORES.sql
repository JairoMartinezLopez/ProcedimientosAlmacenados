USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_CAT_COLORES]    Script Date: 23/04/2025 05:14:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA INSERTAR UN COLOR
	Desarrolló: Jairo Martinez Lopez
--  PA_INS_CAT_COLORES
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_CAT_COLORES] (
    @IdPantalla INT,
    @IdGeneral INT,
    @Nombre NVARCHAR(50),
    @Activo BIT = NULL,
    @Descripcion VARCHAR(200) = NULL,
    @Clave VARCHAR(10) = NULL,
    @Bloqueado BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el nombre del color ya existe
    IF EXISTS (SELECT 1 FROM dbo.CAT_COLORES WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre del color ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo color
    INSERT INTO dbo.CAT_COLORES (Nombre, Activo, Descripcion, Clave, Bloqueado)
    VALUES (@Nombre, ISNULL(@Activo, 1), @Descripcion, @Clave, ISNULL(@Bloqueado, 0));

    -- Obtener el ID del color recién insertado
    DECLARE @idColorInsertado INT;
    SET @idColorInsertado = SCOPE_IDENTITY();

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO dbo.CAT_COLORES (Nombre, Activo, Descripcion, Clave, Bloqueado) VALUES (''' + REPLACE(@Nombre, '''', '''''') + ''', ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), '1') + ''', ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', ''' + ISNULL(@Clave, 'NULL') + ''', ''' + ISNULL(CONVERT(VARCHAR(1), @Bloqueado), '0') + ''');';

    EXEC dbo.PA_ADM_INS_BITACORA
        'I',
        'CAT_COLORES',
        @idColorInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
