USE [bdInventario]
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 30/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR BIENES COMPROBADOS QUE EXISTEN EN UN EVENTO DE INVENTARIO
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_SEL_BIENES_COMPROBADOS_EN_INVENTARIO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_SEL_BIENES_COMPROBADOS_EN_INVENTARIO (
    @idEventoInventario INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que idEventoInventario exista en la tabla EVENTOSINVENTARIO
    IF NOT EXISTS (SELECT 1 FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario)
    BEGIN
        RAISERROR('El ID de Evento de Inventario especificado no existe.', 16, 1);
        RETURN;
    END

    SELECT
        LI.idLevantamientoInventario,
        LI.idBien,
        B.NoInventario,
        M.Nombre AS Marca,
        B.Modelo,
        B.Serie,
        LI.Observaciones AS ObservacionesLevantamiento,
        LI.FechaVerificacion,
        A.Nombre AS AreaDelEvento -- Para contexto, si es necesario mostrar el área
    FROM
        dbo.LEVANTAMIENTOSINVENTARIO AS LI
    INNER JOIN
        dbo.BIENES AS B ON LI.idBien = B.idBien
    LEFT JOIN
        dbo.CAT_MARCAS AS M ON B.idMarca = M.idMarca
    INNER JOIN
        dbo.EVENTOSINVENTARIO AS EI ON LI.idEventoInventario = EI.idEventoInventario
    INNER JOIN
        dbo.AREAS AS A ON EI.idArea = A.idArea
    WHERE
        LI.idEventoInventario = @idEventoInventario
        AND LI.ExisteElBien = 1; -- Filtrar solo los bienes que SÍ existen y fueron comprobados

    RETURN 0;
END
GO