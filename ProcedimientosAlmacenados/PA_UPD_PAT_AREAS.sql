USE [bdInventario]
GO
/****** Object:  StoredProcedure [dbo].[PA_UPD_PAT_AREAS]    Script Date: 23/04/2025 04:09:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
    Elaboró: PODER JUDICIAL DEL ESTADO DE OAXACA - DEPARTAMENTO DE DESARROLLO DE SISTEMAS
	Fecha de Creación: 28/01/2021 02:45:10 p.m.
	Descripción: PROCEDIMIENTO ALMACENADO PARA LA INSERCIÓN EN LA TABLA PAT_CATBIENES
	Desarrolló: josue g
-- =============================================*/

ALTER PROCEDURE [dbo].[PA_UPD_PAT_AREAS]
( 
	-- Add the parameters for the stored procedure here
	 @IdGeneral		AS	Int,
     @IdAreaSistemaUsuario		AS	Int,
     @IdPantalla		AS	Int,
     @idArea		AS	int OUT,
     @Clave			AS	NVARCHAR(20),
	 @Nombre		AS	NVarChar(200),
	 @Direccion		AS	NVarChar(500),
	 @idAreaPadre	AS INT,
	 @Activo		AS BIT,
	 @IdUnidadResponsable		as int,
     @PermitirEntradas		AS	bit,
	 @PermitirSalidas	as bit
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @ids table (id int)
	declare	@id	 as int
    -- Insert statements for procedure here
	update PAT_AREAS set 
			Clave=@Clave,
			Nombre=@Nombre,
			Direccion=@Direccion,
			Activo=@Activo,
			IdUnidadResponsable=@IdUnidadResponsable,
			PermitirEntradas=@PermitirEntradas,
			PermitirSalidas=@PermitirSalidas
		 where idArea=@idArea

   DECLARE @ncBitacora	AS	NVARCHAR (1000)
   SET	@ncBitacora	=	' WHERE idArea	='     +	CONVERT(NVARCHAR(MAX),@idArea)

	select @idArea
	EXECUTE sp_InsBITACORA 
		'U', 
		'PAT_AREAS', 
		@idArea, 
		@IdGeneral, 
		@IdPantalla,
		@ncBitacora  
	
END

