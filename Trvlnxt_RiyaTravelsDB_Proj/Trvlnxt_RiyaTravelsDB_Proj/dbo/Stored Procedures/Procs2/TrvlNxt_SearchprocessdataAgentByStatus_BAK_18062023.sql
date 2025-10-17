-- =============================================  
-- Author:  <JD>  
-- Create date: <04.05.2023>  
-- Description: <Description,,>  
-- =============================================  
--exec [TrvlNxt_SearchprocessdataAgentByStatusNEW1] '2023-05-01','2023-05-01', NULL, '1XX9H9', NULL, NULL, NULL, '99', '99', NULL, 0, 0, 68, '', 68, 0, NULL, 0,5000, NULL
CREATE PROCEDURE [dbo].[TrvlNxt_SearchprocessdataAgentByStatus_BAK_18062023]
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
  
	SELECT @TillDate = TillDate FROM tblBlockTransaction WHERE AgentId = @AgentID  
  
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
						, a.RiyaPNR
						, a.airName
						--, (SELECT STUFF((SELECT '/' + tblBookMaster.airName FROM tblBookMaster WHERE tblBookMaster.riyaPNR = @PNR FOR XML PATH ('')) , 1, 1, '')) AS airName
						, tbi.airlinePNR
						, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast,BRP.Icast) AS Icast
						--, a.deptTime AS deptdate
						, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						--, a.arrivalTime AS arrivaldate
						, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						, ((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0) + ISNULL(ServiceFee, 0) + ISNULL(GST, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, a.GDSPNR
						, order_status
						, c.tracking_id
						, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector   
														FROM tblBookItenary s   
														WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
												FROM tblBookItenary t   
												WHERE t.fkBookMaster = a.pkId    
												GROUP BY t.orderId) AS Sector
						, (SELECT STUFF((SELECT '/' + CAST(s.pkId AS Varchar(100))
														FROM tblBookItenary s   
														WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS pkId   
												FROM tblBookItenary t   
												WHERE t.fkBookMaster = a.pkId    
												GROUP BY t.orderId) AS pkId
						--, a.inserteddate AS booking_date
						, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.inserteddate, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS booking_date
						, c.currency
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
						--, pid
						--, (SELECT STUFF((SELECT '/' + CAST(tblPassengerBookDetails.pid AS VARCHAR(20)) FROM tblPassengerBookDetails
						--						INNER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
						--						WHERE (tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster AND tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS pid
						, a.returnFlag
						, c.payment_mode
						, c.getway_name
						, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS Bookticket
						, ISNULL(AL.Logo, '') AS LOGO
						, (SELECT STUFF((SELECT '/' + s.frmSector   
											FROM tblBookItenary s   
											WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'frmsector'  
						, (SELECT STUFF((SELECT '/' + s.toSector   
											FROM tblBookItenary s   
											WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'tosector'
						, (SELECT STUFF((SELECT '-' + (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))
															FROM tblBookItenary s   
															WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
											FROM tblBookItenary t   
											WHERE t.fkBookMaster = a.pkId    
											GROUP BY t.orderId) AS 'Dep Date all'  
						, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName   
											FROM tblPassengerBookDetails s   
											WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax   
										FROM tblPassengerBookDetails t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.fkBookMaster) AS 'AllPax'   					
			FROM (SELECT * FROM (SELECT pid
									, paxFName
									, paxLName
									, tblPassengerBookDetails.fkBookMaster
									, ROW_NUMBER() OVER(PARTITION BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN  
								FROM tblPassengerBookDetails
								LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
								LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
								WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD 
							WHERE rn = 1) AS T1   
							JOIN tblBookMaster a ON a.pkId = t1.fkBookMaster     
							LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector     
							LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL on AL.UserID = a.AgentID   
							left JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 ON a.AgentID = BR1.FKUserID  
							WHERE (  
							ISNULL(a.IsMultiTST, 0) != 1 and 
							a.returnFlag = 0
									AND  a.AgentID != 'B2C'
									AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
											AND (CONVERT(date, a.inserteddate,126) <= (CONVERT(date, @ToDate))))
       								AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
									AND (@PNR IS NULL OR @PNR = '' OR tbi.airlinePNR = @PNR OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR)  
									AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
									AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo LIKE '%' + @MobileNo + '%')   
									AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)   
									AND (@NewsUserID  IS NULL OR @NewsUserID = '' OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10)))
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM    
											INNER JOIN mCountry C ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))

									UNION
				SELECT A.Country
						, a.BookingSource 
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						, a.RiyaPNR
						--, a.airName
						, (SELECT STUFF((SELECT '/' + tblBookMaster.airName FROM tblBookMaster WHERE tblBookMaster.riyaPNR = a.riyaPNR
											--group by tblBookMaster.airName
											FOR XML PATH ('')) , 1, 1, '')) AS airName
						, tbi.airlinePNR
						, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName
						, ISNULL(BR.Icast,BRP.Icast) AS Icast
						--, a.deptTime AS deptdate
						, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS deptdate
						--, a.arrivalTime AS arrivaldate
						, (SELECT STUFF((SELECT '/' + FORMAT(tblBookMaster.deptTime, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS arrivaldate
						, tbi.orderId
						, ((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0) + ISNULL(ServiceFee, 0) + ISNULL(GST, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, a.GDSPNR
						, order_status
						, c.tracking_id
						, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector   
														FROM tblBookItenary s   
														WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
												FROM tblBookItenary t   
												WHERE t.fkBookMaster = a.pkId    
												GROUP BY t.orderId) AS Sector
						, (SELECT STUFF((SELECT '/' + CAST(s.pkId AS Varchar(100))
														FROM tblBookItenary s   
														WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS pkId   
												FROM tblBookItenary t   
												WHERE t.fkBookMaster = a.pkId    
												GROUP BY t.orderId) AS pkId
						, (SELECT STUFF((SELECT TOP 1 '/' + FORMAT(tblBookMaster.inserteddate, 'dd-MM-yyyy hh:mm:ss tt') FROM tblBookMaster								
												WHERE (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS booking_date
						, c.currency
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
						--, pid
						--, (SELECT STUFF((SELECT '/' + CAST(tblPassengerBookDetails.pid AS VARCHAR(20)) FROM tblPassengerBookDetails
						--						INNER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
						--						WHERE (tblBookMaster.pkId = tblPassengerBookDetails.fkBookMaster AND tblBookMaster.riyaPNR = a.riyaPNR) FOR XML PATH ('')) , 1, 1, '')) AS pid
						, a.returnFlag
						, c.payment_mode
						, c.getway_name
						, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS Bookticket
						, ISNULL(AL.Logo, '') AS LOGO
						, (SELECT STUFF((SELECT '/' + s.frmSector   
											FROM tblBookItenary s   
											WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'frmsector'  
						, (SELECT STUFF((SELECT '/' + s.toSector   
											FROM tblBookItenary s   
											WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'tosector'
						, (SELECT STUFF((SELECT '-' + (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))
															FROM tblBookItenary s   
															WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector   
											FROM tblBookItenary t   
											WHERE t.fkBookMaster = a.pkId    
											GROUP BY t.orderId) AS 'Dep Date all'  
						, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName   
											FROM tblPassengerBookDetails s   
											WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax   
										FROM tblPassengerBookDetails t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.fkBookMaster) AS 'AllPax'   					
					FROM (SELECT * FROM (SELECT pid
											, paxFName
											, paxLName
											, tblPassengerBookDetails.fkBookMaster
											, ROW_NUMBER() OVER(PARTITION BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN  
										FROM tblPassengerBookDetails
										LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
										LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
										WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD 
							WHERE rn = 1) AS T1   
							JOIN tblBookMaster a ON a.pkId = t1.fkBookMaster     
							LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector     
							LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId  
							INNER JOIN AgentLogin AL on AL.UserID = a.AgentID   
							left JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
							left JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
							LEFT JOIN mUser MU ON MU.ID = A.BookedBy   
							LEFT JOIN B2BRegistration BR1 ON a.AgentID = BR1.FKUserID  
							WHERE (  
							a.IsMultiTST = 1 and 
							a.returnFlag = 0
									AND  a.AgentID != 'B2C'
									AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
											AND (CONVERT(date, a.inserteddate,126) <= (CONVERT(date, @ToDate))))
       								AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
									AND (@PNR IS NULL OR @PNR = '' OR tbi.airlinePNR = @PNR OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR)  
									AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
									AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo LIKE '%' + @MobileNo + '%')   
									AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)   
									AND (@NewsUserID  IS NULL OR @NewsUserID = '' OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10)))
									AND a.Country IN (SELECT CountryCode   
											FROM mUserCountryMapping CM    
											INNER JOIN mCountry C ON CM.CountryId = C.ID   
											WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID)  AND IsActive = 1)   
									AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1))
									) p  ORDER BY P.booking_date DESC

				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableAll 
				GROUP BY Country, BookingSource, paxname, email, mob, RiyaPNR, airName
							, airlinePNR, AgencyName, Icast, deptdate, arrivaldate, orderId
							, totalfare, ROE, AgentROE, B2BMarkup, Markup, GDSPNR, order_status
							, tracking_id, Sector, pkId, booking_date, currency, Ticketstatus, BookedBy
							, returnFlag, payment_mode, getway_name, Bookticket, LOGO, frmsector
							, tosector, [Dep Date all], AllPax
				ORDER BY booking_date 
				OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY 
	END  
	ELSE IF(@Status = 55)   
	BEGIN  
		IF OBJECT_ID ('tempdb..#tempTableA55') IS NOT NULL     
		DROP table  #tempTableA55  
		SELECT * INTO #tempTableA55 FROM  
		 (SELECT  pid, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname  
		   , a.emailId AS email  
		   , a.mobileNo AS mob  
		   , a.RiyaPNR, a.airName
		   , ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName  
		   , ISNULL(BR.Icast,BRP.Icast) AS Icast  
		   , tbi.airlinePNR  
		   , a.deptTime AS deptdate  
		   , a.arrivalTime AS arrivaldate  
		   , a.OrderId  
		   --, (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0))  AS totalfare  
		   , ((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare  
		   , ISNULL(a.ROE, 1) ROE   
		   , ISNULL(a.AgentROE, 1) AgentROE   
		   , ISNULL(a.B2BMarkup, 0) B2BMarkup   
		   , ISNULL(a.AgentMarkup, 0) Markup   
		   , a.inserteddate AS booking_date   
		   , a.GDSPNR   
		   , order_status  
		   , c.payment_mode   
		   , c.getway_name   
		   , 'Void' AS [Ticketstatus]   
		   , CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]   
		   , a.BookingSource   
		   , c.tracking_id   
		   , A.Country  
		   , c.currency  
		   , ISNULL(AL.Logo, '') AS LOGO  
		   , (SELECT STUFF((SELECT '/' + s.frmSector 
								FROM tblBookItenary s 
								WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
						FROM tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'frmsector'  
		   , (SELECT STUFF((SELECT '/' + s.toSector 
								FROM tblBookItenary s 
								WHERE s.orderId = t.orderId FOR XML PATH('')),  1, 1, '') AS Sector 
						FROM tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'tosector'  
		   , (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector 
								FROM tblBookItenary s 
								WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
						FROM tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'Sector'  
		   , (SELECT STUFF((SELECT '-' + (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103)) 
												FROM tblBookItenary s 
												WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
								FROM tblBookItenary t 
								WHERE t.fkBookMaster = a.pkId  
								GROUP BY t.orderId) AS 'Dep Date all'  
		   , (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName   
								FROM tblPassengerBookDetails s  
								WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax   
						FROM tblPassengerBookDetails t   
						WHERE t.fkBookMaster = a.pkId    
						GROUP BY t.fkBookMaster) AS 'AllPax'   
			FROM (SELECT * FROM (SELECT pid  
					 , paxFName  
					 , paxLName  
					 , tblPassengerBookDetails.fkBookMaster  
					 , ROW_NUMBER() OVER(Partition BY tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN   
					FROM tblPassengerBookDetails 
					LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
					LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
					WHERE CheckboxVoid = 1 AND (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD  
					WHERE rn = 1) AS T1         
		   JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster  
		   LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector     
		   LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id   
		   INNER JOIN AgentLogin AL ON AL.UserID = a.AgentID   
		   left JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
		  left JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
		   WHERE (   
			a.returnFlag = 0   
			AND  a.AgentID !='B2C'         
			AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
			  AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(date, @ToDate))))  
			AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
			AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
			AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId LIKE '%' + @EmailID + '%'))   
			AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
			AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)           
			AND (@NewsUserID IS NULL OR @NewsUserID = '' OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10)))         
			AND a.Country IN (SELECT CountryCode   
				 FROM mUserCountryMapping CM   
				 INNER JOIN mCountry C ON CM.CountryId = C.ID   
				 WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
			AND AL.UserTypeID in (SELECT UserTypeID   
				  FROM mUserTypeMapping   
				  WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)  
			AND a.BookingStatus not in (0, 3, 9, 10)  
			 --WHERE (  
			 -- a.returnFlag = 0   
			 -- AND  a.AgentID !='B2C'         
			 -- AND (@PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
			 -- AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(date, @ToDate))))  
        		   --  AND (paxfname + ' ' + paxlname  like '%' + @paxname + '%')   
			 -- AND ((@PNR = '') OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
       			   --  AND (a.emailId LIKE '%' + @EmailID + '%')    
			 -- AND (a.mobileNo LIKE '%' + @MobileNo + '%')    
			 -- AND (c.order_id = @OrderID OR @OrderID = '')           
			 -- AND (a.AgentID = CAST(@NewsUserID AS VARCHAR(10)) OR @NewsUserID = '')         
			 -- AND a.Country IN (SELECT CountryCode FROM mUserCountryMapping CM  INNER JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId = @ParentID  AND IsActive = 1)   
			 -- AND AL.UserTypeID in (SELECT UserTypeID from mUserTypeMapping WHERE UserId = @ParentID  AND IsActive = 1)  
		   )) p  
		   ORDER BY P.booking_date DESC  
		SELECT @RecordCount = @@ROWCOUNT   
		SELECT * FROM #tempTableA55  
		ORDER BY booking_date   
		OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY  
	   END   
	  ELSE   
	  BEGIN   
			IF OBJECT_ID ('tempdb..#tempTableA1') IS NOT NULL   
			DROP table   #tempTableA1  
			SELECT * INTO #tempTableA1 FROM    
			(SELECT pid, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname  
					 , a.emailId AS email  
					 , a.mobileNo AS mob, a.RiyaPNR  
					 , a.airName
					 , ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName 
					 , ISNULL(BR.Icast,BRP.Icast) AS Icast  
					 , tbi.airlinePNR  
					 , a.arrivalTime AS arrivaldate  
					, a.deptTime AS deptdate 
					 , a.OrderId  
					 , (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)) AS totalfare  
					 , ISNULL(a.ROE, 1) ROE  
					 , ISNULL(a.AgentROE, 1) AgentROE  
					 , ISNULL(a.B2BMarkup, 0) B2BMarkup  
					 , ISNULL(a.AgentMarkup, 0) Markup  
					 , a.inserteddate AS booking_date  
					 , a.GDSPNR   
					 , c.order_status   
					 , c.payment_mode   
					 , c.getway_name  
					 , CASE a.BookingStatus  
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
									WHEN 14 THEN 'Open ticket' 
									WHEN 13 THEN 'TJQ Pending' 
									WHEN 11 THEN 'Cancelled'  
									WHEN 15 THEN 'On Hold canceled'  
									ELSE 'Failed' END AS [Ticketstatus]  
					 , CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]  
					 , c.tracking_id  
					 , a.Country  
					 , c.currency  
					 , ISNULL(AL.Logo, '') AS LOGO   
					 , a.BookingSource   
					 , CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy    
					 , (SELECT STUFF((SELECT '/' + s.frmSector
												FROM tblBookItenary s 
												WHERE s.orderId = t.orderId 
												FOR XML PATH('')), 1, 1, '') AS Sector 
										FROM tblBookItenary t 
										WHERE t.fkBookMaster = a.pkId  
										GROUP BY t.orderId) AS 'frmsector'   
					 , (SELECT STUFF((SELECT '/' + s.toSector 
												FROM tblBookItenary s
												WHERE s.orderId = t.orderId
												FOR XML PATH('')), 1, 1, '') AS Sector 
										FROM tblBookItenary t
										WHERE t.fkBookMaster = a.pkId 
										GROUP BY t.orderId) AS 'tosector'  
					 , (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
												FROM tblBookItenary s 
												WHERE s.orderId = t.orderId
												FOR XML PATH('')), 1, 1, '') AS Sector 
									FROM tblBookItenary t
									WHERE t.fkBookMaster = a.pkId 
									GROUP BY t.orderId) AS 'Sector'  
					 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103 ))  
												FROM tblBookItenary s 
												WHERE s.orderId = t.orderId
												FOR XML PATH('')), 1, 1, '') AS Sector 
									FROM tblBookItenary t 
									WHERE t.fkBookMaster = a.pkId  
									GROUP BY t.orderId) AS 'Dep Date all'  
					 , (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName 
												FROM tblPassengerBookDetails s 
												WHERE s.fkBookMaster = t.fkBookMaster 
												FOR XML PATH('')), 1, 1, '') AS AllPax
									FROM tblPassengerBookDetails t 
									WHERE t.fkBookMaster = a.pkId 
									GROUP BY t.fkBookMaster) AS 'AllPax' 
							From (SELECT * FROM (SELECT pid, paxFName, paxLName, tblPassengerBookDetails.fkBookMaster, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN   
						From tblPassengerBookDetails 
						LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
						LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
						WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD WHERE rn = 1) AS T1   
						JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster     
						LEFT JOIN tblBookItenary tbi   ON a.pkId = tbi.fkBookMaster   
						AND a.frmSector = tbi.frmSector     
						LEFT JOIN Paymentmaster c  ON a.OrderId = c.order_id   
						INNER JOIN AgentLogin AL ON AL.UserID = a.AgentID       
						LEFT JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
						LEFT JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
						LEFT JOIN mUser MU ON MU.ID = A.BookedBy   
						LEFT JOIN B2BRegistration BR1 ON a.AgentID = BR1.FKUserID      
						WHERE (a.returnFlag = 0  
						AND  a.AgentID !='B2C'   
						AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
						AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(date, @ToDate))))  
						AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))   
						AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
						AND (@AirlinePNR IS NULL OR @AirlinePNR = '' OR @AirlinePNR = '' OR airlinePNR = @AirlinePNR )  
						AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))   
						AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))   
						AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)    
						--AND a.BookingStatus = @Status   
						AND (@NewsUserID IS NULL OR @NewsUserID = '' OR a.AgentID = CAST(@NewsUserID AS VARCHAR(10)))   
						AND a.Country in (SELECT CountryCode   
												FROM mUserCountryMapping CM    
												INNER JOIN mCountry C ON CM.CountryId = C.ID   
												WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
												AND AL.UserTypeID in (SELECT UserTypeID   
																		FROM mUserTypeMapping   
																		WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)  
												AND @Status = '99' OR a.BookingStatus not in (0, 3, 9, 10))) P   
												ORDER BY P.booking_date DESC  
				SELECT @RecordCount = @@ROWCOUNT   
					SELECT * FROM #tempTableA1  
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
					(SELECT pid, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname  
						, a.emailId AS email  
						, a.mobileNo AS mob  
						, a.RiyaPNR   
						, a.airName  
						, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName   
						, ISNULL(BR.Icast,BRP.Icast) AS Icast  
						, tbi.airlinePNR   
						 --AVINASH ADDED  
						, CASE WHEN a.MainAgentId > 0 THEN mu.UserName ELSE br1.Icast END BookedBy  
						, a.deptTime AS deptdate  
						, a.arrivalTime AS arrivaldate  
						, a.OrderId  
						--, (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)) AS totalfare  
						, ((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0)+ ISNULL(ServiceFee, 0) + ISNULL(GST, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare  
						, ISNULL(a.ROE, 1) ROE  
						, ISNULL(a.AgentROE, 1) AgentROE  
						, ISNULL(a.B2BMarkup, 0) B2BMarkup  
						, ISNULL(a.AgentMarkup, 0) Markup  
						, a.inserteddate AS booking_date  
						, a.GDSPNR  
						, order_status   
						, c.payment_mode   
						, c.getway_name   
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
								WHEN 14 THEN 'Open ticket'   
								WHEN 15 THEN 'On Hold canceled'  
								ELSE 'Failed' END )AS [Ticketstatus]  
						, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]  
						, c.tracking_id  
						, A.Country  
						, c.currency   
						, ISNULL(AL.Logo, '') AS LOGO   
						, a.BookingSource  
						, (SELECT STUFF((SELECT '/' + s.frmSector 
												FROM tblBookItenary s
												WHERE s.orderId = t.orderId 
												FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'frmsector'  
						, (SELECT STUFF((SELECT '/' + s.toSector 
												FROM tblBookItenary s
												WHERE s.orderId = t.orderId 
												FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM  tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'tosector'   
						, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector 
												FROM  tblBookItenary s 
												WHERE s.orderId = t.orderId
												FOR XML PATH('')), 1, 1, '') AS Sector
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'Sector'  
						, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  
												FROM tblBookItenary s   
												WHERE s.orderId = t.orderId 
												FOR XML PATH('')), 1, 1, '') AS Sector   
										FROM tblBookItenary t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.orderId) AS 'Dep Date all'   
						, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName   
												FROM tblPassengerBookDetails s   
												WHERE s.fkBookMaster = t.fkBookMaster   
												FOR XML PATH('')), 1, 1, '') AS AllPax   
										FROM tblPassengerBookDetails t   
										WHERE t.fkBookMaster = a.pkId    
										GROUP BY t.fkBookMaster) AS 'AllPax'   
										FROM (SELECT * from   
													(SELECT pid  
															, paxFName  
															, paxLName  
															, tblPassengerBookDetails.fkBookMaster  
															, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN   
															FROM tblPassengerBookDetails
															LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
															LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
															WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD   
																WHERE rn = 1) AS T1  
																JOIN tblBookMaster a ON a.pkId = t1.fkBookMaster     
																LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster   
																AND a.frmSector = tbi.frmSector     
																LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id   
																INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID   
																LEFT JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
																LEFT JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID   
																LEFT JOIN mUser MU ON MU.ID = A.BookedBy   
																LEFT JOIN B2BRegistration BR1 ON a.AgentID = BR1.FKUserID     
										WHERE (a.returnFlag = 0     
										AND  a.AgentID !='B2C'      
										AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
										AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
										AND (@paxname IS NULL OR @paxname = '' OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))  
										AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
										AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')   
										AND (@MobileNo IS NULL OR @MobileNo = '' OR a.mobileNo like '%' + @MobileNo + '%')  
										AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
										AND (@Userid IS NULL OR @Userid = '' OR a.AgentID = CAST(@Userid AS VARCHAR(10)))   
										AND a.Country in (SELECT CountryCode   
																FROM mUserCountryMapping CM   
																INNER JOIN mCountry C ON CM.CountryId = C.ID   
																WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
										AND AL.UserTypeID in (SELECT UserTypeID   
																 FROM mUserTypeMapping   
																 WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)   
										AND @Status = '99' OR a.BookingStatus = @Status))p  ORDER BY P.booking_date DESC   
						SELECT @RecordCount = @@ROWCOUNT   
						SELECT * FROM #tempTableB   
						ORDER BY booking_date   
						OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY   
	   END  
	  ELSE IF(@Status = 55)   
	  BEGIN   
			IF OBJECT_ID ('tempdb..##tempTableB55') IS NOT NULL     
				DROP TABLE #tempTableB55  
				SELECT * INTO #tempTableB55 FROM  
					(SELECT  pid  
							, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname   
							, a.emailId AS email  
							, a.mobileNo AS mob  
       						, a.RiyaPNR   
							, a.airName  
							, ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName   
							, ISNULL(BR.Icast,BRP.Icast) AS Icast   
							, tbi.airlinePNR  
							, a.deptTime AS deptdate   
							, a.arrivalTime AS arrivaldate  
							, a.OrderId  
							, (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)) AS totalfar   
							, ISNULL(a.ROE, 1) ROE   
							, ISNULL(a.AgentROE, 1) AgentROE   
							, ISNULL(a.B2BMarkup, 0) B2BMarkup   
							, ISNULL(a.AgentMarkup, 0) Markup   
							, a.inserteddate AS booking_date   
							, a.GDSPNR  
							, order_status   
							, c.payment_mode   
							, c.getway_name   
							, 'Void' AS [Ticketstatus]   
							, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]   
							, a.BookingSource   
							, c.tracking_id   
							, A.Country   
							, c.currency     
							, ISNULL(AL.Logo, '') AS LOGO  
							, (SELECT STUFF((SELECT '/' + s.frmSector 
														FROM tblBookItenary s 
														WHERE s.orderId = t.orderId 
														FOR XML PATH('')), 1, 1, '') AS Sector 
											FROM tblBookItenary t 
											WHERE t.fkBookMaster = a.pkId 
											GROUP BY t.orderId) AS 'frmsector'   
							, (SELECT STUFF((SELECT '/' + s.toSector 
														FROM tblBookItenary s 
														WHERE s.orderId = t.orderId 
														FOR XML PATH('')), 1, 1, '') AS Sector 
											FROM tblBookItenary t
											WHERE t.fkBookMaster = a.pkId 
											GROUP BY t.orderId) AS 'tosector'  
							, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
														FROM tblBookItenary s
														WHERE s.orderId = t.orderId 
														FOR XML PATH('')), 1, 1, '') AS Sector
											FROM tblBookItenary t 
											WHERE t.fkBookMaster = a.pkId  
											GROUP BY t.orderId) AS 'Sector'  
							, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  
														FROM tblBookItenary s 
														WHERE s.orderId = t.orderId
														FOR XML PATH('')), 1, 1, '') AS Sector 
											FROM tblBookItenary t 
											WHERE t.fkBookMaster = a.pkId 
											GROUP BY t.orderId) AS 'Dep Date all'  
							, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName 
														FROM tblPassengerBookDetails s 
														WHERE s.fkBookMaster = t.fkBookMaster
														FOR XML PATH('')), 1, 1, '') AS AllPax 
											FROM tblPassengerBookDetails t
											WHERE t.fkBookMaster = a.pkId  
											GROUP BY t.fkBookMaster) AS 'AllPax'   
							 FROM (SELECT * FROM (SELECT pid
														, paxFName
														, paxLName
														, tblPassengerBookDetails.fkBookMaster
														, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN 
													FROM tblPassengerBookDetails
													LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId
													LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
													WHERE CheckboxVoid = 1 and (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD
															WHERE rn = 1 ) AS T1   
															JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster     
															LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster   
															AND a.frmSector = tbi.frmSector     
															LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id   
															INNER JOIN AgentLogin AL on AL.UserID = a.AgentID   
															LEFT JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
															LEFT JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
							WHERE (a.returnFlag = 0   
							AND  a.AgentID !='B2C'         
							AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))    
							AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
							AND (@paxname IS NULL OR (paxfname + ' ' + paxlname  like '%' + @paxname + '%'))   
							AND (@PNR IS NULL OR @PNR = '' OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))  
							AND (@EmailID IS NULL OR @EmailID = '' OR (a.emailId like '%' + @EmailID + '%'))   
							AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))    
							AND (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)     
							AND (@NewsUserID IS NULL OR @NewsUserID = '' OR a.AgentID = CAST(@Userid AS VARCHAR(10)))   
							AND a.BookingStatus not in (0, 3, 9, 10))) p  ORDER BY P.booking_date DESC  
				SELECT @RecordCount = @@ROWCOUNT   
				SELECT * FROM #tempTableB55  
				ORDER BY booking_date   
				OFFSET @Start ROWS   
				FETCH NEXT @Pagesize ROWS ONLY END   
	  ELSE   
	  BEGIN   
			IF OBJECT_ID ('tempdb..#tempTableB1') IS NOT NULL   
				DROP table #tempTableB1   
					SELECT * INTO #tempTableB1   
					FROM (SELECT   
								pid   
								 , ISNULL(paxfname, '')+ ' ' + paxlname AS paxname   
								 , a.emailId AS email  
								 , a.mobileNo AS mob   
         						 , a.RiyaPNR   
								 , a.airName   
								 , ISNULL(BR.AgencyName,BRP.AgencyName) AS AgencyName  
								 , ISNULL(BR.Icast,BRP.Icast) AS Icast   
								 , tbi.airlinePNR  
								 , a.deptTime AS deptdate  
								 , a.arrivalTime AS arrivaldate   
								 , a.OrderId   
								 , (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)) AS totalfare   
								 , ISNULL(a.ROE, 1) ROE   
								 , ISNULL(a.AgentROE, 1) AgentROE   
								 , a.inserteddate AS booking_date   
								 , a.GDSPNR   
								 , c.order_status   
								 , c.payment_mode   
								 , c.getway_name  
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
											WHEN 15 THEN 'On Hold canceled'  
											WHEN 14 THEN 'Open ticket'   
											ELSE 'Failed' END) AS [Ticketstatus]  
								 , CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]   
								 , c.tracking_id   
								 , a.Country   
								 , c.currency  
								 , ISNULL(AL.Logo, '') AS LOGO  
								 , ISNULL(a.B2BMarkup, 0) B2BMarkup  
								 , ISNULL(a.AgentMarkup, 0) Markup   
								 , a.BookingSource   
       							 , (SELECT STUFF((SELECT '/' + s.frmSector 
															FROM tblBookItenary s 
															WHERE s.orderId = t.orderId 
															FOR XML PATH('')), 1, 1, '') AS Sector
													FROM tblBookItenary t 
													WHERE t.fkBookMaster = a.pkId  
													GROUP BY t.orderId) AS 'frmsector'  
								 , (SELECT STUFF((SELECT '/' + s.toSector
															FROM tblBookItenary s
															WHERE s.orderId = t.orderId 
															FOR XML PATH('')), 1, 1, '') AS Sector
													FROM tblBookItenary t
													WHERE t.fkBookMaster = a.pkId  
													GROUP BY t.orderId) AS 'tosector'  
								 , (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector 
															FROM tblBookItenary s
															WHERE s.orderId = t.orderId
															FOR XML PATH('')), 1, 1, '') AS Sector 
													FROM tblBookItenary t
													WHERE t.fkBookMaster = a.pkId 
													GROUP BY t.orderId) AS 'Sector'  
								 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103)) 
															FROM tblBookItenary s
															WHERE s.orderId = t.orderId 
															FOR XML PATH('')), 1, 1, '') AS Sector 
													FROM tblBookItenary t 
													WHERE t.fkBookMaster = a.pkId 
													GROUP BY t.orderId) AS 'Dep Date all'  
								, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName 
															FROM tblPassengerBookDetails s 
															WHERE s.fkBookMaster = t.fkBookMaster
															FOR XML PATH('')), 1, 1, '') AS AllPax 
													FROM tblPassengerBookDetails t 
													WHERE t.fkBookMaster = a.pkId  
													GROUP BY t.fkBookMaster) AS 'AllPax'   
								FROM (SELECT * from (SELECT pid
															, paxFName
															, paxLName
															, tblPassengerBookDetails.fkBookMaster
															, ROW_NUMBER() OVER(Partition by tblPassengerBookDetails.fkBookMaster ORDER BY pid) AS RN 
															FROM tblPassengerBookDetails
															LEFT OUTER JOIN tblBookMaster ON tblPassengerBookDetails.fkBookMaster = tblBookMaster.pkId 
															LEFT JOIN tblBookItenary ON tblBookMaster.pkId = tblBookItenary.fkBookMaster
										WHERE (@PNR IS NULL OR @PNR = '' OR (tblBookMaster.riyaPNR = @PNR OR tblBookMaster.GDSPNR = @PNR OR tblBookItenary.airlinePNR = @PNR))) AS tblPBD where rn = 1) AS T1   
										JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster     
										LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster   
										AND a.frmSector = tbi.frmSector     
										LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id   
										INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID   
										LEFT JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
										LEFT JOIN B2BRegistration BRP ON AL.ParentAgentID = BRP.FKUserID  
										WHERE (a.returnFlag = 0    
										AND  a.AgentID !='B2C'      
										AND (@PNR IS NOT NULL OR @PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))   
										AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(char(10), @ToDate))))  
										AND (@paxname IS NULL OR @paxname = '' OR paxfname + ' ' + paxlname  like '%' + @paxname + '%')  
										AND (@PNR IS NULL OR @PNR = '' OR a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR)  
										AND (@EmailID IS NULL OR @EmailID = '' OR a.emailId like '%' + @EmailID + '%')  
										AND (@MobileNo IS NULL OR @MobileNo = '' OR (a.mobileNo like '%' + @MobileNo + '%'))  
										AND  (@OrderID IS NULL OR @OrderID = '' OR c.order_id = @OrderID)  
										--AND  a.BookingStatus = @Status   
										AND (@Userid IS NULL OR a.AgentID = CAST(@Userid AS VARCHAR(10)))  
										AND @Status = '99' OR a.BookingStatus not in (0, 3, 9, 10))    
										)p ORDER BY P.booking_date DESC   
						SELECT @RecordCount = @@ROWCOUNT   
						SELECT * FROM #tempTableB1  
						ORDER BY booking_date  
						OFFSET @Start ROWS   
						FETCH NEXT @Pagesize ROWS ONLY   
			 END  
		END  
	END  