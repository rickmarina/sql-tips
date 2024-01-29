--partition by primary key we want as unique rows

delete SQ
FROM (
	select
	RID = ROW_NUMBER() OVER (partition by field1, field2 order by (select null)) 
	from @table
) AS SQ
WHERE RID > 1