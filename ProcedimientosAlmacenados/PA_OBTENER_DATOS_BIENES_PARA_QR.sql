USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_OBTENER_DATOS_BIENES_PARA_QR]    Script Date: 12/06/2025 10:36:44 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 12/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO OBTENER DATOS PARA EL QR
	Desarrolló: Jairo Martinez
--  PA_OBTENER_DATOS_BIENES_PARA_QR
**********************************************************************************/
ALTER PROCEDURE [dbo].[PA_OBTENER_DATOS_BIENES_PARA_QR]
    @IdsBienes VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        B.idBien,
        B.NoInventario,
        B.Serie,
        B.Modelo,
        M.Nombre AS Marca,
        C.Nombre AS Color,
		F.NumeroFactura
    FROM BIENES B
    LEFT JOIN CAT_MARCAS M ON B.idMarca = M.idMarca
    LEFT JOIN CAT_COLORES C ON B.idColor = C.idColor
	LEFT JOIN FACTURAS F ON B.idFactura = F.idFactura
    WHERE CAST(B.idBien AS VARCHAR(MAX)) IN (SELECT value FROM dbo.fn_SplitString(@IdsBienes, ','));
END
