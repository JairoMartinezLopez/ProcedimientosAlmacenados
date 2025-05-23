USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_RESET_PASSWORD_USUARIO]    Script Date: 23/04/2025 04:08:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[PA_RESET_PASSWORD_USUARIO]
(
    @idUsuario INT,
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

    -- Encriptar la nueva contraseña
    DECLARE @PasswordHash VARBINARY(64);
    SET @PasswordHash = HASHBYTES('SHA2_256', CONVERT(NVARCHAR(MAX), @NuevaPassword));

    -- Actualizar contraseña
    UPDATE USUARIOS
    SET Password = @PasswordHash
    WHERE idUsuario = @idUsuario;

    -- Registrar en la bitácora
    DECLARE @Consulta NVARCHAR(MAX);
    SET @Consulta = 'UPDATE USUARIOS SET Password = 0x'+CONVERT(VARCHAR(MAX), @PasswordHash, 2)+' WHERE idUsuario = ' + CAST(@idUsuario AS NVARCHAR);

    EXEC PA_ADM_INS_BITACORA
        'U',
        'USUARIOS',
        @idUsuario,
        @IdGeneral,
        @IdPantalla,
        @Consulta;

    RETURN 0;
END
