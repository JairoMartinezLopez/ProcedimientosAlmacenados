USE [bdInventario];
GO

EXEC [dbo].[PA_SEL_ReporteBajasDetallado]
    @IdGeneral = 1,                 -- ID general para bitácora (ejemplo)
    @IdPantalla = 101,              -- ID de pantalla para bitácora (ejemplo)
    @idFinanciamiento = 0,          -- 0 = Todos los financiamientos
    @Anio = 2025,                   -- Año de las bajas
    @Mes = 0,                       -- 0 = Todos los meses del año
    @UnidadResponsable = 0,       -- 0 = Todas las unidades responsables
    @IdArea = 0,                    -- 0 = Todas las áreas
    @Umas = 0;                -- 0 = No filtra por UMAS (incluye todos)
GO

USE [bdInventario];
GO

EXEC [dbo].[PA_SEL_ReporteBajasConcentrado]
    @IdGeneral = 1,                 -- ID general para bitácora (ejemplo)
    @IdPantalla = 101,              -- ID de pantalla para bitácora (ejemplo)
    @idFinanciamiento = 0,          -- 0 = Todos los financiamientos
    @Anio = 2025,                   -- Año de las bajas
    @Mes = 0,                       -- 0 = Todos los meses del año
    @IdUnidadResponsable = 0,       -- 0 = Todas las unidades responsables
    @IdArea = 0,                    -- 0 = Todas las áreas
    @AplicaUmas = 0;                -- 0 = No filtra por UMAS (incluye todos)
GO
use [bdInventario]
go

EXEC [dbo].[PA_SEL_ReporteAltasDesglozado]
    @IdGeneral = 101,             -- Un ID de usuario o general para el registro en bitácora.
    @IdPantalla = 20,             -- Un ID de pantalla desde donde se invoca el reporte.
    @idFinanciamiento = 2,        -- 0 = No aplicar filtro de financiamiento (incluir todos).
    @Anio = 2025,                 -- Año de las altas a reportar.
    @Mes = 06,                     -- Mes de las altas a reportar (Agosto).
    @UnidadResponsable = 2,       -- 0 = Filtrar por la unidad responsable con ID 584.
    @Umas = 0;                    -- 0 = No aplicar filtro de UMAS (incluir bienes que apliquen o no UMAS).

	USE [bdInventario]
GO

DECLARE @return_value int

EXEC @return_value = [dbo].[PA_INS_BIENES]
    @IdPantalla = 103,                 -- ID de la pantalla de registro
    @IdGeneral = 203,                  -- ID del usuario que registra
    @idColor = 2,                      -- ID del color (ej. Blanco)
    @FechaAlta = '2025-06-17',         -- Fecha en que el bien fue dado de alta
    @Aviso = NULL,                     -- Sin aviso específico
    @Serie = 'PRINTERXYZ123456',       -- Número de serie de la impresora
    @Modelo = 'HP LaserJet Pro M404n', -- Modelo de la impresora
    @idEstadoFisico = 1,               -- ID de estado físico (ej. Nuevo)
    @idMarca = 1,                      -- ID de la marca (ej. HP)
    @Costo = 852.00,                   -- Costo de la impresora
    @Etiquetado = 1,                   -- Etiquetado
    @FechaEtiquetado = '2025-06-17',   -- Fecha de etiquetado (mismo día de alta)
    @Activo = 1,                       -- Activo
    @Disponibilidad = 1,               -- Disponible
    @FechaBaja = NULL,                 -- No dado de baja
    @idCausalBaja = NULL,              -- Sin causal de baja
    @idDisposicionFinal = NULL,        -- Sin disposición final
    @idFactura = 12511,                -- Un ID de factura existente diferente
    @PartidaContable = '5120',         -- Partida contable (ej. Equipo de impresión y reproducción)
    @idCatalogoBien = 8,              -- ID del catálogo de bien (ej. Impresora)
    @Observaciones = 'Impresora láser monocromática, ideal para oficina pequeña. Capacidad de impresión a doble cara.', -- Observaciones
    @Salida = NULL                     -- Sin valor de salida

SELECT 'Return Value' = @return_value
GO

USE [bdInventario]
GO

DECLARE @return_value int

EXEC @return_value = [dbo].[PA_INS_BIENES]
    @IdPantalla = 102,                 -- ID de la pantalla de registro
    @IdGeneral = 202,                  -- ID del usuario que registra
    @idColor = 1,                      -- ID del color (ej. Negro)
    @FechaAlta = '2025-06-18',         -- Fecha en que el bien fue dado de alta
    @Aviso = 'Garantía por 2 años con proveedor.', -- Aviso relevante
    @Serie = 'MONITORABC7890DEF',      -- Número de serie del monitor
    @Modelo = 'Dell UltraSharp U2723QE', -- Modelo del monitor
    @idEstadoFisico = 1,               -- ID de estado físico (ej. Nuevo)
    @idMarca = 4,                      -- ID de la marca (ej. Dell)
    @Costo = 369.50,                   -- Costo del monitor
    @Etiquetado = 0,                   -- No etiquetado aún
    @FechaEtiquetado = NULL,           -- Fecha de etiquetado nula
    @Activo = 1,                       -- Activo
    @Disponibilidad = 1,               -- Disponible
    @FechaBaja = NULL,                 -- No dado de baja
    @idCausalBaja = NULL,              -- Sin causal de baja
    @idDisposicionFinal = NULL,        -- Sin disposición final
    @idFactura = 12511,                -- Un ID de factura existente diferente
    @PartidaContable = '5110',         -- Partida contable (ej. Equipo de cómputo)
    @idCatalogoBien = 72,              -- ID del catálogo de bien (ej. Monitor)
    @Observaciones = 'Monitor 27 pulgadas 4K, ideal para diseño gráfico y edición de video. Incluye cable HDMI y DisplayPort.', -- Observaciones detalladas
    @Salida = NULL                     -- Sin valor de salida

SELECT 'Return Value' = @return_value
GO