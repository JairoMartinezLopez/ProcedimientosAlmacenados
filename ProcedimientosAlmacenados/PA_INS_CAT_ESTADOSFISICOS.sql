USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_CAT_ESTADOSFISICOS]    Script Date: 23/04/2025 06:47:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA INSERTAR UN ESTADO FÍSICO
	Desarrolló: Jairo Martinez Lopez
--  PA_INS_CAT_ESTADOSFISICOS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_CAT_ESTADOSFISICOS] (
    @IdPantalla INT,
    @IdGeneral INT,
    @Nombre NVARCHAR(50),
    @Activo BIT,
    @Descripcion VARCHAR(255),
    @Clave VARCHAR(10),
    @Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el nombre del estado físico ya existe
    IF EXISTS (SELECT 1 FROM dbo.CAT_ESTADOSFISICOS WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre del estado físico ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo estado físico
    INSERT INTO dbo.CAT_ESTADOSFISICOS (Nombre, Activo, Descripcion, Clave, Bloqueado)
    VALUES (@Nombre, ISNULL(@Activo, 1), @Descripcion, @Clave, ISNULL(@Bloqueado, 0));

    -- Obtener el ID del estado físico recién insertado
    DECLARE @idEstadoFisicoInsertado INT;
    SET @idEstadoFisicoInsertado = SCOPE_IDENTITY();

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO dbo.CAT_ESTADOSFISICOS (Nombre, Activo, Descripcion, Clave, Bloqueado) VALUES (''' + REPLACE(@Nombre, '''', '''''') + ''', ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), '1') + ''', ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', ''' + ISNULL(@Clave, 'NULL') + ''', ''' + ISNULL(CONVERT(VARCHAR(1), @Bloqueado), '0') + ''');';

    EXEC dbo.PA_ADM_INS_BITACORA
        'I',
        'CAT_ESTADOSFISICOS',
        @idEstadoFisicoInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
