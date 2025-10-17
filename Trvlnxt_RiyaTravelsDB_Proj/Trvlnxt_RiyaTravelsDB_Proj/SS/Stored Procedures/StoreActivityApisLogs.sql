         
 CREATE Proc [SS].[StoreActivityApisLogs]             
	 @URL VARCHAR(200) ='',            
	 @Request VARCHAR(MAX) ='',            
	 @Response VARCHAR(MAX) ='',             
	 @Header VARCHAR(MAX) ='',            
	 @MethodName VARCHAR(MAX) ='',          
	 @CorrelationId VARCHAR(MAX) ='',         
	 @AgentId VARCHAR(MAX) ='',      
	 @Timmer VARCHAR(MAX) ='',    
	 @IP VARCHAR(100) ='',
	 @token VARCHAR(1000) ='',
	 @LogId INT =0
 AS            
 BEGIN            
	IF(@LogId != 0 )
	BEGIN
		UPDATE [AllAppLogs].[SS].ActivityApiLogs 
		SET Response=@Response 
		WHERE id=@LogId
	END
	ELSE 
	BEGIN
		INSERT INTO [AllAppLogs].[SS].ActivityApiLogs
			(URL, Request, Response, Header, MethodName, InsertedDate, CorrelationId, AgentId, Timmer, IP, Token)             
        VALUES
			(@URL, @Request, @Response, @Header, @MethodName, GetDate(), @CorrelationId, @AgentId, @Timmer, @IP, @token)            	
    
		SET @LogId = SCOPE_IDENTITY()
	END	
    
	SELECT @LogId AS LogId
 END
