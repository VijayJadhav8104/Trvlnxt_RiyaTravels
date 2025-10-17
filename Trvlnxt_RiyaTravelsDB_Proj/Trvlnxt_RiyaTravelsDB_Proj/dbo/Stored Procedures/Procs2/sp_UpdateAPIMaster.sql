--sp_UpdateAPIMaster 133,'1.2.3.5','true'
CREATE PROC sp_UpdateAPIMaster	
	@Id INT
	,@IPAddress VARCHAR(MAX)	
	,@IsInternal BIT
	,@UpdatedBy INT=0	
AS
BEGIN
	SET NOCOUNT ON;

	IF(@IsInternal=1)
	BEGIN
		
		INSERT INTO APIAuthenticationMasterHistory
		(pkid,APIKey,IPAddress,AgentID,Status,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)
		Select @Id,APIKey,IPAddress,AgentID,Status,InsertedDate,@UpdatedBy,GETDATE(),1 from APIAuthenticationMaster_Internal
		WHERE ID=@Id

		UPDATE APIAuthenticationMaster_Internal SET
		IPAddress=@IPAddress,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()
		WHERE ID=@Id

		
		
	END
	ELSE
	BEGIN
		
		INSERT INTO APIAuthenticationMasterHistory
		(pkid,APIKey,IPAddress,AgentID,Status,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)
		Select @Id,APIKey,IPAddress,AgentID,Status,InsertedDate,@UpdatedBy,GETDATE(),0 from APIAuthenticationMaster
		WHERE ID=@Id

		UPDATE APIAuthenticationMaster SET
		IPAddress=@IPAddress,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()
		WHERE ID=@Id		

	END
END
