USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_ACCIONES]    Script Date: 23/04/2025 04:09:28 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 11/04/2025 05:32:58 p. m
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA MODIFICACION EN LA TABLA ACCIONES
	Desarrolló: Jairo Martinez
--  PA_UPD_ACCIONES 
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_UPD_ACCIONES] (
    @idAccion INT,
    @IdPantalla INT,
    @IdGeneral INT,
	@Clave VARCHAR(50),
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(255),
    @Activo BIT,
	@Bloqueado BIT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM ACCIONES WHERE idAccion = @idAccion)
    BEGIN
        RAISERROR('La acción con el ID especificado no existe.', 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM ACCIONES WHERE Nombre = @Nombre AND idAccion <> @idAccion)
    BEGIN
        RAISERROR('El nombre de la acción ya existe para otra acción.', 16, 1);
        RETURN;
    END

    -- Actualizar el módulo
    UPDATE ACCIONES
    SET
		Clave = @Clave,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        Activo = @Activo,
		Bloqueado = @Bloqueado
    WHERE
        idAccion = @idAccion;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE ACCIONES SET Clave =  ''' + REPLACE(@Clave, '''', '''''') + ''', Nombre = ''' + REPLACE(@Nombre, '''', '''''') + ''', Descripcion = ''' + ISNULL(REPLACE(@Descripcion, '''', ''''''), 'NULL') + ''', Activo = ''' + CONVERT(VARCHAR(1), @Activo) + ''', Bloqueado = ''' + CONVERT(VARCHAR(1), @Activo) + ''' WHERE idAccion = ' +CONVERT(NVARCHAR(50),ISNULL(@idAccion,0));

    EXEC PA_ADM_INS_BITACORA
        'U',
        'MODULOS',
        @idAccion,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
