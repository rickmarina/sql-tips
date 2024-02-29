-- Generic method to find out which columns have been updated inside the trigger

declare @updatedcolumns varbinary(max) = COLUMNS_UPDATED()
declare @updatedcolumnsNames varchar(max) 
declare @tableName varchar(250) = ''


declare @infoupdate table (
	colName varchar(250),
	colId int, 
	updatedColumns varbinary(max),
	bytePosition int,
	bitPosition int,
	bitValue int
)

;WITH TABLESCHEMA (colName, colId) AS (
	SELECT COLUMN_NAME, COLUMNPROPERTY(OBJECT_ID(@tableName), COLUMN_NAME, 'ColumnId') 
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @tableName
)
insert into @infoupdate 
select	s.colName, 
		s.colId,
		@updatedcolumns as updatedColumns,
		(s.colId -1)/8 +1 as bytePosition,
		(s.colId -1) % 8 as bitPosition,
		CAST(SUBSTRING(@updatedcolumns, (s.colId -1)/8 +1, 1) AS INT) & POWER(2, (s.colId-1) % 8) as bitValue
from TABLESCHEMA s

select * from @infoupdate

--now @infoupdate contains all the columnnames modified