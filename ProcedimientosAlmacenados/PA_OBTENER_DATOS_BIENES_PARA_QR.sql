USE [bdInventario]
GO
/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 12/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO OBTENER DATOS PARA EL QR
	Desarrolló: Jairo Martinez
--  PA_OBTENER_DATOS_BIENES_PARA_QR
**********************************************************************************/
ALTER PROCEDURE PA_OBTENER_DATOS_BIENES_PARA_QR
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
        C.Nombre AS Color        
    FROM BIENES B
    LEFT JOIN CAT_MARCAS M ON B.idMarca = M.idMarca
    LEFT JOIN CAT_COLORES C ON B.idColor = C.idColor
    WHERE CAST(B.idBien AS VARCHAR(MAX)) IN (SELECT value FROM dbo.fn_SplitString(@IdsBienes, ','));
END
