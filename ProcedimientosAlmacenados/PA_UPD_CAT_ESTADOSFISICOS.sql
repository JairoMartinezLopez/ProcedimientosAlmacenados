USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_CAT_ESTADOSFISICOS]    Script Date: 23/04/2025 06:48:16 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 23/04/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA MODIFICAR UN ESTADO FÍSICO
	Desarrolló: Jairo Martinez Lopez
--  PA_UPD_CAT_ESTADOSFISICOS
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_CAT_ESTADOSFISICOS] (
    @IdPantalla INT,
    @IdGeneral INT,
    @idEstadoFisico INT,
    @Nombre NVARCHAR(50),
    @Activo BIT,
    @Descripcion VARCHAR(255),
    @Clave VARCHAR(10),
    @Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el ID del estado físico existe
    IF NOT EXISTS (SELECT 1 FROM dbo.CAT_ESTADOSFISICOS WHERE idEstadoFisico = @idEstadoFisico)
    BEGIN
        RAISERROR('El ID del estado físico especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el nuevo nombre del estado físico ya existe para otro estado físico
    IF EXISTS (SELECT 1 FROM dbo.CAT_ESTADOSFISICOS WHERE Nombre = @Nombre AND idEstadoFisico <> @idEstadoFisico)
    BEGIN
        RAISERROR('El nombre del estado físico ya existe para otro estado físico.', 16, 1);
        RETURN;
    END

    -- Actualizar el estado físico
    UPDATE dbo.CAT_ESTADOSFISICOS
    SET
        Nombre = @Nombre,
        Activo = ISNULL(@Activo, Activo),
        Descripcion = @Descripcion,
        Clave = @Clave,
        Bloqueado = ISNULL(@Bloqueado, Bloqueado)
    WHERE
        idEstadoFisico = @idEstadoFisico;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE dbo.CAT_ESTADOSFISICOS SET Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Activo = ''' + ISNULL(CONVERT(VARCHAR(1), @Activo), 'Activo') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', Clave = ''' + ISNULL(@Clave, 'NULL') + ''', Bloqueado = ''' + ISNULL(CONVERT(VARCHAR(1), @Bloqueado), 'Bloqueado') + ''' WHERE idEstadoFisico ='+CONVERT(NVARCHAR(50),ISNULL(@idEstadoFisico,0));

    EXEC dbo.PA_ADM_INS_BITACORA
        'U',
        'CAT_ESTADOSFISICOS',
        @idEstadoFisico,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
