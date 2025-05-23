USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_CAT_COLORES]    Script Date: 23/04/2025 05:15:33 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA MODIFICAR UN COLOR
	Desarrolló: Jairo Martinez Lopez
--  PA_UPD_CAT_COLORES
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_CAT_COLORES] (
    @IdPantalla INT,
    @IdGeneral INT,
    @idColor INT,
    @Nombre NVARCHAR(50),
    @Activo BIT = NULL,
    @Descripcion VARCHAR(200) = NULL,
    @Clave VARCHAR(10) = NULL,
    @Bloqueado BIT = NULL
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

    -- Verificar si el nuevo nombre del color ya existe para otro color
    IF EXISTS (SELECT 1 FROM dbo.CAT_COLORES WHERE Nombre = @Nombre AND idColor <> @idColor)
    BEGIN
        RAISERROR('El nombre del color ya existe para otro color.', 16, 1);
        RETURN;
    END

    -- Actualizar el color
    UPDATE dbo.CAT_COLORES
    SET
        Nombre = @Nombre,
        Activo = ISNULL(@Activo, Activo),
        Descripcion = @Descripcion,
        Clave = @Clave,
        Bloqueado = ISNULL(@Bloqueado, Bloqueado)
    WHERE
        idColor = @idColor;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_COLORES SET Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Activo = ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), 'Activo') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', Clave = ''' + ISNULL(@Clave, 'NULL') + ''', Bloqueado = ''' + ISNULL(CONVERT(VARCHAR(1), @Bloqueado), 'Bloqueado') + ''' WHERE idColor = '+CONVERT(NVARCHAR(50),ISNULL(@idColor,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'U',
        'CAT_COLORES',
        @idColor,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
