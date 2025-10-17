--exec Sp_GetInsViewPNRDetails 'null','ZYB137','','',''
CREATE Procedure [dbo].[Sp_GetInsViewPNRDetails]
	@orderNumber nvarchar(50) =null,
	@RiyaPNR varchar(8)=null,
	@PolicyNo varchar(50)=null,
	@Currency varchar(10)=null,
	@MainAgentId int=null
AS
BEGIN
	declare @BookorderNumber varchar(50)=null

	if(@orderNumber is null OR @orderNumber='null')
	begin
	set @orderNumber =''
	end

	if(@RiyaPNR is null OR @RiyaPNR='null')
	begin
	set @RiyaPNR =''
	end

	select top 1 @BookorderNumber=orderID from tblInsBookMaster where orderNumber=@orderNumber

	if(@BookorderNumber is null)
	begin
	select top 1 @BookorderNumber=orderID from tblInsBookMaster where RiyaPNR=@RiyaPNR 
	end
	--if(@orderNumber !=null)
	--begin
	--select top 1 @BookorderNumber=orderID from tblInsBookMaster where orderNumber=@orderNumber 
	--end
	--else if (@RiyaPNR !=null)
	--begin
	--select top 1 @BookorderNumber=orderID from tblInsBookMaster where RiyaPNR ='XN1Q70'
	--end

	select b.AgencyName,
	AddrAddressLocation +','+ AddrCity +','+AddrState +'-'+ AddrZipOrPostCode as AgencyAddressNW,
	AddrAddressLocation+','+AddrCity+','+AddrZipOrPostCode as Agencyaddress,
	AddrLandlineNo +'/'+ AddrMobileNo as AgencyContact,
	AddrEmail as AgencyEmail,ag.country as Agencycountry,
	bookmaster.planName,bookmaster.orderID,bookmaster.planid,bookmaster.RiyaPNR,bookmaster.totalfare,bookmaster.ManagementFees as TotalMarkupAmt,bookmaster.address1,bookmaster.address2,bookmaster.postalCode,
	bookmaster.cityName,bookmaster.stateName,bookmaster.stateCode,bookmaster.countryName,bookmaster.countryCode,bookmaster.phoneNumber,bookmaster.emailAddress,
	bookmaster.effectiveDate,bookmaster.expirationDate,bookmaster.depositDate,bookmaster.totalTripCost,bookmaster.insertedDate AS insertdate,bookmaster.AgentROE,bookmaster.NoofDays,bookmaster.Noofpax,
	bookmaster.Remarks,bookmaster.orderNumber,bookmaster.orderUniqueid,bookmaster.orderConfirmationFulfillmentUrl,u.FullName as IssueBy, bookmaster.IssueBy AS IssueByID ,bookmaster.updatedDate as IssueDate,bookmaster.token ,
	pm.payment_mode,bookmaster.AgentID,ag.AgentBalance AS AgentBalance,VendorName AS VendorName,bookmaster.Bookingstatus AS BookingStatus
	from tblInsBookMaster as bookmaster
	left join B2BRegistration b on b.FKUserID=bookmaster.AgentID
	left join mCountryCurrency c on c.CountryCode=bookmaster.countryCode
	left join [dbo].[Paymentmaster] pm on pm.order_id=bookmaster.orderid
	left join [mUser] u on u.id=bookmaster.IssueBy
	left join AgentLogin ag on ag.UserID=bookmaster.AgentID
	where
	--bookmaster.orderNumber = @orderNumber and bookmaster.RiyaPNR =@RiyaPNR 
	 ((@RiyaPNR = '') or (bookmaster.RiyaPNR = @RiyaPNR))
	AND ((@orderNumber = '') or (bookmaster.orderNumber = @orderNumber))
	--and bookmaster.Bookingstatus ='1'


	select Passenger.pkid, Passenger.paxTitle,Passenger.paxFname,Passenger.paxMname,Passenger.paxLname,Passenger.paxDOB,Passenger.individualTripCost,Passenger.totalFare,Passenger.ManagementMarkupAmt as MarkupAmt,Passenger.age,
	Passenger.policyNumber,Passenger.individualPolicyFulfillmentUrl,
	CASE
	WHEN  Passenger.PaxStatus =0  THEN 'PENDING'
	WHEN  Passenger.PaxStatus =1  THEN 'LIVE'
	WHEN  Passenger.PaxStatus =2  THEN 'CANCELLED'
	WHEN  Passenger.PaxStatus =3  THEN 'FAILED'
	END AS PaxStatus
	from tblInsPassengerDetails as Passenger
	where Passenger.orderID = @BookorderNumber  
 

end

