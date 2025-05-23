USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_MODULOS]    Script Date: 23/04/2025 04:09:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 11/04/2025 05:32:58 p. m
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA MODIFICACIÓN EN LA TABLA MODULOS
	Desarrolló: Jairo Martinez
--  PA_UPD_MODULOS 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_MODULOS] (
    @idModulo INT,
    @IdPantalla INT,
    @IdGeneral INT,
	@Clave VARCHAR(50)= NULL ,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255) = NULL,
    @Activo BIT,
	@Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el módulo existe
    IF NOT EXISTS (SELECT 1 FROM dbo.MODULOS WHERE idModulo = @idModulo)
    BEGIN
        RAISERROR('El módulo con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el nuevo nombre ya existe para otro módulo
    IF EXISTS (SELECT 1 FROM dbo.MODULOS WHERE Nombre = @Nombre AND idModulo <> @idModulo)
    BEGIN
        RAISERROR('El nombre del módulo ya existe para otro módulo.', 16, 1);
        RETURN;
    END

    -- Actualizar el módulo
    UPDATE MODULOS
    SET
		Clave = @Clave,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        Activo = @Activo,
		Bloqueado = @Bloqueado
    WHERE
        idModulo = @idModulo;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.MODULOS SET Clave =  ''' + REPLACE(@Clave, '''', '''''') + ''', Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', Activo = ''' + CONVERT(VARCHAR(1), @Activo) + ''', Bloqueado = ''' + CONVERT(VARCHAR(1), @Bloqueado) + ''' WHERE idModulo = '+CONVERT(NVARCHAR(50),ISNULL(@idModulo,0));

    EXEC PA_ADM_INS_BITACORA
        'U',
        'MODULOS',
        @idModulo,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
