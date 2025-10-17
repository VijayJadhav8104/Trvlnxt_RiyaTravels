


CREATE PROCEDURE [Rail].[Get_SelfBal_Rev_Rail]
	@FromDate Date=null,
	@ToDate Date=null,
	@Status Varchar(10)='',
	@UserId Varchar(500)=null,
	@OBTC Int 
AS
BEGIN

	DECLARE @UID INT
	Select @UID=UserID from agentLogin Where UserID=@UserId

	if(@Status='All')
	BEGIN
	
SELECT bk.creationDate as 'IssueDate',
		bk.BookingReference as 'BookingreferenceID',
		bk.BookingId as 'BookingID',
		bk.AmountPaidbyAgent as 'Amount',
		bk.bookingStatus as 'Status',
		--AL.BookingCountry AS 'Country',
		--CM.Value AS 'User Type',
		(CASE WHEN @UID!=NULL THEN AL.BookingCountry ELSE 
			(Select 
			STUFF((SELECT ', ' + MC.CountryCode
			FROM mUserCountryMapping MU
			INNER JOIN mCountry MC ON MU.CountryId = MC.ID 
			INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId
			FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'Country',
		(CASE WHEN @UID!=NULL THEN CM.Value ELSE 
			(Select 
			STUFF((SELECT ', ' + MC.Value
			FROM mUserTypeMapping MU
			INNER JOIN mCommon MC ON MU.UserTypeId = MC.ID AND MC.Category = 'UserType'
			INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId
			FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'User Type',
		al.firstName   as 'AgentName',
		bk.RiyaUserId as 'UserId',
		pax.firstName+' '+pax.lastName as 'passengerName',
		bk.MarkUpOnBookingFee as 'Agent Markup',
		--,CASE
		--WHEN bk.SB_bookingStatus=0 then 'Pending'
		--WHEN bk.SB_bookingStatus=1 then 'Completed'
		--END 'bookingStatus'
		bk.AgentInvoiceNumber,
		bk.InquiryNo,
		bk.FileNo,
		bk.PaymentRefNo,
		bk.OBTCNo,
		bk.RTTRefNo,
		bk.OpsRemark,
		bk.AcctsRemark
		FROM
		rail.Bookings bk		
		left join rail.BookingItems bkI on bk.Id = bki.fk_bookingId
		left join rail.PaxDetails pax on bki.Id = pax.fk_ItemId
		left join B2BRegistration BR on bk.AgentId=BR.FKUserID
		left join mUser MU on bk.RiyaUserId=Mu.ID
		left join AgentLogin al on bk.AgentId=al.UserID
		INNER JOIN mCommon CM WITH(NOLOCK) ON CM.ID = al.UserTypeID
		
		where CONVERT(date,bk.creationDate) between @FromDate and @ToDate

	end
	if(@Status='All')
	BEGIN
	
SELECT bk.creationDate as 'IssueDate',
		bk.BookingReference as 'BookingreferenceID',
		bk.BookingId as 'BookingID',
		bk.AmountPaidbyAgent as 'Amount',
		bk.bookingStatus as 'Status',
		--AL.BookingCountry AS 'Country',
		--CM.Value AS 'User Type',
		(CASE WHEN @UID!=NULL THEN AL.BookingCountry ELSE 
			(Select 
			STUFF((SELECT ', ' + MC.CountryCode
			FROM mUserCountryMapping MU
			INNER JOIN mCountry MC ON MU.CountryId = MC.ID 
			INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId
			FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'Country',
		(CASE WHEN @UID!=NULL THEN CM.Value ELSE 
			(Select 
			STUFF((SELECT ', ' + MC.Value
			FROM mUserTypeMapping MU
			INNER JOIN mCommon MC ON MU.UserTypeId = MC.ID AND MC.Category = 'UserType'
			INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId
			FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'User Type',
		al.firstName   as 'AgentName',
		bk.RiyaUserId as 'UserId',
		pax.firstName+' '+pax.lastName as 'passengerName',
		bk.MarkUpOnBookingFee as 'Agent Markup',
		--,CASE
		--WHEN bk.bookingStatus=0 then 'Pending'
		--WHEN bk.bookingStatus=1 then 'Completed'
		--END 'bookingStatus'
		bk.AgentInvoiceNumber,
		bk.InquiryNo,
		bk.FileNo,
		bk.PaymentRefNo,
		bk.OBTCNo,
		bk.RTTRefNo,
		bk.OpsRemark,
		bk.AcctsRemark
		FROM
		rail.Bookings bk		
		left join rail.BookingItems bkI on bk.Id = bki.fk_bookingId
		left join rail.PaxDetails pax on bki.Id = pax.fk_ItemId
		left join B2BRegistration BR on bk.AgentId=BR.FKUserID
		left join mUser MU on bk.RiyaUserId=Mu.ID
		left join AgentLogin al on bk.AgentId=al.UserID
		INNER JOIN mCommon CM WITH(NOLOCK) ON CM.ID = al.UserTypeID
		
		where CONVERT(date,bk.creationDate) between @FromDate and @ToDate

	end
	end
	
	

