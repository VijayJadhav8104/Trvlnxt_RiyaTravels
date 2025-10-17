
CREATE PROCEDURE [dbo].[fetchInprocessDataB2B_Chatting]
	@Userid int
	, @opr int
AS
BEGIN
	IF(@opr=2)  -- Agent Hold Booking - hold payment
	BEGIN
		SELECT  distinct
		t.pkId as pid
		, t.riyaPNR as RiyaPNR
		, t.frmSector as frmloc
		, t.TicketIssuanceError as TicketIssuanceError
		, t.toSector as toloc
		, OrderId
		, CASE WHEN (pm.order_status is null) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus
		, status_message
		, DATEDIFF(mi,t.inserteddate,getdate()) as mints
		, timeline = 'D:'+ cONvert(varchar(5),datediff(dd,0,(GETDATE()-t.inserteddate))) +
				' H:'+ cONvert(varchar(5),datepart(hour,(GETDATE()-t.inserteddate))) +
				' M:'+  cONvert(varchar(5),datepart(minute,(GETDATE()-t.inserteddate)))
		, GDSPNR as GDSPNR
		, t.[airName] as airname
		, t.emailId as email
		, t.mobileNo as mob
		, t.depttime as deptdate
		, t.arrivaltime arrivaldate
		, CASE WHEN (pm.order_status is null) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
				WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus 
		, t.IP
		, p.ticketNum
		, p.isReturn
		, t.Country
		, t.OfficeID
		, ISNULL(B.AgencyName,B1.AgencyName) AS AgencyName
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id=t.orderId
		INNER JOIN tblPassengerBookDetails p WITH(NOLOCK) ON p.fkBookMaster=t.pkId
		LEFT JOIN B2BRegistratiON B WITH(NOLOCK) ON B.FKUserID=CAST (T.AgentID AS VARCHAR(50))
		LEFT JOIN AgentLogin AL WITH(NOLOCK) ON T.AgentID=AL.UserID
		LEFT JOIN B2BRegistratiON B1 WITH(NOLOCK) ON CAST(B1.FKUserID AS VARCHAR(50))=AL.ParentAgentID 
		WHERE t.IsBooked =0 and t.pkId in (SELECT fkBookMaster FROM tblPassengerBookDetails WITH(NOLOCK) WHERE IsRefunded =0)
			AND T.Country in (SELECT C.CountryCode  FROM mUserCountryMapping UM WITH(NOLOCK)
			INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid  AND IsActive=1)
			AND t.AgentID != 'B2C' AND (t.AgentActiON=1 AND t.TicketIssue IS NULL) and pm.order_status='Hold'
	END

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInprocessDataB2B_Chatting] TO [rt_read]
    AS [dbo];

