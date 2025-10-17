-- =============================================
-- Author: Hardik Deshani
-- Create date: 10.02.2025
-- Description: Search Booking History
-- =============================================
CREATE PROCEDURE [dbo].[B2B_SearchBookingHistory]
	@FromDate Date = NULL
	, @ToDate Date = NULL
	, @TravelDate Date = NULL
	, @PaxName varchar(100)= NULL
	, @PNR varchar(20) = NULL
	, @AirlinePNR varchar(20)= NULL
	, @EmailID varchar(30)= NULL
	, @MobileNo varchar(20)= NULL
	, @Status varchar(20)= NULL
	, @OrderID varchar(30)= NULL 
	, @Userid varchar(10)= NULL 
	, @SubUserID int = NULL
	, @ParentID int = NULL 
	, @Currency varchar(20) = NULL
	, @MainAgentId Int = NULL
	, @AgentID Int = NULL
	, @Airline varchar(max)= NULL
	, @Start int = NULL
	, @Pagesize int = NULL 
	, @RecordCount INT OUTPUT
AS
BEGIN
	
	DECLARE @NewsUserID AS VARCHAR(10), @TillDate DATETIME  
 
	SET @NewsUserID = (CASE WHEN @Userid = 0 THEN '' ELSE CAST(@Userid AS VARCHAR(10)) END)  
	
	IF(@MainAgentId = 0 AND @AgentID <= 0)  
	BEGIN
		SELECT @RecordCount = 0  
		RETURN;  
	END 
  
	SELECT @TillDate = TillDate FROM tblBlockTransaction WITH(NOLOCK) WHERE AgentId = @AgentID  
  
	IF(@TillDate IS NOT NULL AND (@TillDate >= @FROMDate AND @TillDate >= @ToDate))  
	BEGIN  
		SET @RecordCount = 0  
		RETURN;  
	END

	IF(@TillDate IS NOT NULL AND @TillDate >= @FROMDate)  
	BEGIN  
		SET @FROMDate = DATEADD(DAY, 1, @TillDate)  
	END

	-- Common Data Temp Table
	DECLARE @CommonData TABLE (
		riyaPNR VARCHAR(50)
		,AirlineName VARCHAR(50)
		,DepDate VARCHAR(50)
		,ArrDate VARCHAR(50)
		,SectorName VARCHAR(50)
		,TotalFare Numeric(18,2)
		,BookingDates VARCHAR(50)
		,ID BigInt
		,AirlinePNR VARCHAR(50)
		,returnFlag Bit
		,orderId VARCHAR(50)
	);

	;WITH CommonData AS
	(
		SELECT tblBookMaster.riyaPNR
		, tblBookMaster.airName AS AirlineName
		, FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') AS DepDate
		, FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') AS ArrDate
		, (tblBookMaster.frmSector + '-' + tblBookMaster.toSector) AS SectorName
		, tblBookMaster.totalfare AS TotalFare
		, FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt') AS BookingDates
		, tblBookMaster.pkId AS ID
		, tblBookItenary.airlinePNR AS AirlinePNR
		, tblBookMaster.returnFlag
		, tblBookMaster.orderId
		FROM tblBookMaster WITH(NOLOCK) 
		LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = fkBookMaster AND tblBookMaster.frmSector = tblBookItenary.frmSector   
		LEFT JOIN Paymentmaster WITH(NOLOCK) ON tblBookMaster.OrderId = Paymentmaster.order_id
		INNER JOIN AgentLogin WITH(NOLOCK) on AgentLogin.UserID = tblBookMaster.AgentID 
		LEFT JOIN B2BRegistration B2BRegistrationUser WITH(NOLOCK) ON AgentLogin.UserID = B2BRegistrationUser.FKUserID
		LEFT JOIN B2BRegistration B2BRegistrationParent WITH(NOLOCK) ON AgentLogin.ParentAgentID = B2BRegistrationParent.FKUserID
		LEFT JOIN mUser WITH(NOLOCK) ON mUser.ID = tblBookMaster.BookedBy 
		LEFT JOIN B2BRegistration B2BRegistrationAgent WITH(NOLOCK) ON tblBookMaster.AgentID = B2BRegistrationAgent.FKUserID
		WHERE returnFlag = 0
		AND AgentID != 'B2C'
		AND 1 = (CASE 
				WHEN (@FromDate IS NULL OR @FromDate = '') THEN 1 
				WHEN (@ToDate IS NULL OR @ToDate = '') THEN 1 
				WHEN (CAST(tblBookMaster.inserteddate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)) THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@TravelDate IS NULL OR @TravelDate = '') THEN 1 
				WHEN (CAST(tblBookMaster.inserteddate AS DATE) = CAST(@TravelDate AS DATE)) THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@PNR IS NULL OR @PNR = '') THEN 1 
				WHEN (tblBookItenary.airlinePNR = @PNR OR tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR) THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@EmailID IS NULL OR @EmailID = '') THEN 1 
				WHEN (tblBookMaster.emailId LIKE '%' + @EmailID + '%') THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@MobileNo IS NULL OR @MobileNo = '') THEN 1 
				WHEN (tblBookMaster.mobileNo LIKE '%' + @MobileNo + '%') THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@OrderID IS NULL OR @OrderID = '') THEN 1 
				WHEN (Paymentmaster.order_id = @OrderID) THEN 1 ELSE 0 END)
		AND 1 = (CASE 
				WHEN (@NewsUserID IS NULL OR @NewsUserID = '') THEN 1 
				WHEN (tblBookMaster.AgentID = CAST(@NewsUserID AS VARCHAR(10))) THEN 1 ELSE 0 END)
		AND tblBookMaster.Country IN (SELECT CountryCode 
				FROM mUserCountryMapping WITH(NOLOCK) 
				INNER JOIN mCountry ON mUserCountryMapping.CountryId = mCountry.ID 
				WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1) 
		AND AgentLogin.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
	)
	INSERT INTO @CommonData
	SELECT * FROM CommonData

	SELECT riyaPNR
	, STUFF((SELECT '/' + AirlineName FROM @CommonData b2 WHERE b2.riyaPNR = CD.riyaPNR  
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AirlineName
	
	, STUFF((SELECT '/' + b2.DepDate FROM @CommonData b2 WHERE b2.riyaPNR = CD.riyaPNR  
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS DepDate

	, STUFF((SELECT '/' + b2.ArrDate FROM @CommonData b2 WHERE b2.riyaPNR = CD.riyaPNR  
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS ArrDate

	, STUFF((SELECT '/' + AirlinePNR FROM @CommonData b2 WHERE b2.riyaPNR = CD.riyaPNR
			 AND airlinePNR IS NOT NULL
			 GROUP BY AirlinePNR
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS AirlinePNR

	, STUFF((SELECT '/' + SectorName FROM @CommonData b2 WHERE b2.orderId = CD.orderId
			 ORDER BY b2.ID
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS Sector

	, STUFF((SELECT '/' + BookingDates FROM @CommonData b2 WHERE b2.riyaPNR = CD.riyaPNR
			 GROUP BY BookingDates
             FOR XML PATH (''), TYPE).value('.', 'NVARCHAR(MAX)'),1, 1, '') AS BookingDates

	INTO #mTFilterData FROM @CommonData AS CD
	GROUP BY riyaPNR, orderId

	-- Booking ID
	SELECT orderId
		, STUFF((SELECT '/' + CAST(ID AS VARCHAR) FROM @CommonData AS sub WHERE sub.OrderID = main.OrderID
		ORDER BY ID ASC FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS pkId
	INTO #mTFilterPKID FROM @CommonData AS main
	GROUP BY orderId 
	ORDER BY orderId

	IF(@ParentID IS NOT NULL)
	BEGIN  
		IF (@Status = 99)
		BEGIN
			;WITH PaginatedData AS
			(
				SELECT tblBookMaster.Country 
				, BookingSource
				, tblBookMaster.emailId AS email
				, tblBookMaster.mobileNo AS mob
				, OfficeID
				, tblBookMaster.RiyaPNR
				, VendorName
				, ISNULL(tblBookMaster.ROE, 1) ROE
				, ISNULL(AgentROE, 1) AS AgentROE
				, ISNULL(B2BMarkup, 0) AS B2BMarkup
				, ISNULL(AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, GDSPNR
				, tbi.orderId
				, (CASE tblBookMaster.BookingStatus  
					WHEN 1 THEN 'Confirmed'
					WHEN 2 THEN 'Hold'
					WHEN 3 THEN 'Pending Ticket'
					WHEN 4 THEN 'Cancelled'
					WHEN 5 THEN 'Close'
					WHEN 6 THEN 'To Be Cancelled'  
					WHEN 7 THEN 'To Be Rescheduled'
					WHEN 8 THEN 'Rescheduled'
					WHEN 9 THEN 'HoldCancel'
					WHEN 0 THEN 'Failed'
					WHEN 11 THEN 'Cancelled'  
					WHEN 13 THEN 'TJQ Pending' 
					WHEN 14 THEN 'Open Ticket'  
					WHEN 15 THEN 'On Hold canceled'  
					ELSE 'Failed' END) AS Ticketstatus
				, ISNULL(tblBookMaster.IsMultiTST, 0) AS IsMultiTST
				, order_status
				, c.tracking_id
				, ISNULL(c.currency, tblBookMaster.AgentCurrency) AS currency
				, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast,BRP.Icast) AS Icast
				, CASE WHEN tblBookMaster.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
				, (SELECT ISNULL(SUM(totalfare ), 0) FROM tblBookMaster WITH(NOLOCK) WHERE riyaPNR = tblBookMaster.RiyaPNR) AS totalfare
				, #mTFilterData.AirlineName AS airName
				, #mTFilterData.DepDate AS deptdate
				, #mTFilterData.ArrDate AS arrivaldate
				, #mTFilterData.AirlinePNR AS airlinePNR
				, #mTFilterData.Sector
				, #mTFilterData.BookingDates AS booking_date
				, #mTFilterPKID.pkId
				FROM tblBookMaster
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON tblBookMaster.pkId = tbi.fkBookMaster AND tblBookMaster.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON tblBookMaster.OrderId = c.order_id
				INNER JOIN AgentLogin AL WITH(NOLOCK) ON AL.UserID = tblBookMaster.AgentID
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
				LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
				LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = tblBookMaster.BookedBy
				LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON tblBookMaster.AgentID = BR1.FKUserID  
				LEFT JOIN #mTFilterData WITH(NOLOCK) ON #mTFilterData.riyaPNR = tblBookMaster.riyaPNR
				LEFT JOIN #mTFilterPKID WITH(NOLOCK) ON #mTFilterPKID.orderId = tblBookMaster.orderId
				WHERE returnFlag = 0
				AND AgentID != 'B2C'
				AND 1 = (CASE 
						WHEN (@FromDate IS NULL OR @FromDate = '') THEN 1 
						WHEN (@ToDate IS NULL OR @ToDate = '') THEN 1 
						WHEN (CAST(tblBookMaster.inserteddate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)) THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@TravelDate IS NULL OR @TravelDate = '') THEN 1 
						WHEN (CAST(tblBookMaster.inserteddate AS DATE) = CAST(@TravelDate AS DATE)) THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@PNR IS NULL OR @PNR = '') THEN 1 
						WHEN (tbi.airlinePNR = @PNR OR tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR) THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@EmailID IS NULL OR @EmailID = '') THEN 1 
						WHEN (tblBookMaster.emailId LIKE '%' + @EmailID + '%') THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@MobileNo IS NULL OR @MobileNo = '') THEN 1 
						WHEN (tblBookMaster.mobileNo LIKE '%' + @MobileNo + '%') THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@OrderID IS NULL OR @OrderID = '') THEN 1 
						WHEN (c.order_id = @OrderID) THEN 1 ELSE 0 END)
				AND 1 = (CASE 
						WHEN (@NewsUserID IS NULL OR @NewsUserID = '') THEN 1 
						WHEN (tblBookMaster.AgentID = CAST(@NewsUserID AS VARCHAR(10))) THEN 1 ELSE 0 END)
				AND tblBookMaster.Country IN (SELECT CountryCode 
						FROM mUserCountryMapping WITH(NOLOCK) 
						INNER JOIN mCountry ON mUserCountryMapping.CountryId = mCountry.ID 
						WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1) 
				AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
			)
			SELECT * FROM PaginatedData
			ORDER BY PaginatedData.Country
			OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END  
		ELSE IF(@Status = 55)
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableA55') IS NOT NULL  
				DROP table  #tempTableA55  

			SELECT * INTO #tempTableA55 FROM  
			(
				SELECT A.Country
				, a.BookingSource 
				, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.OfficeID
				, a.RiyaPNR
				, a.VendorName
				, STUFF((SELECT '/' + airName
								FROM tblBookMaster WITH(NOLOCK)
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								FOR XML PATH ('')) , 1, 1, '') AS airName
				, (SELECT STUFF((SELECT '/' + airlinePNR
								FROM tblBookItenary WITH(NOLOCK)
								LEFT OUTER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								GROUP BY airlinePNR 
								FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
				, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast,BRP.Icast) AS Icast
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS deptdate
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
				, tbi.orderId
				, (SELECT ISNULL(SUM(totalfare ), 0) 
					FROM tblBookMaster WITH(NOLOCK)
					WHERE riyaPNR = a.RiyaPNR) AS totalfare
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AS AgentROE
				, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
				, ISNULL(a.AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, a.GDSPNR  
				, order_status  
				, c.tracking_id
				, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId 
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS Sector
				, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt') FROM tblBookMaster WITH(NOLOCK)
									WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) 
									GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt')
									FOR XML PATH ('')) , 1, 1, '')) AS booking_date 
				, ISNULL(c.currency, a.AgentCurrency) AS currency
				, 'Void' AS [Ticketstatus]
				, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else ISNULL(BR.Icast,BRP.Icast) end BookedBy
				, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS pkId
				, ISNULL(a.IsMultiTST, 0) AS IsMultiTST						  
				FROM (SELECT * FROM (SELECT pid 
								, paxFName  
								, paxLName  
								, tblPassengerBookDetails.fkBookMaster  
								, ROW_NUMBER() OVER(Partition BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN   
							FROM tblPassengerBookDetails WITH(NOLOCK)
							LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
							LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
							WHERE CheckboxVoid = 1 AND (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD  
							WHERE rn = 1) AS T1
				JOIN tblBookMaster  a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster  
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id
				INNER JOIN AgentLogin AL WITH(NOLOCK) ON AL.UserID = a.AgentID
				left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
				left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
				WHERE (a.returnFlag = 0
				AND  a.AgentID !='B2C'         
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
														AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(date, @ToDate))))  
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
				AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')
				AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
				AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId LIKE '%' + @EmailID + '%'))   
				AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
				AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
				AND (@NewsUserID IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@NewsUserID AS VARCHAR(10)) OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10))))
				AND a.Country IN (SELECT CountryCode 
									FROM mUserCountryMapping CM WITH(NOLOCK)
									INNER JOIN mCountry C ON CM.CountryId = C.ID
									WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)
									AND IsActive = 1)
				AND AL.UserTypeID IN (SELECT UserTypeID
										FROM mUserTypeMapping WITH(NOLOCK)  
										WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
				AND a.BookingStatus NOT IN (0, 3, 9, 10))	
			) p ORDER BY P.booking_date DESC  
		
			SELECT @RecordCount = @@ROWCOUNT

			SELECT * FROM #tempTableA55 
			GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
			, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
			, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
			, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
			ORDER BY booking_date 
			OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END
		ELSE
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableA1') IS NOT NULL
				DROP table #tempTableA1  

			SELECT * INTO #tempTableA1 FROM 
			(
				SELECT A.Country
				, a.BookingSource 
				, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.OfficeID
				, a.RiyaPNR
				, a.VendorName
				, STUFF((SELECT '/' + airName
								FROM tblBookMaster WITH(NOLOCK)
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								FOR XML PATH ('')) , 1, 1, '') AS airName
				, (SELECT STUFF((SELECT '/' + airlinePNR
								FROM tblBookItenary WITH(NOLOCK)
								LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								GROUP BY airlinePNR 
								FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
				, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast,BRP.Icast) AS Icast
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS deptdate
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
				, tbi.orderId
				, (SELECT ISNULL(SUM(totalfare ), 0) 
					FROM tblBookMaster WITH(NOLOCK)
					WHERE riyaPNR = a.RiyaPNR) AS totalfare
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AS AgentROE
				, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
				, ISNULL(a.AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, a.GDSPNR
				, order_status
				, c.tracking_id
				, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId 
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS Sector					
				, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt') FROM tblBookMaster WITH(NOLOCK)
									WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) 
									GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt')
									FOR XML PATH ('')) , 1, 1, '')) AS booking_date
				, ISNULL(c.currency, a.AgentCurrency) AS currency
				, (CASE a.BookingStatus  
								WHEN 1 THEN 'Confirmed'
								WHEN 2 THEN 'Hold'
								WHEN 3 THEN 'Pending Ticket'
								WHEN 4 THEN 'Cancelled'
								WHEN 5 THEN 'Close'
								WHEN 6 THEN 'To Be Cancelled'  
								WHEN 7 THEN 'To Be Rescheduled'
								WHEN 8 THEN 'Rescheduled'
								WHEN 9 THEN 'HoldCancel'
								WHEN 0 THEN 'Failed'
								WHEN 11 THEN 'Cancelled'  
								WHEN 13 THEN 'TJQ Pending' 
								WHEN 14 THEN 'Open Ticket'  
								WHEN 15 THEN 'On Hold canceled'  
							ELSE 'Failed' END) AS Ticketstatus
				, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
				, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS pkId
				, ISNULL(a.IsMultiTST, 0) AS IsMultiTST					
				FROM (SELECT * FROM (SELECT pid
						, paxFName
						, paxLName
						, tblPassengerBookDetails.fkBookMaster
						, ROW_NUMBER() OVER(PARTITION BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN  
					FROM tblPassengerBookDetails WITH(NOLOCK)
					LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
					LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
					WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD 
				WHERE rn = 1) AS T1
				JOIN tblBookMaster a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster  
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id
				INNER JOIN AgentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS varchar(10)) = a.AgentID
				left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
				left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
				LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy
				LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = CAST(BR1.FKUserID AS varchar(10))
				WHERE (a.returnFlag = 0
				AND a.AgentID !='B2C'   
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate, 126)))
				AND (CONVERT(char(10), a.inserteddate, 126) <= (CONVERT(char(10), @ToDate, 126))))
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
				AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))
				AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
				AND (@AirlinePNR IS NULL OR @AirlinePNR = '' OR @AirlinePNR = '' OR airlinePNR = @AirlinePNR )  
				AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))
				AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))
				AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID) 
				AND a.BookingStatus = @Status
				AND (@NewsUserID IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@NewsUserID AS VARCHAR(10)) OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10))))
				AND a.Country IN (SELECT CountryCode
									FROM mUserCountryMapping CM WITH(NOLOCK)   
									INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
									WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
				AND AL.UserTypeID IN (SELECT UserTypeID
										FROM mUserTypeMapping WITH(NOLOCK)  
										WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
			) P ORDER BY P.booking_date DESC  
			
			SELECT @RecordCount = @@ROWCOUNT

			SELECT * FROM #tempTableA1 
			GROUP BY Country, BookingSource, paxname, email, mob,OfficeID,RiyaPNR,VendorName, airName
			, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
			, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
			, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
			ORDER BY booking_date 
			OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END
	END
	ELSE IF(@ParentID IS NULL)
	BEGIN  
		IF (@Status = 99)
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableB') IS NOT NULL  
				DROP TABLE #tempTableB  

			SELECT * INTO #tempTableB FROM
			(
				SELECT A.Country
				, a.BookingSource 
				, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.OfficeID
				, a.RiyaPNR
				, a.VendorName
				, STUFF((SELECT '/' + airName
								FROM tblBookMaster WITH(NOLOCK)
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								FOR XML PATH ('')) , 1, 1, '') AS airName
				, (SELECT STUFF((SELECT '/' + airlinePNR
								FROM tblBookItenary WITH(NOLOCK)
								LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								GROUP BY airlinePNR 
								FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
				, ISNULL(BR.AgencyName, BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast, BRP.Icast) AS Icast
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)								
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS deptdate
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)								
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
				, tbi.orderId
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AS AgentROE
				, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
				, ISNULL(a.AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, a.GDSPNR
				, order_status
				, c.tracking_id
				, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId 
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS Sector					
				, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt') FROM tblBookMaster	WITH(NOLOCK)
									WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) 
									GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt')
									FOR XML PATH ('')) , 1, 1, '')) AS booking_date
				, ISNULL(c.currency, a.AgentCurrency) AS currency
				, (CASE a.BookingStatus  
								WHEN 1 THEN 'Confirmed'
								WHEN 2 THEN 'Hold'
								WHEN 3 THEN 'Pending Ticket'
								WHEN 4 THEN 'Cancelled'
								WHEN 5 THEN 'Close'
								WHEN 6 THEN 'To Be Cancelled'  
								WHEN 7 THEN 'To Be Rescheduled'
								WHEN 8 THEN 'Rescheduled'
								WHEN 9 THEN 'HoldCancel'
								WHEN 0 THEN 'Failed'
								WHEN 11 THEN 'Cancelled'  
								WHEN 13 THEN 'TJQ Pending' 
								WHEN 14 THEN 'Open Ticket'  
								WHEN 15 THEN 'On Hold canceled'  
							ELSE 'Failed' END) AS Ticketstatus
				, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
				, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS pkId
				, (SELECT ISNULL(SUM(totalfare ), 0) FROM tblBookMaster WITH(NOLOCK) WHERE riyaPNR = a.RiyaPNR) AS totalfare
				, ISNULL(a.IsMultiTST, 0) AS IsMultiTST
				FROM (SELECT * from
				(SELECT pid  
				, paxFName  
				, paxLName  
				, tblPassengerBookDetails.fkBookMaster  
				, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN   
				FROM tblPassengerBookDetails WITH(NOLOCK)
				LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
				LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
				WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD   
				WHERE rn = 1) AS T1  
				JOIN tblBookMaster a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster  
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster
				AND a.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id
				INNER JOIN AgentLogin AL WITH(NOLOCK) ON  a.AgentID = AL.UserID
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID
				LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID
				LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy
				LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = BR1.FKUserID  
				WHERE (a.returnFlag = 0  
				AND  a.AgentID !='B2C'      
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
				AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
				AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
				AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
				AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')
				AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
				AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
				AND (@Userid IS NULL OR @Userid = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))
				AND a.Country IN (SELECT CountryCode
									FROM mUserCountryMapping CM WITH(NOLOCK)
									INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
									WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
				AND AL.UserTypeID IN (SELECT UserTypeID
										FROM mUserTypeMapping WITH(NOLOCK)
										WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
				AND @Status = '99' OR a.BookingStatus = @Status)
						
			) p ORDER BY P.booking_date DESC
	
			SELECT @RecordCount = @@ROWCOUNT

			SELECT * FROM #tempTableB
			GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
			, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
			, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
			, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
			ORDER BY booking_date
			OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END  
		ELSE IF(@Status = 55)
		BEGIN
			IF OBJECT_ID ('tempdb..##tempTableB55') IS NOT NULL  
				DROP TABLE #tempTableB55  

			SELECT * INTO #tempTableB55 FROM  
			(
				SELECT A.Country
				, a.BookingSource 
				, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.OfficeID
				, a.RiyaPNR
				, a.VendorName
				, STUFF((SELECT '/' + airName
								FROM tblBookMaster WITH(NOLOCK)
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								FOR XML PATH ('')) , 1, 1, '') AS airName
				, (SELECT STUFF((SELECT '/' + airlinePNR
								FROM tblBookItenary WITH(NOLOCK)
								LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								GROUP BY airlinePNR 
								FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
				, ISNULL(BR.AgencyName, BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast, BRP.Icast) AS Icast
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS deptdate
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
				, tbi.orderId
				, (SELECT ISNULL(SUM(totalfare ), 0) 
					FROM tblBookMaster WITH(NOLOCK)
					WHERE riyaPNR = a.RiyaPNR) AS totalfare
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AS AgentROE
				, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
				, ISNULL(a.AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, a.GDSPNR
				, order_status
				, c.tracking_id
				, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector
											FROM tblBookMaster WITH(NOLOCK) 
											WHERE tblBookMaster.orderId = tbi.orderId 
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS Sector					
				, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt') FROM tblBookMaster WITH(NOLOCK)								
									WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR)
									GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt')
									FOR XML PATH ('')) , 1, 1, '')) AS booking_date
				, ISNULL(c.currency, a.AgentCurrency) AS currency
				, (CASE a.BookingStatus  
								WHEN 1 THEN 'Confirmed'
								WHEN 2 THEN 'Hold'
								WHEN 3 THEN 'Pending Ticket'
								WHEN 4 THEN 'Cancelled'
								WHEN 5 THEN 'Close'
								WHEN 6 THEN 'To Be Cancelled'  
								WHEN 7 THEN 'To Be Rescheduled'
								WHEN 8 THEN 'Rescheduled'
								WHEN 9 THEN 'HoldCancel'
								WHEN 0 THEN 'Failed'
								WHEN 11 THEN 'Cancelled'  
								WHEN 13 THEN 'TJQ Pending' 
								WHEN 14 THEN 'Open Ticket'  
								WHEN 15 THEN 'On Hold canceled'  
							ELSE 'Failed' END) AS Ticketstatus
				, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
				, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS pkId
				, ISNULL(a.IsMultiTST, 0) AS IsMultiTST
					FROM (SELECT * FROM (SELECT pid
											, paxFName
											, paxLName
											, tblPassengerBookDetails.fkBookMaster
											, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN 
										FROM tblPassengerBookDetails WITH(NOLOCK)
										LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
										LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
										WHERE CheckboxVoid = 1 and (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD
												WHERE rn = 1 ) AS T1
				JOIN tblBookMaster  a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster  
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster
				AND a.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id
				INNER JOIN AgentLogin AL  WITH(NOLOCK) ON AL.UserID = a.AgentID
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID
				LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
				WHERE (a.returnFlag = 0
				AND  a.AgentID !='B2C'         
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
				AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
				AND (@paxname IS NULL OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))
				AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
				AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))
				AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
				AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
				AND (@NewsUserID IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))
				AND a.BookingStatus NOT IN (0, 3, 9, 10))
			) p  ORDER BY P.booking_date DESC

			SELECT @RecordCount = @@ROWCOUNT

			SELECT * FROM #tempTableB55
			GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
			, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
			, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
			, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
			ORDER BY booking_date
			OFFSET @Start ROWS
			FETCH NEXT @Pagesize ROWS ONLY END
		ELSE
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableB1') IS NOT NULL
				DROP table #tempTableB1

			SELECT * INTO #tempTableB1 FROM 
			(
				SELECT A.Country
				, a.BookingSource 
				, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.OfficeID
				, a.RiyaPNR
				, a.VendorName
				, STUFF((SELECT '/' + airName
								FROM tblBookMaster WITH(NOLOCK)
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								FOR XML PATH ('')) , 1, 1, '') AS airName
				, (SELECT STUFF((SELECT '/' + airlinePNR
								FROM tblBookItenary WITH(NOLOCK)
								LEFT OUTER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
								WHERE tblBookMaster.riyaPNR = a.riyaPNR
								GROUP BY airlinePNR 
								FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
				, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
				, ISNULL(BR.Icast,BRP.Icast) AS Icast
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS deptdate
				, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.arrivalTime, 'dd-MM-yyyy hh:mm:ss tt') 
									FROM tblBookMaster WITH(NOLOCK)
									WHERE tblBookMaster.riyaPNR = a.riyaPNR
									FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
				, tbi.orderId
				, (SELECT ISNULL(SUM(totalfare ), 0) 
					FROM tblBookMaster WITH(NOLOCK)
					WHERE riyaPNR = a.RiyaPNR) AS totalfare
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AS AgentROE
				, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
				, ISNULL(a.AgentMarkup, 0) AS Markup
				, ISNULL(MCOAmount, 0) AS MCOAmount
				, ISNULL(ServiceFee, 0) AS ServiceFee
				, ISNULL(GST, 0) AS GST
				, ISNULL(BFC, 0) AS BFC
				, ISNULL(TotalHupAmount, 0) AS TotalHupAmount
				, ISNULL(TotalEarning, 0) AS TotalEarning
				, a.GDSPNR
						
				, order_status
				, c.tracking_id
				, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId 
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS Sector					
				, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt') FROM tblBookMaster WITH(NOLOCK)
									WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR)
									GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm tt')
									FOR XML PATH ('')) , 1, 1, '')) AS booking_date
				, ISNULL(c.currency, a.AgentCurrency) AS currency
				, (CASE a.BookingStatus  
								WHEN 1 THEN 'Confirmed'
								WHEN 2 THEN 'Hold'
								WHEN 3 THEN 'Pending Ticket'
								WHEN 4 THEN 'Cancelled'
								WHEN 5 THEN 'Close'
								WHEN 6 THEN 'To Be Cancelled'  
								WHEN 7 THEN 'To Be Rescheduled'
								WHEN 8 THEN 'Rescheduled'
								WHEN 9 THEN 'HoldCancel'
								WHEN 0 THEN 'Failed'
								WHEN 11 THEN 'Cancelled'  
								WHEN 13 THEN 'TJQ Pending' 
								WHEN 14 THEN 'Open Ticket'  
								WHEN 15 THEN 'On Hold canceled'  
							ELSE 'Failed' END) AS Ticketstatus
				, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
				, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.orderId = tbi.orderId
											ORDER BY tblBookMaster.pkId ASC
											FOR XML PATH('')), 1, 1, '') AS pkId
				, ISNULL(a.IsMultiTST, 0) AS IsMultiTST
				FROM (SELECT * FROM (SELECT pid
						, paxFName
						, paxLName
						, tblPassengerBookDetails.fkBookMaster
						, ROW_NUMBER() OVER(PARTITION BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN  
					FROM tblPassengerBookDetails WITH(NOLOCK)
					LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
					LEFT JOIN tblBookItenary WITH(NOLOCK) ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
					WHERE (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), tblBookMaster.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))
								AND (CONVERT(date, tblBookMaster.inserteddate,126) <= (CONVERT(date, @ToDate))))
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR tblBookMaster.depDate = @TravelDate))
						AND (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD 
				WHERE rn = 1) AS T1
				JOIN tblBookMaster  a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster  
				LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster
				AND a.frmSector = tbi.frmSector  
				LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id
				INNER JOIN AgentLogin AL WITH(NOLOCK) ON  a.AgentID = CAST(AL.UserID AS Varchar(50))
				LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
				LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID
				WHERE (ISNULL(a.IsMultiTST, 0) != 1 AND a.returnFlag = 0
				AND  a.AgentID !='B2C'      
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))
				AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
				AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
				AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')  
				AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
				AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
				AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))  
				AND  (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
				AND (@Userid IS NULL OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))  
				AND @Status= a.BookingStatus)
			) p ORDER BY P.booking_date DESC

			SELECT @RecordCount = @@ROWCOUNT 
			
			SELECT * FROM #tempTableB1 
			GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
			, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
			, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
			, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
			ORDER BY booking_date  
			OFFSET @Start ROWS
			FETCH NEXT @Pagesize ROWS ONLY
		END  
	END

	DROP TABLE #mTFilterData, #mTFilterPKID
END 