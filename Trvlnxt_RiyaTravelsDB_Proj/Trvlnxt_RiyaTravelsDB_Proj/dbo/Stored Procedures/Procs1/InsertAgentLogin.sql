CREATE PROC InsertAgentLogin
	@Icust VARCHAR(100)
	,@oldIcust VARCHAR(100)=''
	,@UserName VARCHAR(100)
	,@FirstName VARCHAR(100)
	,@Address VARCHAR(MAx)
	,@Password VARCHAR(100)
	,@EncryptedPassword VARCHAR(MAX)
	,@MobileNumber VARCHAR(200)
	,@City VARCHAR(100)
	,@Country VARCHAR(100)
	,@Pincode VARCHAR(100)
	,@AgentBalance VARCHAR(100)
	,@UserTypeID VARCHAR(100)
	,@TicketFormate VARCHAR(100)
	,@ParentAgentID INT=0
	,@BookingCountry VARCHAR(50)
	,@FKUserID VARCHAR(50) OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	

	IF NOT EXISTS(Select * from B2BRegistration Where (Icast=@Icust OR Icast=@oldIcust))
	BEGIN
		
		--IF(@Country!='INDIA')
		--BEGIN
		--	Select @Country=CountryName from mCountry Where CountryCode=@Country
		--END

		INSERT INTO AgentLogin
		(UserName,FirstName,Address,Password,EncryptedPassword,MobileNumber,City,Country,ParentAgentID,BookingCountry,
		Pincode,AgentBalance,UserTypeID,TicketFormate,IsActive,AccessFlag,AutoTicketing,AgentApproved,GroupId,InsertedDate,IsB2BAgent,FromScheduler)
		VALUES
		(@UserName,@FirstName,@Address,@Password,@EncryptedPassword,@MobileNumber,@City,@Country,@ParentAgentID,@BookingCountry,
		@Pincode,@AgentBalance,@UserTypeID,@TicketFormate,1,1,1,1,0,GETDATE(),
		(CASE WHEN @UserTypeID=2 THEN 1 ELSE 0 END),1)

		SET @FKUSerID=SCOPE_IDENTITY()		

		INSERT INTO tblCustomerCreationlog
		(ICUST,Status,EntryDate) VALUES (@Icust,'Record Added Successfully.',GETDATE())
	END
	ELSE 
	BEGIN
		SET @FKUSerID=0
		INSERT INTO tblCustomerCreationlog
		(ICUST,Status,EntryDate) VALUES (@Icust,'Duplicate record exist.',GETDATE())
		
	END
END
