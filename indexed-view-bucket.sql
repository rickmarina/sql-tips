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



declare @input int = 103572
declare @bucketSet table (id int)

declare @minBucket int = @input / 1000
declare @lenBucket int = case when @minBucket = 0 then 0 else len(@minBucket) end

while (@lenBucket <= 3) 
BEGIN 
	insert into @bucketSet values (LEFT(@input, @lenBucket))

	SET @lenBucket = @lenBucket + 1
	print @minBucket

END

select * from @bucketSet

select * from vMovs 
inner join @bucketSet bset on bset.id = vMovs.BUCKET
where left(MOVTOR_ID_MOVIMIENTO, len(@input)) = @input