-- Isolation level effective is the indicated in the stored procedure 
-- if nested another sp, the isolation level is inherited unless specified a new one

SELECT CASE transaction_isolation_level 
    WHEN 0 THEN 'Unspecified' 
    WHEN 1 THEN 'ReadUncommitted' 
    WHEN 2 THEN 'ReadCommitted' 
    WHEN 3 THEN 'Repeatable' 
    WHEN 4 THEN 'Serializable' 
    WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
FROM sys.dm_exec_sessions 
where session_id = @@SPID

SET TRANSACTION ISOLATION LEVEL
    { READ UNCOMMITTED
    | READ COMMITTED
    | REPEATABLE READ
    | SNAPSHOT
    | SERIALIZABLE
    }

/* Example */


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE TR_PRO_Test_Isolation1  
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT 'TR_PRO_Test_Isolation1', CASE transaction_isolation_level 
		WHEN 0 THEN 'Unspecified' 
		WHEN 1 THEN 'ReadUncommitted' 
		WHEN 2 THEN 'ReadCommitted' 
		WHEN 3 THEN 'Repeatable' 
		WHEN 4 THEN 'Serializable' 
		WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
	FROM sys.dm_exec_sessions 
	where session_id = @@SPID

	EXEC TR_PRO_Test_Isolation2 --nested sp

	SELECT 'TR_PRO_Test_Isolation1', CASE transaction_isolation_level 
		WHEN 0 THEN 'Unspecified' 
		WHEN 1 THEN 'ReadUncommitted' 
		WHEN 2 THEN 'ReadCommitted' 
		WHEN 3 THEN 'Repeatable' 
		WHEN 4 THEN 'Serializable' 
		WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
	FROM sys.dm_exec_sessions 
	where session_id = @@SPID

END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE TR_PRO_Test_Isolation2
AS
BEGIN

	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

     SELECT 'TR_PRO_Test_Isolation2', CASE transaction_isolation_level 
		WHEN 0 THEN 'Unspecified' 
		WHEN 1 THEN 'ReadUncommitted' 
		WHEN 2 THEN 'ReadCommitted' 
		WHEN 3 THEN 'Repeatable' 
		WHEN 4 THEN 'Serializable' 
		WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL 
	FROM sys.dm_exec_sessions 
	where session_id = @@SPID
END
GO

/* Run Test */

EXEC TR_PRO_Test_Isolation1