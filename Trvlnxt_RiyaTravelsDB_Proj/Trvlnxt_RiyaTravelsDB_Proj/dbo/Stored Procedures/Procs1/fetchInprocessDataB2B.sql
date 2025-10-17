--exec [dbo].[fetchInprocessDataB2B] 
CREATE PROCEDURE [dbo].[fetchInprocessDataB2B] 
	@Userid int
	, @opr int
AS
BEGIN
	--deCLARE
	--@Userid int = 1,
	--@opr int = 2
	IF(@opr=1) -- B2C User Booking Process Tab
	BEGIN
		SELECT 
		(t.pkId) AS pid
		, t.riyaPNR AS RiyaPNR
		, t.frmSector AS frmloc
		, t.TicketIssuanceError AS TicketIssuanceError
		, t.inserteddate
		, t.toSector AS toloc
		, OrderId
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending'
			WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
			WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status END AS PaymentStatus,status_message
		, DATEDIFF(mi,t.inserteddate,getdate()) AS mints
		, timeline = 'D:'+ CONVERT(varchar(5),DATEDIFF(dd,0,(GETDATE()- ISNULL(t.inserteddate_old,T.inserteddate)))) +
				' H:'+ CONVERT(varchar(5),DATEPART(HOUR,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
				' M:'+ CONVERT(varchar(5),DATEPART(MINUTE,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate))))
		, GDSPNR AS GDSPNR
		, t.[airName] AS airname
		, t.emailId AS email
		, t.mobileNo AS mob
		, t.depttime AS deptdate
		, t.arrivaltime arrivaldate
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status
				WHEN (pm.order_status IS NOT NULL AND GDSPNR IS NOT NULL ) THEN pm.order_status END AS pnrStatus 
		, t.IP
		, p.ticketNum
		, p.isReturn
		, t.Country
		, t.OfficeID
		FROM [dbo].[tblBookMASter] t WITH(NOLOCK)
		LEFT JOIN dbo.PaymentmASter pm WITH(NOLOCK) ON pm.order_id=t.orderId
		INNER JOIN tblPASsengerBookDetails p WITH(NOLOCK) ON p.fkBookMASter=t.pkId
		WHERE t.IsBooked = 0
		AND t.pkId IN (select fkBookMASter FROM tblPASsengerBookDetails WITH(NOLOCK) WHERE IsRefunded =0)
		AND T.Country IN (select C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1) 
		AND t.AgentID = 'B2C' 
	END
	ELSE IF(@opr = 2) -- Agent Hold Booking - hold payment
	BEGIN
		SELECT DISTINCT
		(t.pkId) AS pid
		, t.riyaPNR AS RiyaPNR
		, t.frmSector AS frmloc
		, t.TicketIssuanceError AS TicketIssuanceError
		, t.inserteddate
		, t.toSector AS toloc
		, OrderId
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status END AS PaymentStatus,status_message
		, DATEDIFF(mi,t.inserteddate,getdate()) AS mints
		, timeline = 'D:'+ CONVERT(varchar(5),DATEDIFF(dd,0,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
			' H:'+ CONVERT(varchar(5),DATEPART(HOUR,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
			' M:'+ CONVERT(varchar(5),DATEPART(MINUTE,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate))))
		, GDSPNR AS GDSPNR
		, t.[airName] AS airname
		, t.emailId AS email
		, t.mobileNo AS mob
		, t.depttime AS deptdate
		, t.arrivaltime arrivaldate
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
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
		LEFT JOIN B2BRegistration B WITH(NOLOCK) ON CAST(B.FKUserID AS VARCHAR(50))=T.AgentID
		LEFT JOIN AgentLogin AL WITH(NOLOCK) ON T.AgentID=AL.UserID
		LEFT JOIN B2BRegistration B1 WITH(NOLOCK) ON CAST(B1.FKUserID AS VARCHAR(50))=AL.ParentAgentID 
		WHERE t.IsBooked =0 
		AND t.pkId IN (select fkBookMASter FROM tblPASsengerBookDetails WITH(NOLOCK) WHERE IsRefunded =0)
		AND T.Country IN (select C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
		INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
		AND t.AgentID != 'B2C' 
		AND (t.AgentAction IS NULL AND t.TicketIssue IS NULL) 
		AND pm.order_status='Hold'
	END
	ELSE IF(@opr = 3) -- Agent Issue Ticket Tab - credit, check payment
	BEGIN
		SELECT DISTINCT
		(t.pkId) AS pid
		, t.riyaPNR AS RiyaPNR
		, t.frmSector AS frmloc
		, t.TicketIssuanceError AS TicketIssuanceError
		, t.toSector AS toloc
		, OrderId
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status END AS PaymentStatus
		, status_message
		, DATEDIFF(mi,t.inserteddate,getdate()) AS mints
		, timeline = 'D:'+ CONVERT(varchar(5),DATEDIFF(dd,0,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
				' H:'+ CONVERT(varchar(5),DATEPART(HOUR,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
				' M:'+ CONVERT(varchar(5),DATEPART(MINUTE,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate))))
		, GDSPNR AS GDSPNR
		, t.[airName] AS airname
		, t.emailId AS email
		, t.mobileNo AS mob
		, t.depttime AS deptdate
		, t.arrivaltime arrivaldate
		, CASE WHEN (pm.order_status IS NULL) THEN 'Pending' WHEN (GDSPNR IS NULL AND pm.order_status IS NULL) THEN 'Pending' 
				WHEN (GDSPNR IS NULL AND pm.order_status IS NOT NULL) THEN pm.order_status
				WHEN (pm.order_status IS NOT NULL AND GDSPNR IS NOT NULL ) THEN pm.order_status END AS pnrStatus
		, t.IP
		, p.ticketNum
		, p.isReturn
		, t.Country
		, t.OfficeID
		, B.AgencyName
		, pm.payment_mode
		FROM [dbo].[tblBookMASter] t WITH(NOLOCK)
		LEFT JOIN dbo.PaymentmASter pm WITH(NOLOCK) ON pm.order_id=t.orderId
		INNER JOIN tblPASsengerBookDetails p WITH(NOLOCK) ON p.fkBookMASter=t.pkId
		INNER JOIN B2BRegistration B WITH(NOLOCK) ON CAST(B.FKUserID AS VARCHAR(50))=T.AgentID 
		WHERE t.IsBooked =0 AND t.pkId IN (select fkBookMASter FROM tblPASsengerBookDetails WITH(NOLOCK) WHERE IsRefunded =0)
		AND T.Country IN (select C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
		INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
		AND pm.payment_mode IS NULL or pm.payment_mode != 'Hold' AND t.IsBooked IS NOT NULL
		AND t.AgentID != 'B2C' AND (t.AgentAction= 0 or t.AgentAction IS NULL AND t.TicketIssue IS NULL)
		AND pm.order_status!='Hold' AND pm.order_status!='Success'
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInprocessDataB2B] TO [rt_read]
    AS [dbo];

