CREATE PROC UpdateAgentEntityTypeAndName
	@ICUST VARCHAR(100),@EntityType VARCHAR(100),@EntityName VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(Select TOP 1 PKID from B2BRegistration WITH(NOLOCK) WHERE Icast=@ICUST)
	BEGIN
		DECLARE @EntityTypeID  INT=0,@EntityNameID INT=0

		IF(@EntityType!='')
		BEGIN
			Select TOP 1 @EntityTypeID=ID from mCommon WITH(NOLOCK) Where Category='EntityType' AND [Value]=@EntityType
		END
		ELSE
		BEGIN
			SET @EntityTypeID=0

			INSERT INTO tblCustomerCreationlog
			(ICUST,Status,EntryDate)
			VALUES
			(@ICUST,'EntityType Not Found',GETDATE())
		END

		IF(@EntityName!='')
		BEGIN
			Select @EntityNameID=Pkid from tblEntityMaster WITH(NOLOCK) Where EntityName=@EntityName
		END
		ELSE
		BEGIN
			SET @EntityNameID=0

			INSERT INTO tblCustomerCreationlog
			(ICUST,Status,EntryDate)
			VALUES
			(@ICUST,'EntityName Not Found',GETDATE())

		END
	
		UPDATE B2BRegistration SET EntityType=@EntityType,EntityTypeID=@EntityTypeID,
		EntityName=@EntityName,EntityNameID=@EntityNameID WHERE Icast=@ICUST		

	END
	ELSE
	BEGIN
		INSERT INTO tblCustomerCreationlog
		(ICUST,Status,EntryDate)
		VALUES
		(@ICUST,'AEID ICUST NOT FOUND.',GETDATE())
	END
END
