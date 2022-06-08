-- Se crear una tabla que queramos auditar


-- Se crea otra tabla con los mismos campos TABLA_AUDIT + IDENTITY AUDITORIO (bigint)


-- En la primera tabla creamos un trigger: 

-- En esta versión del trigger se crea una nueva fila en la tabla de auditoría cuando se realizar
-- un update. De esta manera el registro más reciento está en la tabla principal y el histórico en AUDIT
ALTER TRIGGER [dbo].[TR_TRG_upTR_TABLA_ORIGEN]
   ON  [dbo].[TR_TABLA_ORIGEN]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;


	INSERT INTO TABLA_AUDIT
        --(especificar los campos)
     SELECT 
        --(especificar los campos)
	FROM DELETED


END    


-- Podemos crear otro tigger que se ejecute AFTER INSERT, UPDATE y haga copia en la tabla de auditoría 
-- de los datos contenidos en INSERTED. De esta manera tendríamos todos los registros incluido el más reciente. 
