USE [bdInventario]
GO

EXEC [dbo].[PA_SEL_ReporteTipoBien]
    @IdGeneral = 50,              -- ID general del usuario o proceso.
    @IdPantalla = 75,             -- ID de la pantalla o m�dulo.
    @idFinanciamiento = 0,        -- 0 = Incluir bienes de cualquier financiamiento.
    @idTipoBien = 17,              -- Filtrar por Tipo de Bien con ID 1.
    @idBien = 0,                  -- 0 = Incluir bienes de cualquier cat�logo de bienes dentro del tipo.
    @idArea = 0,                -- Filtrar por bienes en el �rea con ID 123.
    @Umas = 0,                    -- 1 = Filtrar solo bienes que aplican UMAS (Costo >= 70 * ValorUMA).
    @UnidadResponsable = 0       -- 0 = Incluir bienes de cualquier unidad responsable (asociada al �rea).
GO

EXEC [dbo].[PA_SEL_ReporteTransferenciaConcentrado]
    @IdGeneral = 300,             -- Un ID de usuario o general para el registro en bit�cora.
    @IdPantalla = 45,             -- Un ID de pantalla desde donde se invoca el reporte.
    @idFinanciamiento = 2,        -- 0 = No aplicar filtro de financiamiento (incluir todos).
    @Anio = 2025,                 -- A�o de las transferencias a reportar.
    @Mes = 0,                     -- Mes de las transferencias a reportar (Septiembre).
    @UnidadResponsable = 0,       -- 0 = Filtrar por la unidad responsable con ID 584 (IdAreaOrigen de la transferencia).
    @Umas = 0;  
GO

EXEC [dbo].[PA_SEL_ReporteTransferenciaDesarrollado]
    @IdGeneral = 300,             -- Un ID de usuario o general para el registro en bit�cora.
    @IdPantalla = 45,             -- Un ID de pantalla desde donde se invoca el reporte.
    @idFinanciamiento = 0,        -- 0 = No aplicar filtro de financiamiento (incluir todos).
    @Anio = 2025,                 -- A�o de las transferencias a reportar.
    @Mes = 0,                     -- Mes de las transferencias a reportar (Septiembre).
    @UnidadResponsable = 2,       -- 0 = Filtrar por la unidad responsable con ID 584 (IdAreaOrigen de la transferencia).
    @Umas = 0;  
GO

EXEC [dbo].[PA_SEL_ReporteBajasDetallado]
    @IdGeneral = 1,                 -- ID general para bit�cora (ejemplo)
    @IdPantalla = 101,              -- ID de pantalla para bit�cora (ejemplo)
    @idFinanciamiento = 0,          -- 0 = Todos los financiamientos
    @Anio = 2025,                   -- A�o de las bajas
    @Mes = 0,                       -- 0 = Todos los meses del a�o
    @UnidadResponsable = 0,       -- 0 = Todas las unidades responsables
    @IdArea = 0,                    -- 0 = Todas las �reas
    @Umas = 0;                -- 0 = No filtra por UMAS (incluye todos)
GO

EXEC [dbo].[PA_SEL_ReporteBajasConcentrado]
    @IdGeneral = 1,                 -- ID general para bit�cora (ejemplo)
    @IdPantalla = 101,              -- ID de pantalla para bit�cora (ejemplo)
    @idFinanciamiento = 0,          -- 0 = Todos los financiamientos
    @Anio = 2025,                   -- A�o de las bajas
    @Mes = 0,                       -- 0 = Todos los meses del a�o
    @IdUnidadResponsable = 0,       -- 0 = Todas las unidades responsables
    @IdArea = 0,                    -- 0 = Todas las �reas
    @AplicaUmas = 0;                -- 0 = No filtra por UMAS (incluye todos)
GO

EXEC [dbo].[PA_SEL_ReporteAltasDesglozado]
    @IdGeneral = 101,             -- Un ID de usuario o general para el registro en bit�cora.
    @IdPantalla = 20,             -- Un ID de pantalla desde donde se invoca el reporte.
    @idFinanciamiento = 2,        -- 0 = No aplicar filtro de financiamiento (incluir todos).
    @Anio = 2025,                 -- A�o de las altas a reportar.
    @Mes = 06,                     -- Mes de las altas a reportar (Agosto).
    @UnidadResponsable = 2,       -- 0 = Filtrar por la unidad responsable con ID 584.
    @Umas = 0;                    -- 0 = No aplicar filtro de UMAS (incluir bienes que apliquen o no UMAS).

DECLARE @return_value int;
DECLARE @p_FechaRegistro DATETIME = GETDATE(); -- Fecha y hora actual de la transferencia

EXEC @return_value = [dbo].[PA_INS_TRANSFERENCIA]
    @IdGeneral = 101,
    @Folio = 'TRANSF001',
    @FechaRegistro = @p_FechaRegistro,
    @Observaciones = 'Transferencia de equipo de c�mputo del Departamento A al Departamento B.',
    @Responsable = 'Juan perez',
    @Activo = 1,
    @idAreaOrigen = 584,
    @idAreaDestino = 242,
    @IdGeneralAsignado = 1116,
    @IdPantalla = 1;

SELECT 'Return Value' = @return_value;
GO

SELECT * FROM dbo.TRANSFERENCIAS WHERE Folio = 'TRANS-2025-001';

DECLARE @return_value int

EXEC @return_value = [dbo].[PA_INS_BIENES]
    @IdPantalla = 103,                 -- ID de la pantalla de registro
    @IdGeneral = 203,                  -- ID del usuario que registra
    @idColor = 2,                      -- ID del color (ej. Blanco)
    @FechaAlta = '2025-06-17',         -- Fecha en que el bien fue dado de alta
    @Aviso = NULL,                     -- Sin aviso espec�fico
    @Serie = 'PRIFVERXYZ123126',       -- N�mero de serie de la impresora
    @Modelo = 'LaserJet Pro M404n', -- Modelo de la impresora
    @idEstadoFisico = 1,               -- ID de estado f�sico (ej. Nuevo)
    @idMarca = 1,                      -- ID de la marca (ej. HP)
    @Costo = 147.00,                   -- Costo de la impresora
    @Etiquetado = 1,                   -- Etiquetado
    @FechaEtiquetado = '2025-06-17',   -- Fecha de etiquetado (mismo d�a de alta)
    @Activo = 1,                       -- Activo
    @Disponibilidad = 1,               -- Disponible
    @FechaBaja = NULL,                 -- No dado de baja
    @idCausalBaja = NULL,              -- Sin causal de baja
    @idDisposicionFinal = NULL,        -- Sin disposici�n final
    @idFactura = 12512,                -- Un ID de factura existente diferente
    @PartidaContable = '5120',         -- Partida contable (ej. Equipo de impresi�n y reproducci�n)
    @idCatalogoBien = 10,              -- ID del cat�logo de bien (ej. Impresora)
    @Observaciones = 'Impresora l�ser monocrom�tica.', -- Observaciones
    @Salida = NULL                     -- Sin valor de salida

SELECT 'Return Value' = @return_value
GO

DECLARE @return_value int

EXEC @return_value = [dbo].[PA_INS_BIENES]
    @IdPantalla = 103,                 -- ID de la pantalla de registro
    @IdGeneral = 203,                  -- ID del usuario que registra
    @idColor = 2,                      -- ID del color (ej. Blanco)
    @FechaAlta = '2025-06-17',         -- Fecha en que el bien fue dado de alta
    @Aviso = NULL,                     -- Sin aviso espec�fico
    @Serie = 'PRINTERXYZ123456',       -- N�mero de serie de la impresora
    @Modelo = 'HP LaserJet Pro M404n', -- Modelo de la impresora
    @idEstadoFisico = 1,               -- ID de estado f�sico (ej. Nuevo)
    @idMarca = 1,                      -- ID de la marca (ej. HP)
    @Costo = 852.00,                   -- Costo de la impresora
    @Etiquetado = 1,                   -- Etiquetado
    @FechaEtiquetado = '2025-06-17',   -- Fecha de etiquetado (mismo d�a de alta)
    @Activo = 1,                       -- Activo
    @Disponibilidad = 1,               -- Disponible
    @FechaBaja = NULL,                 -- No dado de baja
    @idCausalBaja = NULL,              -- Sin causal de baja
    @idDisposicionFinal = NULL,        -- Sin disposici�n final
    @idFactura = 12512,                -- Un ID de factura existente diferente
    @PartidaContable = '5120',         -- Partida contable (ej. Equipo de impresi�n y reproducci�n)
    @idCatalogoBien = 8,              -- ID del cat�logo de bien (ej. Impresora)
    @Observaciones = 'Impresora l�ser monocrom�tica, ideal para oficina peque�a.', -- Observaciones
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
    @Aviso = 'Garant�a por 2 a�os con proveedor.', -- Aviso relevante
    @Serie = 'MONITORABC7890DEF',      -- N�mero de serie del monitor
    @Modelo = 'Dell UltraSharp U2723QE', -- Modelo del monitor
    @idEstadoFisico = 1,               -- ID de estado f�sico (ej. Nuevo)
    @idMarca = 4,                      -- ID de la marca (ej. Dell)
    @Costo = 369.50,                   -- Costo del monitor
    @Etiquetado = 0,                   -- No etiquetado a�n
    @FechaEtiquetado = NULL,           -- Fecha de etiquetado nula
    @Activo = 1,                       -- Activo
    @Disponibilidad = 1,               -- Disponible
    @FechaBaja = NULL,                 -- No dado de baja
    @idCausalBaja = NULL,              -- Sin causal de baja
    @idDisposicionFinal = NULL,        -- Sin disposici�n final
    @idFactura = 12512,                -- Un ID de factura existente diferente
    @PartidaContable = '5110',         -- Partida contable (ej. Equipo de c�mputo)
    @idCatalogoBien = 72,              -- ID del cat�logo de bien (ej. Monitor)
    @Observaciones = 'Monitor 27 pulgadas 4K, ideal para dise�o gr�fico y edici�n de video.', -- Observaciones detalladas
    @Salida = NULL                     -- Sin valor de salida

SELECT 'Return Value' = @return_value
GO

USE [bdInventario]
GO

-- Variables comunes para la ejecuci�n
DECLARE @p_FechaTransferencia DATETIME = GETDATE(); -- La fecha en que se realiza la transferencia
DECLARE @p_idTransferencia INT = 2165;             -- ID de la transferencia a la que se asocian los bienes
DECLARE @p_IdPantalla INT = 106;                   -- ID de la pantalla desde la que se realiza la asignaci�n (ej. "Ubicaciones F�sicas")
DECLARE @p_IdGeneral INT = 203;                    -- ID del usuario que realiza la operaci�n

DECLARE @return_value int;

-- Ejecuci�n para el bien 59324
PRINT 'Ejecutando PA_INS_UBICACIONESFISICAS para idBien: 59324';
EXEC @return_value = [dbo].[PA_INS_UBICACIONESFISICAS]
    @idBien = 59324,
    @FechaTransferencia = @p_FechaTransferencia,
    @idTransferencia = @p_idTransferencia,
    @IdPantalla = @p_IdPantalla,
    @IdGeneral = @p_IdGeneral;
SELECT 'Return Value (59324)' = @return_value;

-- Ejecuci�n para el bien 59323
PRINT 'Ejecutando PA_INS_UBICACIONESFISICAS para idBien: 59323';
EXEC @return_value = [dbo].[PA_INS_UBICACIONESFISICAS]
    @idBien = 59323,
    @FechaTransferencia = @p_FechaTransferencia,
    @idTransferencia = @p_idTransferencia,
    @IdPantalla = @p_IdPantalla,
    @IdGeneral = @p_IdGeneral;
SELECT 'Return Value (59323)' = @return_value;

-- Ejecuci�n para el bien 59322
PRINT 'Ejecutando PA_INS_UBICACIONESFISICAS para idBien: 59322';
EXEC @return_value = [dbo].[PA_INS_UBICACIONESFISICAS]
    @idBien = 59322,
    @FechaTransferencia = @p_FechaTransferencia,
    @idTransferencia = @p_idTransferencia,
    @IdPantalla = @p_IdPantalla,
    @IdGeneral = @p_IdGeneral;
SELECT 'Return Value (59322)' = @return_value;

GO

-- Opcional: Verificar los registros insertados/actualizados
-- Puedes verificar que solo hay un registro "Activo = 1" para cada bien
SELECT *
FROM dbo.UBICACIONESFISICAS
WHERE idBien IN (59324, 59323, 59322)
ORDER BY idBien, FechaCaptura DESC;
