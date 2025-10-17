CREATE PROCEDURE [dbo].[SP_InsertAgentCreation]
    @FirstName VARCHAR(255) = '',
    @LastName VARCHAR(255)='',
    @MobileNo VARCHAR(50) ='',
    @ContactNo VARCHAR(50)='',
    @EmailID VARCHAR(50)='',
    @Address VARCHAR(255)='',
    @City VARCHAR(100)='',
    @Pincode VARCHAR(50)='',
    @Country VARCHAR(50)='',
    @StateID int =0,
    @UserType VARCHAR(50)='',
    @CustomerPostingGroup VARCHAR(255)='',
    @CustomerName VARCHAR(255)='',
    @CustNo VARCHAR(255)='',
    @BranchCode VARCHAR(255)='',
    @LocationCode VARCHAR(255)='',
    @DivisionCode VARCHAR(255)='',
    @SalePerson VARCHAR(255)='',
    @AccountPerson VARCHAR(255)='',
    @UserName VARCHAR(255)='',
    @PaymentMode VARCHAR(255)='',
    @LoginForCountry VARCHAR(50)='',
    @EntityType VARCHAR(255)='',
    @Password VARCHAR(255)='',
    @BillingID VARCHAR(255)='',
    @BalanceFetch VARCHAR(250)='',
    @CustomerBalance VARCHAR(250)='',
    @EncryptedPassword VARCHAR(200)='',
    @CountryCode VARCHAR(20)='',
	@NewCurrency VARCHAR(50) = null,
	@BillingEntity VARCHAR(255) = null,
	@EntityName VARCHAR(255) = null,
	@Currency VARCHAR(255) = null,
	@B2BRegID INT OUTPUT,
    @AgentID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AgentLogin
    (
        UserName,[Password],FirstName,LastName,Country,AgentApproved,IsActive,UserTypeID,
		AutoTicketing,MobileNumber,Address,City,Pincode,AgentBalance,BalanceFetch,LastLoginDate,LoginFromCountry
		,SubUserEmail,InsertedDate,NoERP,EncryptedPassword,BookingCountry,OTPRequired,NewCurrency,createdby
    )
    VALUES
    (
        @CustNo,@Password,@FirstName,@LastName,@Country,1,1,2,1,@MobileNo,@Address,@City,@Pincode
		,@CustomerBalance,@BalanceFetch,GETDATE(),@Country,@EmailID,GETDATE(),1,@EncryptedPassword,@CountryCode,1,@NewCurrency,1
	)

	SET @AgentID = SCOPE_IDENTITY();

	 INSERT INTO AgentRights VALUES(@AgentID,'Flights',1,1,NULL,1,GETDATE(),NULL,NULL,1,NULL)
	 INSERT INTO AgentRights VALUES(@AgentID,'Hotels',2,1,NULL,1,GETDATE(),NULL,NULL,1,NULL)
	 INSERT INTO AgentRights VALUES(@AgentID,'Rail',11,1,NULL,1,GETDATE(),NULL,NULL,1,NULL)
	 INSERT INTO AgentRights VALUES(@AgentID,'Activities',12,1,NULL,1,GETDATE(),NULL,NULL,1,NULL)
	 INSERT INTO AgentRights VALUES(@AgentID,'Transfers',15,1,NULL,1,GETDATE(),NULL,NULL,1,NULL)


	 DECLARE @MenuID INT , @MenuID1 INT,@MenuID2 INT,@MenuID3 INT,@MenuID4 INT;

	 SELECT @MenuID = ID  from mMenu where MenuName='Activities'
	 INSERT INTO mAgentMapping values(@AgentID,@MenuID,GETDATE(),1,GETDATE(),Null,1)

	 SELECT @MenuID1 = ID  from mMenu where MenuName='Book Hotel'
	 INSERT INTO mAgentMapping values(@AgentID,@MenuID1,GETDATE(),1,GETDATE(),Null,1)

	 SELECT @MenuID2 = ID  from mMenu where MenuName='Hotels'
	 INSERT INTO mAgentMapping values(@AgentID,@MenuID2,GETDATE(),1,GETDATE(),Null,1)

	 SELECT @MenuID3 = ID  from mMenu where MenuName='Manage Hotel booking'
	 INSERT INTO mAgentMapping values(@AgentID,@MenuID3,GETDATE(),1,GETDATE(),Null,1)
	 
	 SELECT @MenuID4 = ID  from mMenu where MenuName='Rail' and module ='trvlnxt'
	 INSERT INTO mAgentMapping values(@AgentID,@MenuID4,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID5 int = 0
	  SELECT @MenuID5 = ID  from mMenu where MenuName='Agent Account Statement' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID5,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID6 int = 0
	  SELECT @MenuID6 = ID  from mMenu where MenuName='Booking' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID6,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID7 int = 0
	  SELECT @MenuID7 = ID  from mMenu where MenuName='Cancellation Request' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID7,GETDATE(),1,GETDATE(),Null,1)

	   DECLARE @MenuID8 int = 0
	  SELECT @MenuID8 = ID  from mMenu where MenuName='Hold' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID8,GETDATE(),1,GETDATE(),Null,1)

	   DECLARE @MenuID9 int = 0
	  SELECT @MenuID9 = ID  from mMenu where MenuName='Pending Tickets' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID9,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID10 int = 0
	  SELECT @MenuID10 = ID  from mMenu where MenuName='Retrieve PNR' and module ='trvlnxt' and  Products='flights'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID10,GETDATE(),1,GETDATE(),Null,1)

	   DECLARE @MenuID11 int = 0
	  SELECT @MenuID11 = ID  from mMenu where MenuName='Cancelation report' and module ='trvlnxt' and  Products='Hotel'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID11,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID12 int = 0
	  SELECT @MenuID12 = ID  from mMenu where MenuName='PNRwise Report' and module ='trvlnxt' and  Products='Hotel'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID12,GETDATE(),1,GETDATE(),Null,1)

	  DECLARE @MenuID13 int = 0
	  SELECT @MenuID13 = ID  from mMenu where MenuName='Summary Report' and module ='trvlnxt' and  Products='Hotel'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID13,GETDATE(),1,GETDATE(),Null,1)

	   DECLARE @MenuID14 int = 0
	  SELECT @MenuID14 = ID  from mMenu where MenuName='Transaction Report' and module ='trvlnxt' and  Products='Hotel'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID14,GETDATE(),1,GETDATE(),Null,1)

	   DECLARE @MenuID15 int = 0
	  SELECT @MenuID15 = ID  from mMenu where MenuName='Transfers' and module ='trvlnxt' and  Products='Transfers'
      INSERT INTO mAgentMapping values(@AgentID,@MenuID15,GETDATE(),1,GETDATE(),Null,1)
		
	  IF(@StateID = 0)
	    SET @StateID= NULL

	INSERT INTO B2BRegistration(
        AgencyName, AutoTicketing, FKUserID, PaymentMode, Icast, LocationCode, BranchCode, CustomerCOde, Dates,
        AddrAddressLocation, AddrCity,  AddrZipOrPostCode, AddrLandlineNo, AddrMobileNo, AddrEmail, Country, Status,
           SalesPersonID, SalesPersonName, 
        AccountPerson, AccountPersonName, LoginFromCountry, EntityType, 
         BillingID, DivisionCode, CustomerPostingGroup,StateID,EntityTypeID,Currency,BillingEntity,EntityName,EntityNameID,createdby
    )
    VALUES (
        @CustomerName, 1, @AgentID, '226,253', @CustNo, @LocationCode, @BranchCode, @CustNo, GETDATE(),
        @Address, @City,  @Pincode, @ContactNo, @MobileNo, @EmailID, @Country, 1,
           @SalePerson, @SalePerson,  
        @AccountPerson, @AccountPerson, @CountryCode, @EntityType, 
         @BillingID, @DivisionCode, @CustomerPostingGroup,@StateID,265,@Currency,@BillingEntity,@EntityName,2966,1
    );

	SET @B2BRegID = SCOPE_IDENTITY();
	SELECT @B2BRegID AS B2BRegID, @AgentID AS AgentID;
	
	
    
	
END
