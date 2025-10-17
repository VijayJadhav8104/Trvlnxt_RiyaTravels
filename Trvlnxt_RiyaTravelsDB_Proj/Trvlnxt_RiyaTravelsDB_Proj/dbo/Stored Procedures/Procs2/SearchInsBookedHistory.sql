--exec [SearchInsBookedHistory] '','','','','','','-1','3'
	
CREATE PROCEDURE [dbo].[SearchInsBookedHistory] 
	@FROMDate Date= null,
	@ToDate Date= null,
	@RiyaPNR varchar(20)='',
	@orderNumber varchar(20)='',
	@EmailID varchar(30)=null,
	@MobileNo varchar(20)=null,
	@Status varchar(20)='',
	@Userid varchar(10)=''
AS
BEGIN
	SELECT b.AgencyName,
	AddrAddressLocation +','+ AddrCity +','+AddrState +'-'+ AddrZipOrPostCode as AgencyAddressNW,
	AddrAddressLocation+','+AddrCity+','+AddrZipOrPostCode as Agencyaddress,
	AddrLandlineNo +'/'+ AddrMobileNo as AgencyContact,
	AddrEmail as AgencyEmail,ag.country as Agencycountry,
	bookmaster.planName,bookmaster.planType,bookmaster.orderID,bookmaster.planid,bookmaster.RiyaPNR,bookmaster.totalfare,bookmaster.ManagementFees as TotalMarkupAmt,bookmaster.address1,bookmaster.address2,bookmaster.postalCode,
	bookmaster.cityName,bookmaster.stateName,bookmaster.stateCode,bookmaster.countryName,bookmaster.countryCode,bookmaster.phoneNumber,bookmaster.emailAddress,
	bookmaster.effectiveDate,bookmaster.expirationDate,bookmaster.depositDate,bookmaster.totalTripCost,bookmaster.insertedDate as insertdate,bookmaster.AgentROE,bookmaster.NoofDays,bookmaster.Noofpax,
	bookmaster.Remarks,bookmaster.orderNumber,bookmaster.orderUniqueid,bookmaster.orderConfirmationFulfillmentUrl,u.FullName as IssueBy, bookmaster.IssueBy AS IssueByID ,bookmaster.updatedDate as IssueDate,bookmaster.token ,
	pm.payment_mode,bookmaster.AgentID,ag.AgentBalance AS AgentBalance,Passenger.policyNumber,
	CASE
	WHEN  bookmaster.Bookingstatus =1  THEN 'LIVE'
	WHEN  bookmaster.Bookingstatus =2  THEN 'CANCELLED'
	END AS Bookingstatus
	--Passenger.pkid, Passenger.paxTitle,Passenger.paxFname,Passenger.paxMname,Passenger.paxLname,Passenger.paxDOB,Passenger.individualTripCost,Passenger.totalFare,Passenger.age,
	--Passenger.policyNumber,Passenger.individualPolicyFulfillmentUrl,
	--CASE
	--WHEN  Passenger.PaxStatus =1  THEN 'LIVE'
	--WHEN  Passenger.PaxStatus =2  THEN 'CANCELLED'
	--END AS PaxStatus
	from tblInsBookMaster as bookmaster
	left join tblInsPassengerDetails  as Passenger on bookmaster.orderNumber =Passenger.orderNumber
	left join B2BRegistration b on b.FKUserID=bookmaster.AgentID
	left join mCountryCurrency c on c.CountryCode=bookmaster.countryCode
	left join [dbo].[Paymentmaster] pm on pm.order_id=bookmaster.orderid
	left join [mUser] u on u.id=bookmaster.IssueBy
	left join AgentLogin ag on ag.UserID=bookmaster.AgentID
	where 
	 ((@Status = '-1') or (bookmaster.Bookingstatus = @Status))
	 AND (CONVERT(date,bookmaster.updatedDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)
		AND (CONVERT(date,bookmaster.updatedDate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)
	AND ((@RiyaPNR = '') or (bookmaster.RiyaPNR = @riyaPNR))
	AND ((@orderNumber = '') or (bookmaster.orderNumber = @orderNumber))
	AND ((@Userid = '') or (bookmaster.IssueBy = @Userid) or (bookmaster.IssueBy = @Userid))

	order by bookmaster.insertedDate desc
 
end

