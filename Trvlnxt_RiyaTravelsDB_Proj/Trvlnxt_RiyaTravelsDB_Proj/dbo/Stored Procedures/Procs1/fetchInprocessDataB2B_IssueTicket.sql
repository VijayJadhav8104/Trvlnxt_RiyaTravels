
CREATE PROCEDURE [dbo].[fetchInprocessDataB2B_IssueTicket]
	@Userid int
	, @opr int
AS
BEGIN
	IF(@opr=2) -- Agent Hold Booking - hold payment
	BEGIN
		SELECT distinct
		t.pkId AS pid
		, t.riyaPNR AS RiyaPNR
		, t.frmSector AS frmloc
		, t.TicketIssuanceError AS TicketIssuanceError
		, t.toSector AS toloc
		, OrderId
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (pm.order_status IS NOT NULL AND GDSPNR IS NOT NULL AND t.TicketIssue= 1 ) THEN 'Pending'
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status end AS PaymentStatus
		, status_message
		, DATEDIFF(mi,t.inserteddate,getdate()) AS mints
		, timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()-t.inserteddate))) +
			' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-t.inserteddate))) +
			' M:'+ convert(varchar(5),datepart(minute,(GETDATE()-t.inserteddate)))
		, GDSPNR AS GDSPNR
		, t.[airName] AS airname
		, t.emailId AS email
		, t.mobileNo AS mob
		, t.depttime AS deptdate
		, t.arrivaltime arrivaldate
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (pm.order_status IS NOT NULL AND GDSPNR IS NOT NULL AND t.TicketIssue= 1) THEN 'Pending'
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status
				WHEN (pm.order_status IS NOT NULL AND GDSPNR IS NOT NULL ) THEN pm.order_status END AS pnrStatus 
		, t.IP
		, p.ticketNum
		, p.isReturn
		, t.Country
		, t.OfficeID
		, ISNULL(B.AgencyName,B1.AgencyName) AS AgencyName
		FROM [dbo].[tblBookMASter] t WITH(NOLOCK)
		LEFT JOIN dbo.PaymentmASter pm WITH(NOLOCK) ON pm.order_id=t.orderId
		INNER JOIN tblPASsengerBookDetails p WITH(NOLOCK) ON p.fkBookMASter=t.pkId
		LEFT JOIN B2BRegistration B WITH(NOLOCK) ON B.FKUserID=CAST (T.AgentID AS VARCHAR(50))
		LEFT JOIN AgentLogin AL WITH(NOLOCK) ON T.AgentID=AL.UserID
		LEFT JOIN B2BRegistration B1 WITH(NOLOCK) ON CAST(B1.FKUserID AS VARCHAR(50))=AL.ParentAgentID 
		where (t.IsBooked =0) AND t.pkId IN (select fkBookMASter from tblPASsengerBookDetails WITH(NOLOCK) where IsRefunded =0)
		AND T.Country IN (select C.CountryCode from mUserCountryMapping UM WITH(NOLOCK)
		INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId where UserID=@Userid AND IsActive=1)
		AND t.AgentID != 'B2C' AND (t.TicketIssue=1) AND pm.order_status='Hold'
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInprocessDataB2B_IssueTicket] TO [rt_read]
    AS [dbo];

