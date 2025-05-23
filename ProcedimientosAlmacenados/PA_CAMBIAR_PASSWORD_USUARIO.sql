USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_CAMBIAR_PASSWORD_USUARIO]    Script Date: 23/04/2025 03:59:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PA_CAMBIAR_PASSWORD_USUARIO]
(
    @idUsuario INT,
    @PasswordActual NVARCHAR(100),
    @NuevaPassword NVARCHAR(100),
    @IdGeneral INT,
    @IdPantalla INT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM USUARIOS WHERE idUsuario = @idUsuario)
    BEGIN
        RAISERROR('El usuario no existe.', 16, 1);
        RETURN;
    END

    -- Verificar contraseña actual
    DECLARE @PasswordHashActual VARBINARY(64);
    SET @PasswordHashActual = HASHBYTES('SHA2_256', CONVERT(NVARCHAR(MAX), @PasswordActual));

    IF NOT EXISTS (
        SELECT 1
        FROM USUARIOS
        WHERE idUsuario = @idUsuario AND Password = @PasswordHashActual
    )
    BEGIN
        RAISERROR('La contraseña actual es incorrecta.', 16, 1);
        RETURN;
    END

    -- Cifrar nueva contraseña
    DECLARE @NuevoPasswordHash VARBINARY(MAX);
    SET @NuevoPasswordHash = HASHBYTES('SHA2_256', CONVERT(NVARCHAR(MAX), @NuevaPassword));

    -- Actualizar
    UPDATE USUARIOS
    SET Password = @NuevoPasswordHash
    WHERE idUsuario = @idUsuario;

    DECLARE @Consulta NVARCHAR(MAX) = '';
	SET @Consulta = 'UPDATE USUARIOS SET Password = 0x' + CONVERT(VARCHAR(MAX), @NuevoPasswordHash, 2) +
                ' WHERE idUsuario = ' + CAST(@idUsuario AS NVARCHAR);

    EXEC PA_ADM_INS_BITACORA
        'U',
        'USUARIOS',
        @idUsuario,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
