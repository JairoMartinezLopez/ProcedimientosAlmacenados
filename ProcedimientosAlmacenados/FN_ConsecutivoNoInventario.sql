USE [bdInventario]
GO
/**********************************************************************************
    Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
    Fecha de Creación: 08/05/2025
    Descripción: FUNCIÓN PARA GENERAR UN NÚMERO DE INVENTARIO CONSECUTIVO
    Desarrolló: JAIRO MARTINEZ LOPEZ
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

    -- Obtener el máximo número de inventario existente para el tipo de bien y catálogo
    SELECT @MaxConsecutivo = MAX(CAST(SUBSTRING(BIN.NoInventario, 17, 4) AS INT))
    FROM dbo.BIENES AS B
    INNER JOIN dbo.BIENES_NOINVENTARIO AS BIN ON B.idBien = BIN.idBien
    INNER JOIN dbo.CAT_BIENES AS CB ON CB.idCatalogoBien = B.idCatalogoBien
    WHERE CB.idTipoBien = @idTipoBien
      AND CB.idCatalogoBien = @idCatalogoBien
      AND B.Activo = 1  -- Incluir filtro de activo para Bienes
      AND BIN.Activo = 1; -- Incluir filtro de activo para Bienes_NoInventario

    -- Calcular el siguiente número de inventario
    SET @MaxConsecutivo = ISNULL(@MaxConsecutivo, 0) + 1;

    -- Formatear el número de inventario con ceros a la izquierda
    SET @NumeroInventario = RIGHT(REPLICATE('0', 4) + CAST(@MaxConsecutivo AS NVARCHAR(4)), 4);

    RETURN @NumeroInventario;
END;
GO
