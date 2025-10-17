CREATE PROCEDURE [dbo].[Sp_GetRescheduleReport]-- Sp_GetRescheduleReport '2023-07-01','2023-07-14','','','','','','',''
	@FromDate Date=null
	, @ToDate Date=null
	, @BranchCode varchar(40)=null
	, @PaymentType varchar(50)=null
	, @AgentTypeId int=null
	, @AgentId int=null
	, @Country varchar(10)=null
	, @AirlineCategory varchar(10)=null
	, @AirlineCode varchar(10)=null
AS
BEGIN
	SELECT DISTINCT
	ISNULL(R.Icast,'ICUST35086') AS 'Agent ID'
	, (CASE WHEN (B.UserID<>0) then (SELECT UserName FROM mUser WITH(NOLOCK) WHERE ID=B.UserId)
		ELSE (SELECT FirstName FROM agentLogin WITH(NOLOCK) WHERE UserID=B.AgentID) END) AS [Username]
	, B.riyaPNR AS [Riya PNR]
	, B.GDSPNR  AS [CRS PNR]
	, (select top 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS [Airline PNR]
	, B.PreviousRiyaPNR AS [Previous Riya PNR]
	, P.ticketNum AS [Ticket No]
	, B.frmSector AS [Origin]
	, B.toSector AS [Destination]
	, FORMAT(CAST(B.deptTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') AS [Departure Date]
	, FORMAT(CAST(B.arrivalTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') [Arrival Date]
	, (SELECT TOP 1 tp.totalFare FROM tblPassengerBookDetails tp WITH(NOLOCK)
			left join tblBookMaster tb WITH(NOLOCK) ON tp.fkBookMaster = tb.pkId
			WHERE tb.riyaPNR = b.PreviousRiyaPNR AND tp.paxFName = p.paxFName) AS [Total Fare]
	, P.reScheduleCharge AS [Reschedule Charge]
	, P.RescheduleMarkup AS [Markup]
	, P.SupplierPenalty AS [Reissue Penalty]
	, P.basicFare AS [Fare Difference]
	, P.YQ
	, P.JNTax AS [K3]
	, P.ExtraTax  AS [OT]
	, P.totalFare AS [Total Debit]
	, FORMAT(CAST(rd.CreatedDate AS datetime), 'dd/MM/yyyy HH:mm:ss tt') AS [Requested Date]
	, FORMAT(CAST(B.inserteddate AS datetime), 'dd/MM/yyyy HH:mm:ss tt')  AS [Rescheduled DateTime]
	--(Case when B.BookingStatus='1' then 'Confirmed' End) AS [Status] ,
	, 'Confirmed' AS [Status]
	, P.paxType AS [Passenger Type]
	, p.title+'. '+P.paxFName  + ' ' + P.paxLName AS [Passenger Name]
	, (CASE WHEN PM.payment_mode='Check' THEN 'Wallet' WHEN  PM.payment_mode='passthrough' 
			THEN 'PassThrough' ELSE 'Payment Gateway' END ) AS [Payment Mode]
	, A.type AS [Airline Category]
	, B.airName AS [Airline Name]
	, ISNULL(R.AgencyName,'B2CINDIA') AS [Agency Name]
	, ISNULL((U.UserName),(ISNULL(AL.FirstName,'') ))  [Requested By]
	, ISNULL(rd.Remarks,P.RescheduleRemarks) AS [Remarks]	
	FROM tblBookMaster B WITH(NOLOCK)
	LEFT JOIN tblPassengerBookDetails P WITH(NOLOCK) ON p.fkBookMaster=b.pkId AND p.isReturn=0	
	LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
	LEFT JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=B.airCode
	LEFT JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId	
	LEFT JOIN rescheduledata rd WITH(NOLOCK) ON B.PreviousRiyaPNR=rd.RiyaPNR   --AND p.Pid=rd.pid
	LEFT JOIN mUser U WITH(NOLOCK) ON U.ID=rd.RescheduleBackEnduser
	LEFT JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=rd.ReschedulebyAgency
	WHERE ((@FROMDate = '') OR (CONVERT(date,ISNULL(B.inserteddate,rd.CreatedDate)) >= CONVERT(date,@FROMDate)) OR (CONVERT(date,ISNULL(B.inserteddate,rd.CreatedDate)) >= CONVERT(date,@FROMDate)))
 	AND ((@ToDate = '') OR (CONVERT(date,ISNULL(B.inserteddate,rd.CreatedDate)) <= CONVERT(date, @ToDate)) OR  (CONVERT(date,ISNULL(B.inserteddate,rd.CreatedDate)) <= CONVERT(date, @ToDate)))
 	AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode) OR (@BranchCode='BOMRC' AND R.LocationCode IS NULL))
	AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId=1 AND AL.userTypeID IS NULL))
 	AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId AS varchar(50))))
	AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@Country='IN' AND AL.BookingCountry IS NULL))
	AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
	AND ((@AirlineCode = '') OR (B.airCode = @AirlineCode))
	AND ((@PaymentType ='') OR 
			(LOWER(@PaymentType)='payment gateway' AND PM.payment_modE NOT IN ('Credit','PassThrough','Hold','Check'))
			OR (PM.payment_mode=@PaymentType))
	AND (B.BookingStatus=1 AND b.AgentID!='B2C' AND B.PreviousRiyaPNR IS NOT NULL)
	AND IsBooked=1 AND  b.totalFare > 0 AND p.isReturn=0 
	ORDER BY [Rescheduled DateTime] DESC
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetRescheduleReport] TO [rt_read]
    AS [dbo];

