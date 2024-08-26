-- Crear una vista indexada
-- creando un id de bucket para luego poder hacer autocompletados por la primarykey



CREATE VIEW dbo.vMovs
    WITH SCHEMABINDING
AS
	select 
		MOVTOR_ID_MOVIMIENTO, 
		MOVTOR_TX_COMMOD, 
		VESSEL_TX_NOMBRE_BUQUE,
		MOVTOR_ID_MOVIMIENTO / 1000 as BUCKET
	from dbo.TR_MOVTOR

CREATE UNIQUE CLUSTERED INDEX IDX_VMovs ON dbo.vMovs (
    MOVTOR_ID_MOVIMIENTO
);

CREATE NONCLUSTERED INDEX IDX_VMovs_Bucket ON dbo.vMovs (
    BUCKET
);

declare @inputmov int = 103

declare @bucket int = left(@inputmov,3) 

select * from vMovs where bucket = @bucket and left(MOVTOR_ID_MOVIMIENTO, len(@inputmov)) = @inputmov