CREATE PROC InsertB2BRegistration
	@AgencyName VARCHAR(100)
	,@CustomerCOde VARCHAR(100)
	,@Icast VARCHAR(100)
	,@AddrAddressLocation VARCHAR(MAx)
	,@AddrEmail VARCHAR(100)
	,@AddrMobileNo VARCHAR(200)	
	,@AddrCity VARCHAR(100)
	,@Country VARCHAR(100)
	,@AddrZipOrPostCode VARCHAR(100)
	,@LocationCode VARCHAR(100)
	,@NameOnPANCard VARCHAR(100)
	,@PANNo VARCHAR(100)
	,@BranchCode VARCHAR(50)=NULL
	,@SalesPersonID VARCHAR(50)='0'
	,@StateID INT=NULL
	,@FKUserID VARCHAR(50) 
	
AS
BEGIN
	SET NOCOUNT ON;
	--BranchCode Not Map In With mBranch So Pass NULL
	INSERT INTO B2BRegistration
	(FKUserID,AgencyName,CustomerCOde,Icast,AddrAddressLocation,AddrEmail,AddrMobileNo,AddrCity,country,BranchCode,SalesPersonId,
	AddrZipOrPostCode,LocationCode,NameOnPANCard,PANNo,InsertedDate,Dates,StateID,FromScheduler,Status,PaymentMode)
	VALUES
	(@FKUserID,@AgencyName,@CustomerCOde,@Icast,@AddrAddressLocation,@AddrEmail,@AddrMobileNo,@AddrCity,@country,@BranchCode,@SalesPersonID,
	@AddrZipOrPostCode,@LocationCode,@NameOnPANCard,@PANNo,GETDATE(),GETDATE(),@StateID,1,1,'226')

	Update tblICust SET IsDone=1 Where ICust=@Icast
END
