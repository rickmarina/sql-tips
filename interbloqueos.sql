
	DECLARE @RETRIES int = 0
	DECLARE @LOCKNAME varchar(250) = 'xxx' 
	
	RETRY:

	BEGIN TRY
		
		BEGIN TRANSACTION

		DECLARE @RESULT INT
		EXEC @RESULT = sp_getapplock @Resource = @LOCKNAME, @LockMode = 'Exclusive';  

		-- STUFF HERE
	
		EXEC @RESULT = sp_releaseapplock @Resource = @LOCKNAME

		COMMIT TRANSACTION

	 END TRY
	 BEGIN CATCH

        ROLLBACK TRANSACTION
		SET @RETRIES = @RETRIES + 1 

        IF ERROR_NUMBER() = 1205 AND @RETRIES <= 5
        BEGIN
			print concat('Retry ',@LOCKNAME,' #:',@RETRIES)
            WAITFOR DELAY '00:00:00.05'
            GOTO RETRY
        END

    END CATCH