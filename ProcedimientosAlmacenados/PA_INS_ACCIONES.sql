USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_ACCIONES]    Script Date: 23/04/2025 04:06:14 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 11/04/2025 05:32:58 p. m
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA INSERCIÓN EN LA TABLA ACCIONES
	Desarrolló: Jairo Martinez
--  PA_INS_ACCIONES
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_ACCIONES] (
    @IdPantalla INT,
    @IdGeneral INT,
	@Clave VARCHAR(50) = NULL,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255) = NULL,
    @Activo BIT = 1,
	@Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el nombre del módulo ya existe
    IF EXISTS (SELECT 1 FROM ACCIONES WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre del módulo ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo módulo
    INSERT INTO ACCIONES(Clave, Nombre, Descripcion, Activo, Bloqueado)
    VALUES (@Clave, @Nombre, @Descripcion, @Activo, @Bloqueado);

    -- Obtener el ID del módulo recién insertado
    DECLARE @idAccionInsertado INT;
    SET @idAccionInsertado = SCOPE_IDENTITY();

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO ACCIONES (Clave, Nombre, Descripcion, Activo, Bloqueado) VALUES (''' +REPLACE(@Clave, '''', '''''') +''', '''+ REPLACE(@Nombre, '''', '''''') + ''', ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', ''' + CONVERT(VARCHAR(1), @Activo) +''', '''+ CONVERT(VARCHAR(1), @Bloqueado) + ''');';

    EXEC PA_ADM_INS_BITACORA
        'I',
        'MODULOS',
        @idAccionInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END