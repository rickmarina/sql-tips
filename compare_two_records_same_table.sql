DECLARE @Tabla NVARCHAR(128) = 'TableName';
DECLARE @PKCol NVARCHAR(128) = 'Id';
DECLARE @Id1 INT = 1; -- First id to compare
DECLARE @Id2 INT = 2; -- Second id to compare
DECLARE @sql NVARCHAR(MAX) = '';

-- version stuff sql server < 2012
SELECT @sql = 
    STUFF((
        SELECT ' UNION ALL
        SELECT ''' + c.COLUMN_NAME + ''' AS Columna, 
               CAST(t1.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)) AS Valor1, 
               CAST(t2.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)) AS Valor2
        FROM ' + QUOTENAME(@Tabla) + ' t1
        JOIN ' + QUOTENAME(@Tabla) + ' t2 
            ON t1.' + QUOTENAME(@PKCol) + ' = ' + CAST(@Id1 AS NVARCHAR) + '
           AND t2.' + QUOTENAME(@PKCol) + ' = ' + CAST(@Id2 AS NVARCHAR) + '
        WHERE ISNULL(CAST(t1.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)), '''') 
             <> ISNULL(CAST(t2.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)), '''')'
        FROM INFORMATION_SCHEMA.COLUMNS c
        WHERE c.TABLE_NAME = @Tabla
          AND c.COLUMN_NAME <> @PKCol
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 11, '');

PRINT @sql; -- para depuración
EXEC sp_executesql @sql;


-- ersion string_agg sql server > 2012
SELECT @sql = STRING_AGG(
    'SELECT ''' + c.COLUMN_NAME + ''' AS Columna, 
            CAST(t1.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)) AS Valor1, 
            CAST(t2.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)) AS Valor2
     FROM ' + @Tabla + ' t1
     JOIN ' + @Tabla + ' t2 ON t1.' + @PKCol + ' = ' + CAST(@Id1 AS NVARCHAR) + 
    ' AND t2.' + @PKCol + ' = ' + CAST(@Id2 AS NVARCHAR) + '
     WHERE ISNULL(CAST(t1.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)), '''') 
        <> ISNULL(CAST(t2.' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)), '''')'
, ' UNION ALL ')
FROM INFORMATION_SCHEMA.COLUMNS c
WHERE c.TABLE_NAME = @Tabla
  AND c.COLUMN_NAME <> @PKCol;

EXEC sp_executesql @sql;