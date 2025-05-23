USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_ROL]    Script Date: 23/04/2025 04:10:18 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 08/04/2025 12:15:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA ACTUALIZACION EN LA TABLA ROLES
	Desarrolló: Jairo Martinez
--  PA_UPD_ROL 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_ROL] (
    @idRol INT,
    @IdPantalla INT,
    @IdGeneral INT,
    @Clave VARCHAR(50) = NULL,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255)= NULL,
    @Activo BIT = 1,
    @Bloqueado BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el rol con el ID proporcionado existe
    IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE idRol = @idRol)
    BEGIN
        RAISERROR('El rol con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el nuevo nombre del rol ya existe para otro rol
    IF EXISTS (SELECT 1 FROM dbo.Roles WHERE Nombre = @Nombre AND idRol <> @idRol)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END

    -- Actualizar el rol en la tabla Roles
    UPDATE Roles
    SET
        Clave = @Clave,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        Activo = @Activo,
        Bloqueado = @Bloqueado
    WHERE
        idRol = @idRol;

    -- Construir la consulta para la bitácora (de forma segura)
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE Roles SET Clave = ''' + ISNULL(@Clave, 'NULL') + ''', Nombre = ''' + @Nombre + ''', Descripcion = ''' + ISNULL(@Descripcion, 'NULL') + ''', Activo = ' + CONVERT(VARCHAR(1), @Activo) + ', Bloqueado = ' + CONVERT(VARCHAR(1), @Bloqueado) + ' WHERE idRol = ' + CONVERT(NVARCHAR(50),ISNULL(@idRol,0));

    EXEC PA_ADM_INS_BITACORA
        'U',           
        'ROLES',       
        @idRol, 
        @IdGeneral,    
        @IdPantalla,   
        @Consulta; 
END
