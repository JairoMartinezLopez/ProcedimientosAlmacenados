USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_INS_ROL]    Script Date: 23/04/2025 04:07:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 10/04/2025 07:22:35 p. m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA INSERCIÓN EN LA TABLA ROLES
	Desarrolló: Jairo Martinez
--  PA_INS_ROL
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_INS_ROL] (
    @IdPantalla INT,
    @IdGeneral INT,
    @Clave VARCHAR(50) = NULL,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255) = NULL,
    @Activo BIT = 1,
    @Bloqueado BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON; 

    -- Verificar si el nombre del rol ya existe
    IF EXISTS (SELECT 1 FROM ROLES WHERE Nombre = @Nombre)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo rol en la tabla Roles
    INSERT INTO ROLES (Clave, Nombre, Descripcion, Activo, Bloqueado)
    VALUES (@Clave, @Nombre, @Descripcion, @Activo, @Bloqueado);

    -- Obtener el ID del rol recién insertado
    DECLARE @idRolInsertado INT;
    SET @idRolInsertado = SCOPE_IDENTITY();

    -- Construir la consulta para la bitácora (de forma segura)
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'INSERT INTO ROLES (Clave, Nombre, Descripcion, Activo, Bloqueado) VALUES ('+@Clave+', '+@Nombre+', '+@Descripcion+',
		'+CONVERT(VARCHAR(1), @Activo)+', '+CONVERT(VARCHAR(1), @Bloqueado)+');';

    -- Llamar al procedimiento almacenado de la bitácora
    EXEC PA_ADM_INS_BITACORA
        'I',           
        'ROLES',       
        @idRolInsertado, 
        @IdGeneral,    
        @IdPantalla,   
        @Consulta;     

END