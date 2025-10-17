CREATE PROCEDURE [dbo].[SP_InsertCustomerMaster]
    @FirstName VARCHAR(255) = '',
    @LastName VARCHAR(255) = '', 
	@AgencyName VARCHAR(255) = '',
    @MobileNo VARCHAR(50) ='',
    @EmailID VARCHAR(50)='',
    @Address VARCHAR(255)='',
    @City VARCHAR(100)='',
    @Pincode VARCHAR(50)='',
    @CustomerName VARCHAR(255)='',
    @CustNo VARCHAR(255)='',
    @BranchCode VARCHAR(255)='',
    @LocationCode VARCHAR(255)='',
    @DivisionCode VARCHAR(255)='',
    @SalePerson VARCHAR(255)='',
    @AccountPerson VARCHAR(255)='',
    @UserName VARCHAR(255)='',
	@StateId int=0
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AgentLogin
    (
        UserName,[Password],FirstName,Lastname,Country,AgentApproved,IsActive,UserTypeID,
		AutoTicketing,MobileNumber,Address,City,Pincode,AgentBalance,BalanceFetch,LastLoginDate,LoginFromCountry
		,SubUserEmail,InsertedDate,NoERP,EncryptedPassword,BookingCountry,OTPRequired,NewCurrency
    )
    VALUES
    (
        @CustomerName,'RBT@2025',@FirstName,@LastName,'India',1,1,5,1,@MobileNo,@Address,@City,@Pincode
		,0,'Console',GETDATE(),'IN',@EmailID,GETDATE(),1,'z7tcvrXdhX6s*plus*OO82RZngpBE0bl5qGWxHxu87xOhFMo=','IN',1,'75'
	)
	DECLARE  @AgentID  INT= 0;
	SET @AgentID = SCOPE_IDENTITY();

	IF(@StateID = 0)
	    SET @StateID= NULL
	 
	INSERT INTO B2BRegistration(
        AgencyName, AutoTicketing, FKUserID, PaymentMode, Icast, LocationCode, BranchCode, CustomerCOde, Dates,
        AddrAddressLocation, AddrCity,  AddrZipOrPostCode, AddrLandlineNo, AddrMobileNo, AddrEmail, Country, Status,
           SalesPersonID, SalesPersonName, 
        AccountPerson, AccountPersonName, LoginFromCountry,  
          DivisionCode, CustomerPostingGroup,StateID,Currency
    )
    VALUES (
        @AgencyName, 1, @AgentID, '226,253', @CustomerName, @LocationCode, @BranchCode, @CustomerName, GETDATE(),
        @Address, @City,  @Pincode, @MobileNo, @MobileNo, @EmailID, 'India', 1,
           @SalePerson, @SalePerson,  
        @AccountPerson, @AccountPerson, 'IN',  
          @DivisionCode, 'Trvlnxt',@StateID,'INR'
    );

END
