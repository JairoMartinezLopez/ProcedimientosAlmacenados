USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_PERMISOS]    Script Date: 23/04/2025 04:07:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA INSERCION EN LA TABLA PERMISOS
	Desarrolló: Jairo Martinez
--  PA_INS_PERMISOS 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_PERMISOS] (
    @IdPantalla INT,
    @IdGeneral INT,
    @Clave VARCHAR(50) = NULL,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255) = NULL,
    @idModulo INT,
    @idAccion INT,
    @Activo BIT,
    @Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si ya existe un permiso para el mismo módulo y acción
    IF EXISTS (SELECT 1 FROM PERMISOS WHERE idModulo = @idModulo AND idAccion = @idAccion)
    BEGIN
        RAISERROR('Ya existe un permiso definido para este Módulo y Acción.', 16, 1);
        RETURN;
    END

    -- Verificar si la Clave ya existe
    IF @Clave IS NOT NULL AND EXISTS (SELECT 1 FROM PERMISOS WHERE Clave = @Clave)
    BEGIN
        RAISERROR('La Clave del permiso ya existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el Nombre ya existe
    IF EXISTS (SELECT 1 FROM PERMISOS WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El Nombre del permiso ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO PERMISOS (Clave, Nombre, Descripcion, idModulo, idAccion, Activo, Bloqueado)
    VALUES (@Clave, @Nombre, @Descripcion, @idModulo, @idAccion, @Activo, @Bloqueado);

    -- Obtener el ID del permiso recién insertado
    DECLARE @idPermisoInsertado INT;
    SET @idPermisoInsertado = SCOPE_IDENTITY();

    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO PERMISOS (Clave, Nombre, Descripcion, idModulo, idAccion, Activo, Bloqueado) VALUES (''' + ISNULL(@Clave, 'NULL') + ''', ''' + REPLACE(@Nombre, '''', '''''') + ''', ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', ' + CAST(@idModulo AS VARCHAR(10)) + ', ' + CAST(@idAccion AS VARCHAR(10)) + ', ''' + CONVERT(VARCHAR(1), @Activo) + ''', ''' + CONVERT(VARCHAR(1), @Bloqueado) + ''');';

    EXEC PA_ADM_INS_BITACORA
        'I',
        'PERMISOS',
        @idPermisoInsertado,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
