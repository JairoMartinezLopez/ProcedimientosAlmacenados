USE [bdInventario]
GO

/**********************************************************************************
	Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE BASE DE DATOS
	Fecha de Creación: 30/05/2025
	Descripción: PROCEDIMIENTO ALMACENADO PARA SELECCIONAR BIENES COMPROBADOS QUE EXISTEN EN UN EVENTO DE INVENTARIO CON FILTROS
	Desarrolló: JAIRO MARTINEZ LOPEZ
--  PA_SEL_BIENES_COMPROBADOS_EN_INVENTARIO
**********************************************************************************/
ALTER PROCEDURE dbo.PA_SEL_BIENES_COMPROBADOS_EN_INVENTARIO (
    @idEventoInventario INT,
    -- Parámetros opcionales para filtros
    @idLevantamientoInventario INT = NULL,
    @idBien              INT           = NULL,
    @NoInventario        NVARCHAR(50)  = NULL, 
    @NombreMarca         NVARCHAR(100) = NULL, 
    @Modelo              NVARCHAR(100) = NULL, 
    @Serie               NVARCHAR(100) = NULL, 
    @ObservacionesLevantamiento NVARCHAR(MAX) = NULL,
    @FechaVerificacionDesde DATE       = NULL,
    @FechaVerificacionHasta DATE       = NULL
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

	DECLARE @AreaEvento INT;
    SELECT @AreaEvento = idArea FROM dbo.EVENTOSINVENTARIO WHERE idEventoInventario = @idEventoInventario;

	DECLARE @NombreAreaTitulo NVARCHAR(200);
	DECLARE @ClaveArea NVARCHAR(50);
	DECLARE @NombreArea NVARCHAR(150);

	SELECT @ClaveArea = Clave,@NombreArea = Nombre FROM AREAS WHERE idArea = @AreaEvento;
	-- Concatena las dos columnas en una sola variable
	SET @NombreAreaTitulo = ISNULL(@ClaveArea, '') + ' - ' + ISNULL(@NombreArea, '');
	
    SELECT @NombreAreaTitulo AS NombreAreaParaTitulo;


    SELECT
        LI.idLevantamientoInventario,
        LI.idBien,
        B.NoInventario,
        M.Nombre AS NombreMarca,
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
        AND LI.ExisteElBien = 1 -- Filtrar solo los bienes que SÍ existen y fueron comprobados
        -- Filtros opcionales
        AND (@idLevantamientoInventario IS NULL OR LI.idLevantamientoInventario = @idLevantamientoInventario)
        AND (@idBien              IS NULL OR LI.idBien            = @idBien)
        AND (@NoInventario        IS NULL OR B.NoInventario       LIKE '%' + @NoInventario + '%')
        AND (@NombreMarca         IS NULL OR M.Nombre             LIKE '%' + @NombreMarca + '%')
        AND (@Modelo              IS NULL OR B.Modelo             LIKE '%' + @Modelo + '%')
        AND (@Serie               IS NULL OR B.Serie              LIKE '%' + @Serie + '%')
        AND (@ObservacionesLevantamiento IS NULL OR LI.Observaciones LIKE '%' + @ObservacionesLevantamiento + '%')
        AND (@FechaVerificacionDesde IS NULL OR LI.FechaVerificacion >= @FechaVerificacionDesde)
        AND (@FechaVerificacionHasta IS NULL OR LI.FechaVerificacion <= @FechaVerificacionHasta)
    ORDER BY
        B.NoInventario;
END;
GO