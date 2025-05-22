USE [bdInventario]
GO
/**********************************************************************************
    Elabor�: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
    Fecha de Creaci�n: 08/05/2025
    Descripci�n: FUNCI�N PARA GENERAR UN N�MERO DE INVENTARIO CONSECUTIVO
    Desarroll�: JAIRO MARTINEZ LOPEZ
--  FN_CONSECUTIVONOINVENTARIO
**********************************************************************************/
CREATE FUNCTION [dbo].[FN_ConsecutivoNoInventario](
    @idTipoBien   INT,
    @idCatalogoBien INT
)
RETURNS NVARCHAR(10)
AS
BEGIN
    -- Declarar la variable de retorno
    DECLARE @MaxConsecutivo INT;
    DECLARE @NumeroInventario NVARCHAR(10);

    -- Obtener el m�ximo n�mero de inventario existente para el tipo de bien y cat�logo
    SELECT @MaxConsecutivo = MAX(CAST(SUBSTRING(BIN.NoInventario, 17, 4) AS INT))
    FROM dbo.BIENES AS B
    INNER JOIN dbo.BIENES_NOINVENTARIO AS BIN ON B.idBien = BIN.idBien
    INNER JOIN dbo.CAT_BIENES AS CB ON CB.idCatalogoBien = B.idCatalogoBien
    WHERE CB.idTipoBien = @idTipoBien
      AND CB.idCatalogoBien = @idCatalogoBien
      AND B.Activo = 1  -- Incluir filtro de activo para Bienes
      AND BIN.Activo = 1; -- Incluir filtro de activo para Bienes_NoInventario

    -- Calcular el siguiente n�mero de inventario
    SET @MaxConsecutivo = ISNULL(@MaxConsecutivo, 0) + 1;

    -- Formatear el n�mero de inventario con ceros a la izquierda
    SET @NumeroInventario = RIGHT(REPLICATE('0', 4) + CAST(@MaxConsecutivo AS NVARCHAR(4)), 4);

    RETURN @NumeroInventario;
END;
GO
