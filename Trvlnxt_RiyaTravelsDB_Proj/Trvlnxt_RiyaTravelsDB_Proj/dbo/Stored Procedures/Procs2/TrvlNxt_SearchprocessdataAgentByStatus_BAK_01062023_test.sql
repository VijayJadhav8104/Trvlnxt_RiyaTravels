-- =============================================  
-- Author:  <JD>  
-- Create date: <04.05.2023>  
-- Description: <Description,,>  
-- =============================================  
--exec [TrvlNxt_SearchprocessdataAgentByStatus_BAK_18052023] '2023-05-22','2023-05-24', NULL, NULL, NULL, NULL, NULL, '1', '1', NULL, '0', 0, 3, '', 3, 0, NULL, 0,5000, NULL
--exec TrvlNxt_SearchprocessdataAgentByStatus_BAK_01062023 '2023-09-11','2023-09-11', NULL, 'APBUJP', NULL, NULL, NULL, '99', '99', NULL, NULL, 0, NULL, '', 0, 46957, NULL, 0,5000, NULL, NULL
CREATE PROCEDURE [dbo].[TrvlNxt_SearchprocessdataAgentByStatus_BAK_01062023_test]
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
	, @SubUserID int = 0  
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
	
	
	IF(@SubUserID != 0)  
	BEGIN  
		IF (@Status = 99)   
		BEGIN  		 
				IF OBJECT_ID ('tempdb..#tempTableAAll') IS NOT NULL  
				DROP TABLE #tempTableAAll 
				SELECT * INTO #tempTableAAll   
				FROM (
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
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
						, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
												FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR)
												GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
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

									UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
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
						, (SELECT ISNULL(SUM(totalfare), 0) 
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
						, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster	WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) 
												GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
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
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM WITH(NOLOCK)    
											INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
									) p  ORDER BY P.booking_date DESC

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableAAll 
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName ,airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
							--, returnFlag, payment_mode, getway_name, Bookticket, LOGO, frmsector
							--, tosector, [Dep Date all], AllPax
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY 
		END  
		ELSE IF(@Status = 55)   
		BEGIN
			IF OBJECT_ID ('tempdb..#tempTableAA55') IS NOT NULL     
			DROP table  #tempTableAA55  
			SELECT * INTO #tempTableAA55 FROM  
				(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
				SELECT * FROM #tempTableAA55 
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
							--, returnFlag, payment_mode, getway_name, Bookticket, LOGO, frmsector
							--, tosector, [Dep Date all], AllPax
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY

	   END   
		ELSE   
		BEGIN   
			IF OBJECT_ID ('tempdb..#tempTableAA1') IS NOT NULL   
			DROP table   #tempTableAA1  
			SELECT * INTO #tempTableAA1 FROM    
			(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
				SELECT * FROM #tempTableAA1 
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY
		END   
	  END   
   ELSE IF(@ParentID IS NOT NULL)  
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
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster WITH(NOLOCK) ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
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
						, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
												FROM tblBookMaster WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR)
												GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
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

									UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						, a.RiyaPNR
						,a.VendorName
						, STUFF((SELECT '/' + airName
											FROM tblBookMaster WITH(NOLOCK)
											WHERE tblBookMaster.riyaPNR = a.riyaPNR
											FOR XML PATH ('')) , 1, 1, '') AS airName
						, (SELECT STUFF((SELECT '/' + airlinePNR
											FROM tblBookItenary WITH(NOLOCK)
											INNER JOIN tblBookMaster ON tblBookItenary.fkBookMaster = tblBookMaster.pkId
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
						, (SELECT ISNULL(SUM(totalfare), 0) 
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
						, (SELECT STUFF((SELECT '/' + FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster	WITH(NOLOCK)
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) 
												GROUP BY FORMAT(ISNULL(tblBookMaster.IssueDate, tblBookMaster.inserteddate), 'dd-MM-yyyy hh:mm:ss tt')
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
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM WITH(NOLOCK)    
											INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WITH(NOLOCK) WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
									) p  ORDER BY P.booking_date DESC

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableAll 
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName ,airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
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
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
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
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
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
			DROP TABLE  #tempTableB  
				SELECT * INTO #tempTableB FROM   
					(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
						WHERE (ISNULL(a.IsMultiTST, 0) != 1 AND a.returnFlag = 0     
						AND  a.AgentID !='B2C'      
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
						AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
						AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
						AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
						AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')   
						AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
						AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
						AND (@Userid IS NULL OR @Userid = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
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
						WHERE (ISNULL(a.IsMultiTST, 0) = 1 AND a.returnFlag = 0     
						AND  a.AgentID !='B2C'      
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NOT NULL OR @TravelDate != '') OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
							AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
						AND (@PNR IS NOT NULL OR @PNR != '' OR (@TravelDate IS NULL OR a.depDate = @TravelDate))
						AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
						AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
						AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')   
						AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
						AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
						AND (@Userid IS NULL OR @Userid = '' OR (AL.ParentAgentID = CAST(@Userid AS VARCHAR(10)) OR a.AgentID = CAST(@Userid AS VARCHAR(10))))-- OR AL.AgentApproved = CAST(@Userid AS VARCHAR(10)))   
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
						GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
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
					(SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
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
					SELECT * INTO #tempTableB1   
					FROM (SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
						UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
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
						AND @Status= a.BookingStatus)
						)p ORDER BY P.booking_date DESC   
						SELECT @RecordCount = @@ROWCOUNT   
						SELECT * FROM #tempTableB1 
						GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR,VendorName, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, MCOAmount, ServiceFee, GST, BFC, TotalHupAmount, TotalEarning
							, GDSPNR, order_status, tracking_id, Sector, booking_date, currency, Ticketstatus, BookedBy, pkId, IsMultiTST
						ORDER BY booking_date  
						OFFSET @Start ROWS   
						FETCH NEXT @Pagesize ROWS ONLY   
			 END  
		END  
	END  