-- =============================================  
-- Author:  <JD>  
-- Create date: <04.05.2023>  
-- Description: <Description,,>  
-- =============================================  
--exec [TrvlNxt_SearchprocessdataAgentByStatus_BAK_18052023] '2023-05-22','2023-05-24', NULL, NULL, NULL, NULL, NULL, '1', '1', NULL, '0', 0, 3, '', 3, 0, NULL, 0,5000, NULL
--exec TrvlNxt_SearchprocessdataAgentByStatus_BAK_01062023 '2023-09-11','2023-09-11', NULL, 'APBUJP', NULL, NULL, NULL, '99', '99', NULL, NULL, 0, NULL, '', 0, 46957, NULL, 0,5000, NULL, NULL
CREATE PROCEDURE [dbo].[TrvlNxt_SearchprocessdataAgentByStatus_BAK_01062023]
	@FROMDate Date = NULL  
	, @ToDate Date = NULL  
	, @paxname varchar(100)= NULL  
	, @PNR varchar(20) = NULL  
	, @AirlinePNR varchar(20)= NULL  
	, @EmailID varchar(30)= NULL  
	, @MobileNo varchar(20)= NULL  
	, @Status varchar(20)= NULL  
	, @Status2 varchar(30)= NULL   
	, @OrderID varchar(30)= NULL   
	, @Userid varchar(10)= NULL   
	, @SubUserID int = NULL  
	, @ParentID int = NULL   
	, @Currency varchar(20)= NULL  
	  --Added BY JD  
	, @MainAgentId Int = NULL  
	, @AgentID Int = NULL  

	, @Airline varchar(max)= NULL

	, @Start int = NULL  
	, @Pagesize int = NULL   
	
	--Added by JD
	, @TravelDate Date = NULL

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

	IF(@ParentID IS NOT NULL)  
	BEGIN  
		IF (@Status = 99)   
		BEGIN  		 
				IF OBJECT_ID ('tempdb..#tempTableAll') IS NOT NULL  
				DROP TABLE #tempTableAll 
				SELECT * INTO #tempTableAll   
				FROM (
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											GROUP BY airlinePNR 
											FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
						, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast,BRP.Icast) AS Icast
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(ServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS ServiceFee
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline' 
                          THEN(SELECT ISNULL(SUM(GST ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId) 
								ELSE 0 END AS GST
						--, ISNULL(BFC, 0) AS BFC
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(BFC ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN(SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalEarning
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalVendorServiceFee
						, a.GDSPNR
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy HH:mm'))
												FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) and tblBookMaster.orderId = a.orderId
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy HH:mm'))
												FOR XML PATH ('')) , 1, 1, '')) AS booking_date
						--, ISNULL(c.currency, a.AgentCurrency) AS currency
						,CASE 
										WHEN a.AgentROE <> 1 THEN MC.Value
										ELSE ISNULL(c.currency, a.AgentCurrency)
									END AS currency	
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
						--JD
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
							JOIN tblBookMaster a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster     
							LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector     
							LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL WITH(NOLOCK) ON AL.UserID = a.AgentID   
							left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = BR1.FKUserID 
						    LEFT JOIN mcommon MC WITH(NOLOCK) ON AL.NewCurrency = MC.ID  
							WHERE (  
							ISNULL(a.IsMultiTST, 0) != 1 and 
							a.returnFlag = 0
									AND  a.AgentID != 'B2C'
									AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
											AND (CONVERT(date, a.inserteddate,126) <= (CONVERT(date, @ToDate))))
									AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
       								AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
									AND (@PNR IS NULL OR @PNR = '' OR tbi.airlinePNR = @PNR OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR)  
									AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
									AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo LIKE '%' + @MobileNo + '%')   
									AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)   
									AND (@NewsUserID  IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@NewsUserID AS VARCHAR(10)) OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10))))
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM WITH(NOLOCK)   
											INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
									and a.BookingStatus != 18 and a.BookingStatus != 20
									UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK) 
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											GROUP BY airlinePNR 
											FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
						, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast,BRP.Icast) AS Icast
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
					--	, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
					
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy HH:mm')) FROM tblBookMaster	WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR)  and tblBookMaster.orderId = a.orderId
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy HH:mm'))
												FOR XML PATH ('')) , 1, 1, '')) AS booking_date
					--	, ISNULL(c.currency, a.AgentCurrency) AS currency
						,CASE 
										WHEN a.AgentROE <> 1 THEN MC.Value
										ELSE ISNULL(c.currency, a.AgentCurrency)
									END AS currency	
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
						--JD
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
										AND(@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD 
							WHERE rn = 1) AS T1   
							JOIN tblBookMaster a WITH(NOLOCK) ON a.pkId = t1.fkBookMaster     
							LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector     
							LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL WITH(NOLOCK) ON AL.UserID = a.AgentID   
							left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = BR1.FKUserID  
			                 LEFT JOIN mcommon MC WITH(NOLOCK) ON AL.NewCurrency = MC.ID  
							WHERE (  
							ISNULL(a.IsMultiTST, 0) = 1 and 
							a.returnFlag = 0
									AND  a.AgentID != 'B2C'
									AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
											AND (CONVERT(date, a.inserteddate,126) <= (CONVERT(date, @ToDate))))
									AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
       								AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
									AND (@PNR IS NULL OR @PNR = '' OR tbi.airlinePNR = @PNR OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR)  
									AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
									AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo LIKE '%' + @MobileNo + '%')   
									AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)   
									AND (@NewsUserID  IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@NewsUserID AS VARCHAR(10)) OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10))))
									AND a.BookingStatus != 18 and a.BookingStatus != 20
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM WITH(NOLOCK)    
											INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
									) p  ORDER BY P.booking_date DESC

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableAll 
				GROUP BY Country, BookingSource, paxname, email, mob, OfficeID,RiyaPNR,VendorName ,airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
							--, returnFlag, payment_mode, getway_name, Bookticket, LOGO, frmsector
							--, tosector, [Dep Date all], AllPax
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY 
		END  
		ELSE IF(@Status = 55)   
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableA55') IS NOT NULL     
			DROP table  #tempTableA55  
			SELECT * INTO #tempTableA55 FROM  
				(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning  
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning 
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR  
						
						, order_status  
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
				WHERE (ISNULL(a.IsMultiTST, 0) != 1
						AND a.returnFlag = 0
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
						and a.BookingStatus != 18 and a.BookingStatus != 20
						AND a.Country IN (SELECT CountryCode 
												FROM mUserCountryMapping CM WITH(NOLOCK)
												INNER JOIN mCountry C ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)
												AND IsActive = 1)
						AND AL.UserTypeID IN (SELECT UserTypeID   
													FROM mUserTypeMapping WITH(NOLOCK)  
													WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
						AND a.BookingStatus NOT IN (0, 3, 9, 10))
						
						UNION

				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
					,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning 
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning  
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status  
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
				WHERE (ISNULL(a.IsMultiTST, 0) = 1
						AND a.returnFlag = 0
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
						and a.BookingStatus != 18 and a.BookingStatus != 20
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
		--SELECT * FROM  #tempTableA55
				SELECT * FROM #tempTableA55 
				GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
							--, returnFlag, payment_mode, getway_name, Bookticket, LOGO, frmsector
							--, tosector, [Dep Date all], AllPax
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY

	   END   
		ELSE   
		BEGIN   
			IF OBJECT_ID ('tempdb..#tempTableA1') IS NOT NULL   
			DROP table   #tempTableA1  
			SELECT * INTO #tempTableA1 FROM    
			(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
						--JD
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
							LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS varchar(10)) = a.AgentID   
							left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = CAST(BR1.FKUserID AS varchar(10))
							WHERE (
							ISNULL(a.IsMultiTST, 0) != 1 and
							a.returnFlag = 0  
							AND  a.AgentID !='B2C'   
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
							and a.BookingStatus != 18 and a.BookingStatus != 20
							AND a.Country IN (SELECT CountryCode   
												FROM mUserCountryMapping CM WITH(NOLOCK)   
												INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
												AND AL.UserTypeID IN (SELECT UserTypeID   
																		FROM mUserTypeMapping WITH(NOLOCK)  
																		WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)  
						)

									UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
						--JD
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
							LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS varchar(10)) = a.AgentID   
							left JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = CAST(BR1.FKUserID AS varchar(10))
							WHERE (
							ISNULL(a.IsMultiTST, 0) = 1 and
							a.returnFlag = 0  
							AND  a.AgentID !='B2C'   
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
							and a.BookingStatus != 18 and a.BookingStatus != 20
							AND a.Country IN (SELECT CountryCode   
												FROM mUserCountryMapping CM WITH(NOLOCK)  
												INNER JOIN mCountry C ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
												AND AL.UserTypeID IN (SELECT UserTypeID   
																		FROM mUserTypeMapping WITH(NOLOCK)   
																		WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)  
						--AND @Status = '99' OR a.BookingStatus NOT IN (0, 3, 9, 10)
						)
					) P ORDER BY P.booking_date DESC  
				--SELECT @RecordCount = @@ROWCOUNT   
				--SELECT * FROM #tempTableA1  
				--ORDER BY booking_date    
				--OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY   

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableA1 
				GROUP BY Country, BookingSource, paxname, email, mob,OfficeID,RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END   
	  END   
	 ELSE IF(@ParentID IS NULL)   
	 BEGIN  
	  IF (@Status = 99)   
	  BEGIN   
		IF OBJECT_ID ('tempdb..#tempTableB') IS NOT NULL     
			DROP TABLE  #tempTableB  
				SELECT * INTO #tempTableB FROM   
					(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId 
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											LEFT OUTER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											GROUP BY airlinePNR 
											FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
						, ISNULL(BR.AgencyName, BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast, BRP.Icast) AS Icast
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)								
												WHERE tblBookMaster.riyaPNR = a.riyaPNR  and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)								
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
					   , CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline' 
                          THEN (SELECT ISNULL(SUM(ServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS ServiceFee
						--, ISNULL(GST, 0) AS GST
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN(SELECT ISNULL(SUM(GST ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId) 
								ELSE 0 END AS GST
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(BFC ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN(SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalEarning
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline' 
                          THEN (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster	WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
												FOR XML PATH ('')) , 1, 1, '')) AS booking_date
						--, ISNULL(c.currency, a.AgentCurrency) AS currency
						,CASE 
										WHEN a.AgentROE <> 1 THEN MC.Value
										ELSE ISNULL(c.currency, a.AgentCurrency)
									END AS currency	
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy
						--JD
						, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS pkId
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
					    LEFT JOIN mcommon MC WITH(NOLOCK) ON AL.NewCurrency = MC.ID  
						WHERE (ISNULL(a.IsMultiTST, 0) != 1 AND a.returnFlag = 0     
						AND  a.AgentID !='B2C'      
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10),  ISNULL(a.IssueDate, a.inserteddate),126) >= (CONVERT(char(10), @FROMDate)))    
						AND (CONVERT(char(10), ISNULL(a.IssueDate, a.inserteddate),126) <= (CONVERT(char(10), @ToDate))))  
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
						AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
						AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
						AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')   
						AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
						AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
						AND (@Userid IS NULL OR @Userid = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
						and a.BookingStatus != 18 and a.BookingStatus != 20
						AND a.Country IN (SELECT CountryCode   
												FROM mUserCountryMapping CM WITH(NOLOCK)
												INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
						AND AL.UserTypeID IN (SELECT UserTypeID   
												 FROM mUserTypeMapping WITH(NOLOCK)
												 WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
						AND @Status = '99' OR a.BookingStatus = @Status)

						UNION

						SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											LEFT OUTER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
											WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
											GROUP BY airlinePNR 
											FOR XML PATH ('')) , 1, 1, '')) AS airlinePNR
						, ISNULL(BR.AgencyName, BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast, BRP.Icast) AS Icast
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(ServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS ServiceFee
						--, ISNULL(GST, 0) AS GST
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN(SELECT ISNULL(SUM(GST ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId) 
								ELSE 0 END AS GST
						--, ISNULL(BFC, 0) AS BFC
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline'
                          THEN (SELECT ISNULL(SUM(BFC ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline' 
                          THEN(SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalEarning
						,CASE WHEN ISNULL(a.BookingFrom,'') != 'Offline' 
                          THEN (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR and orderId = a.orderId)
								ELSE 0 END AS TotalVendorServiceFee
						, a.GDSPNR
					
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and orderId = a.orderId and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
												FOR XML PATH ('')) , 1, 1, '')) AS booking_date
						--, ISNULL(c.currency, a.AgentCurrency) AS currency
						,CASE 
										WHEN a.AgentROE <> 1 THEN MC.Value
										ELSE ISNULL(c.currency, a.AgentCurrency)
									END AS currency	
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName else BR.Icast end BookedBy
						--JD
						, STUFF((SELECT '/' + CAST(tblBookMaster.pkId AS Varchar(50))
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS pkId
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
						JOIN tblBookMaster a WITH(NOLOCK)ON a.pkId = t1.fkBookMaster     
						LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId = tbi.fkBookMaster   
						AND a.frmSector = tbi.frmSector     
						LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId = c.order_id   
						INNER JOIN AgentLogin AL WITH(NOLOCK) ON  a.AgentID = AL.UserID						
						LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID
						LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID   
						LEFT JOIN mUser MU WITH(NOLOCK) ON MU.ID = A.BookedBy   
						LEFT JOIN B2BRegistration BR1 WITH(NOLOCK) ON a.AgentID = BR1.FKUserID 
			           LEFT JOIN mcommon MC WITH(NOLOCK) ON AL.NewCurrency = MC.ID  
						WHERE (ISNULL(a.IsMultiTST, 0) = 1 AND a.returnFlag = 0     
						AND  a.AgentID !='B2C'      
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10),  ISNULL(a.IssueDate, a.inserteddate),126) >= (CONVERT(char(10), @FROMDate)))    
							AND (CONVERT(char(10), ISNULL(a.IssueDate, a.inserteddate),126) <= (CONVERT(char(10), @ToDate))))  
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
						AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
						AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
						AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')   
						AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
						AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
						AND (@Userid IS NULL OR @Userid = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
						and a.BookingStatus != 18 and a.BookingStatus != 20
						AND a.Country IN (SELECT CountryCode   
												FROM mUserCountryMapping CM WITH(NOLOCK)   
												INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
						AND AL.UserTypeID IN (SELECT UserTypeID   
												 FROM mUserTypeMapping  WITH(NOLOCK) 
												 WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
						AND @Status = '99' OR a.BookingStatus = @Status)
						
						)p  ORDER BY P.booking_date DESC   
						SELECT @RecordCount = @@ROWCOUNT   
						SELECT * FROM #tempTableB
						GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
						ORDER BY booking_date   
						OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY   
	   END  
	  ELSE IF(@Status = 55)   
	  BEGIN   
			IF OBJECT_ID ('tempdb..##tempTableB55') IS NOT NULL     
				DROP TABLE #tempTableB55  
				SELECT * INTO #tempTableB55 FROM  
					(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
					
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK) 
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId)
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
						--JD
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
							WHERE (ISNULL(a.IsMultiTST, 0) != 1 AND a.returnFlag = 0   
							AND  a.AgentID !='B2C'         
							AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
							AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
							AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
							AND (@paxname IS NULL OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))   
							AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
							AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))   
							AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
							AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)     
							AND (@NewsUserID IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
							AND a.BookingStatus NOT IN (0, 3, 9, 10))
							
							UNION

						SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm'))
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning	
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee			
								, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK) 
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster	WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
						--JD
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
							INNER JOIN AgentLogin AL WITH(NOLOCK) ON AL.UserID = a.AgentID   
							LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON AL.UserID = BR.FKUserID-- OR AL.ParentAgentID=BR.FKUserID  
							LEFT JOIN B2BRegistration BRP WITH(NOLOCK) ON AL.ParentAgentID = BRP.FKUserID  
							WHERE (ISNULL(a.IsMultiTST, 0) = 1 AND a.returnFlag = 0   
							AND  a.AgentID !='B2C'         
							AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
							AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
							AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
							AND (@paxname IS NULL OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))   
							AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
							AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))   
							AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
							AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)     
							AND (@NewsUserID IS NULL OR @NewsUserID = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
							AND a.BookingStatus NOT IN (0, 3, 9, 10))

							) p  ORDER BY P.booking_date DESC

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableB55
				GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
				ORDER BY booking_date   
				OFFSET @Start ROWS   
				FETCH NEXT @Pagesize ROWS ONLY END   
	  ELSE   
	  BEGIN   
			IF OBJECT_ID ('tempdb..#tempTableB1') IS NOT NULL   
				DROP table #tempTableB1   
					SELECT * INTO #tempTableB1   
					FROM (SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK)
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId)
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
						--JD
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
						and a.BookingStatus != 18 and a.BookingStatus != 20
						UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						,a.OfficeID
						, a.RiyaPNR
						,a.VendorName
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
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.deptTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)								
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(tblBookMaster.arrivalTime, 'dd-MMM-yyyy HH:mm')) 
												FROM tblBookMaster WITH(NOLOCK)								
												WHERE tblBookMaster.riyaPNR = a.riyaPNR
												FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						,CASE 
								WHEN a.BookingFrom = 'Offline' 
									THEN ISNULL(c.amount, 0)
								ELSE (
									SELECT ISNULL(SUM(bm.totalfare), 0)
									FROM tblBookMaster bm WITH (NOLOCK)
									WHERE bm.riyaPNR = a.RiyaPNR
									  AND bm.orderId = a.orderId)
							END AS totalfare
						,(SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.ParentB2BMarkup)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						) AS ParentB2BMarkup
						,CASE WHEN a.BookingFrom = 'Online' 
						   THEN( SELECT ISNULL(SUM(CONVERT(DECIMAL(18,2), tp1.AirlineFee)), 0)
						   FROM tblPassengerBookDetails tp1 WITH(NOLOCK)
						   WHERE tp1.fkbookmaster = a.pkid
						)ELSE 0 END AS AirlineFee
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						--, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, (SELECT ISNULL(SUM(B2BMarkup ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, ISNULL(MCOAmount, 0) AS MCOAmount
						, (SELECT ISNULL(SUM(ServiceFee), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS ServiceFee
						, (SELECT ISNULL(SUM(GST), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS GST
						, (SELECT ISNULL(SUM(BFC), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS BFC
						, (SELECT ISNULL(SUM(TotalHupAmount), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalHupAmount
						--, ISNULL(TotalEarning, 0) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalEarning ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalEarning
						, (SELECT ISNULL(SUM(TotalVendorServiceFee ), 0) 
								FROM tblBookMaster WITH(NOLOCK)
								WHERE riyaPNR = a.RiyaPNR) AS TotalVendorServiceFee
						, a.GDSPNR
						
						, order_status
						, c.tracking_id
						, STUFF((SELECT '/' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector   
														FROM tblBookMaster WITH(NOLOCK) 
														WHERE tblBookMaster.orderId = tbi.orderId 
														ORDER BY tblBookMaster.pkId ASC
														FOR XML PATH('')), 1, 1, '') AS Sector					
						, (SELECT STUFF((SELECT '/' + UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt')) FROM tblBookMaster WITH(NOLOCK)								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR and tblBookMaster.orderId = a.orderId) 
												GROUP BY UPPER(FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MMM-yyyy hh:mm tt'))
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
						--AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN AL.UserName else BR.Icast end BookedBy
						--JD
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
						WHERE (ISNULL(a.IsMultiTST, 0) = 1 AND a.returnFlag = 0    
						AND  a.AgentID !='B2C'      
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
						AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
						AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')  
						AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
						AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
						AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))  
						AND  (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
						AND (@Userid IS NULL OR a.AgentID = CAST(@Userid AS VARCHAR(10)))  
						and a.BookingStatus != 18 and a.BookingStatus != 20
						AND @Status= a.BookingStatus)
						)p ORDER BY P.booking_date DESC   
						SELECT @RecordCount = @@ROWCOUNT   
						SELECT * FROM #tempTableB1 
						GROUP BY Country, BookingSource, paxname, email, mob,OfficeID, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning,TotalVendorServiceFee
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST,ParentB2BMarkup,AirlineFee
						ORDER BY booking_date  
						OFFSET @Start ROWS   
						FETCH NEXT @Pagesize ROWS ONLY   
			 END  
		END  
	END  