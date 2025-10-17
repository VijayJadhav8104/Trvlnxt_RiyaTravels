-- =============================================
-- Author:		<JD>
-- Create date: <14.02.2023>
-- Description:	<Description,,>
-- =============================================
--exec [TrvlNxt_SearchprocessdataAgentByStatusNEW1_Test] '2022-10-08','2022-10-11','','8L1XF9','','','',99,99,'',0,5000,0,0,3,'','',3,0,4 
CREATE PROCEDURE [dbo].[TrvlNxt_SearchprocessdataAgentByStatusNEW1_Test]
	@FROMDate Date = NULL
	, @ToDate Date = NULL
	, @paxname varchar(100)= NULL
	, @PNR varchar(20)= NULL
	, @AirlinePNR varchar(20)= NULL
	, @EmailID varchar(30)= NULL
	, @MobileNo varchar(20)= NULL
	, @Status varchar(20)= NULL
	, @Status2 varchar(30)= NULL 
	, @OrderID varchar(30)= NULL
	, @Start int = NULL
	, @Pagesize int = NULL 
	, @Userid varchar(10)= NULL 
	, @SubUserID int = NULL
	, @ParentID int = NULL 
	, @Airline varchar(max)= NULL
	, @Currency varchar(20)= NULL
   --Added BY JD
	, @MainAgentId Int = NULL
	, @AgentID Int = NULL

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
			IF OBJECT_ID ('tempdb..#tempTableA') IS NOT NULL
			DROP table #tempTableA
			SELECT * INTO #tempTableA 
			FROM (
				SELECT pid
						, ISNULL(paxfname, '') + ' ' + paxlname AS paxname
						, a.emailId AS email
						, a.mobileNo AS mob
						, a.returnFlag
           				, a.RiyaPNR
						, a.airName, 
						BR.AgencyName, 
						BR.Icast, 
						tbi.airlinePNR,
						--AVINASH ADDED
						CASE WHEN a.MainAgentId > 0 THEN mu.UserName else br1.Icast end BookedBy, 
						-- a.frmsector, a.tosector AS tosector, 
						a.deptTime AS deptdate, 
						a.arrivalTime AS arrivaldate, 
						a.OrderId, 
						((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare
						, ISNULL(a.ROE, 1) ROE
						, ISNULL(a.AgentROE, 1) AS AgentROE
						, ISNULL(a.B2BMarkup, 0) AS B2BMarkup
						, ISNULL(a.AgentMarkup, 0) AS Markup
						, a.inserteddate AS booking_date
						, a.GDSPNR
						, order_status
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
								WHEN 0 THEN 'Failed' 
								WHEN 11 THEN 'Cancelled'
								WHEN 14 THEN 'Open Ticket'
								WHEN 15 THEN 'On Hold canceled'
						 ELSE 'Failed' END AS Ticketstatus
					, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS Bookticket
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

					, (SELECT STUFF((SELECT '-' + (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  
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
						FROM (SELECT * FROM (SELECT pid, paxFName, paxLName, fkBookMaster, ROW_NUMBER() OVER(PARTITION BY fkBookMaster ORDER BY pid) AS RN
												FROM tblPassengerBookDetails) 
								AS tblPBD WHERE rn = 1) AS T1 
						JOIN tblBookMaster a ON a.pkId = t1.fkBookMaster   
						LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector   
						LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id --LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId
						INNER JOIN AgentLogin AL on AL.UserID = a.AgentID 
						INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID 
						LEFT JOIN mUser MU ON MU.ID = A.BookedBy 
						LEFT JOIN B2BRegistration BR1 ON a.AgentID = BR1.FKUserID
						WHERE (
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
								AND AL.UserTypeID IN (SELECT UserTypeID FROM mUserTypeMapping WHERE (@ParentID IS NULL OR @ParentID = '' OR UserId = @ParentID) AND IsActive = 1)
								)
				) p  ORDER BY P.booking_date DESC 
				SELECT @RecordCount = @@ROWCOUNT 

				SELECT * FROM #tempTableA ORDER BY booking_date OFFSET @Start ROWS FETCH NEXT @Pagesize ROWS ONLY 
			
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
							, BR.AgencyName
							, BR.Icast
							, tbi.airlinePNR
							, a.deptTime AS deptdate
							, a.arrivalTime AS arrivaldate
							, a.OrderId
							--, (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0))	 AS totalfare
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
							, (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'frmsector'
							, (SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),  1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'tosector'
							, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Sector'
							, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Dep Date all'
							, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName 
												FROM tblPassengerBookDetails s
												WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax 
										FROM tblPassengerBookDetails t 
										WHERE t.fkBookMaster = a.pkId  
										GROUP BY t.fkBookMaster) AS 'AllPax' 
								FROM (SELECT * FROM (SELECT pid
															, paxFName
															, paxLName
															, fkBookMaster
															, ROW_NUMBER() OVER(Partition BY fkBookMaster ORDER BY pid) AS RN 
														FROM tblPassengerBookDetails
														WHERE CheckboxVoid = 1) AS tblPBD
										WHERE rn = 1) AS T1       
							JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster
							LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster AND a.frmSector = tbi.frmSector   
							LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id 
							INNER JOIN AgentLogin AL on AL.UserID = a.AgentID 
							INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID
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
									--	a.returnFlag = 0 
									--	AND  a.AgentID !='B2C'       
									--	AND (@PNR != '' OR (CONVERT(char(10), a.inserteddate,126) >= (CONVERT(char(10), @FROMDate)))  
									--	AND (CONVERT(char(10), a.inserteddate,126) <= (CONVERT(date, @ToDate))))
        							--  AND (paxfname + ' ' + paxlname  like '%' + @paxname + '%') 
									--	AND ((@PNR = '') OR (a.riyaPNR = @PNR OR a.GDSPNR = @PNR OR tbi.airlinePNR = @PNR))
       								--  AND (a.emailId LIKE '%' + @EmailID + '%')  
									--	AND (a.mobileNo LIKE '%' + @MobileNo + '%')  
									--	AND (c.order_id = @OrderID OR @OrderID = '')         
									--	AND (a.AgentID = CAST(@NewsUserID AS VARCHAR(10)) OR @NewsUserID = '')       
									--	AND a.Country IN (SELECT CountryCode FROM mUserCountryMapping CM  INNER JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId = @ParentID  AND IsActive = 1) 
									--	AND AL.UserTypeID in (SELECT UserTypeID from mUserTypeMapping WHERE UserId = @ParentID  AND IsActive = 1)
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
					, BR.AgencyName
					, BR.Icast
					, tbi.airlinePNR
					, a.arrivalTime AS arrivaldate
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
							WHEN 0 THEN 'Failed' 
							WHEN 14 THEN 'Open ticket' 
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
					, (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'frmsector' 
					, (SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'tosector'
					, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Sector'
					, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103 ))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Dep Date all'
					, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax FROM tblPassengerBookDetails t WHERE t.fkBookMaster = a.pkId  GROUP BY t.fkBookMaster) AS 'AllPax' from (SELECT * from (SELECT pid, paxFName, paxLName, fkBookMaster, ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN   from tblPassengerBookDetails  ) AS tblPBD WHERE rn = 1) AS T1 
				JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster   
				LEFT JOIN tblBookItenary tbi   ON a.pkId = tbi.fkBookMaster 
				AND a.frmSector = tbi.frmSector   
				LEFT JOIN Paymentmaster c  ON a.OrderId = c.order_id 
				INNER JOIN AgentLogin AL on AL.UserID = a.AgentID     
				INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID 
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
	ELSE if(@ParentID IS NULL) 
	BEGIN
		IF (@Status = 99) 
		BEGIN 
			IF OBJECT_ID ('tempdb..#tempTableB') IS NOT NULL   
				DROP TABLE   #tempTableB
				SELECT * INTO #tempTableB FROM 
					(SELECT pid, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname
				, a.emailId AS email
				, a.mobileNo AS mob
				, a.RiyaPNR 
				, a.airName
				, BR.AgencyName
				, BR.Icast
				, tbi.airlinePNR, 
					--AVINASH ADDED
				CASE 
				WHEN a.MainAgentId > 0 THEN mu.UserName ELSE br1.Icast END BookedBy
				, a.deptTime AS deptdate
				, a.arrivalTime AS arrivaldate
				, a.OrderId
				--, (a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)) AS totalfare
				, ((SELECT ISNULL(SUM(totalfare + ISNULL(MCOAmount, 0) + ISNULL(BFC, 0) + ISNULL(TotalHupAmount, 0)), 0) FROM tblBookMaster(NOLOCK) WHERE riyaPNR = a.RiyaPNR) ) AS totalfare
				, ISNULL(a.ROE, 1) ROE
				, ISNULL(a.AgentROE, 1) AgentROE
				, ISNULL(a.B2BMarkup, 0) B2BMarkup
				,ISNULL(a.AgentMarkup, 0) Markup
				, a.inserteddate AS booking_date
				, a.GDSPNR
				, order_status 
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
						WHEN 0 THEN 'Failed' 
						WHEN 11 THEN 'Cancelled'
						WHEN 14 THEN 'Open ticket' 
						WHEN 15 THEN 'On Hold canceled'
					ELSE 'Failed' END AS [Ticketstatus]
				, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket]
				, c.tracking_id
				, A.Country
				, c.currency 
				, ISNULL(AL.Logo, '') AS LOGO 
				, a.BookingSource
				, (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
						FROM tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'frmsector'
				, (SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
						FROM  tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'tosector' 
				, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector FROM  tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t 
						WHERE t.fkBookMaster = a.pkId  
						GROUP BY t.orderId) AS 'Sector'
				, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))
							FROM tblBookItenary s 
							WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector 
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
											, fkBookMaster
											, ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN 
									FROM tblPassengerBookDetails) AS tblPBD 
								WHERE rn = 1) AS T1
									JOIN tblBookMaster a ON a.pkId = t1.fkBookMaster   
									LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster 
									AND a.frmSector = tbi.frmSector   
									LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id 
									INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID 
									INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID 
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
			DROP table   #tempTableB55
			SELECT * INTO #tempTableB55 FROM
					(SELECT  pid
				, ISNULL(paxfname, '')+ ' ' + paxlname AS paxname 
				, a.emailId AS email
				, a.mobileNo AS mob
           		, a.RiyaPNR 
				, a.airName
				, BR.AgencyName 
				, BR.Icast 
				, tbi.airlinePNR
				, a.deptTime AS deptdate 
				, a.arrivalTime AS arrivaldate
				, a.OrderId
				, (
					a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)
				) AS totalfar 
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
				, (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId GROUP BY t.orderId) AS 'frmsector' 
				, (SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'tosector'
				, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Sector'
				, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Dep Date all'
				, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax FROM tblPassengerBookDetails t WHERE t.fkBookMaster = a.pkId  GROUP BY t.fkBookMaster) AS 'AllPax' 
							FROM (SELECT * from (SELECT pid, paxFName, paxLName, fkBookMaster, ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails  where CheckboxVoid = 1) AS tblPBD where rn = 1 ) AS T1 
							JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster   
							LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster 
							and a.frmSector = tbi.frmSector   
							LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id 
							INNER JOIN AgentLogin AL on AL.UserID = a.AgentID 
							INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID   
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
						, BR.AgencyName 
						, BR.Icast
						, tbi.airlinePNR
						, a.deptTime AS deptdate
						, a.arrivalTime AS arrivaldate 
						, a.OrderId 
						, (
						a.totalfare + ISNULL(a.MCOAmount, 0) + ISNULL(A.ServiceFee, 0) + ISNULL(A.GST, 0) + ISNULL(a.BFC, 0)+ ISNULL(a.TotalHupAmount, 0)
						) AS totalfare 
						, ISNULL(a.ROE, 1) ROE 
						, ISNULL(a.AgentROE, 1) AgentROE 
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
								WHEN 0 THEN 'Failed' 
								WHEN 11 THEN 'Cancelled'
								WHEN 15 THEN 'On Hold canceled'
								WHEN 14 THEN 'Open ticket' 
						ELSE 'Failed' END AS [Ticketstatus]
						, CASE WHEN a.BookingStatus = 1 THEN 'Bookticket' END AS [Bookticket] 
						, c.tracking_id 
						, a.Country 
						, c.currency
						, ISNULL(AL.Logo, '') AS LOGO
						, ISNULL(a.B2BMarkup, 0) B2BMarkup
						, ISNULL(a.AgentMarkup, 0) Markup 
						, a.BookingSource 
       					, (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'frmsector'
						, (SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'tosector'
						, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Sector'
						, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary t WHERE t.fkBookMaster = a.pkId  GROUP BY t.orderId) AS 'Dep Date all'
						, (SELECT STUFF((SELECT '/' + s.paxFName + ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')), 1, 1, '') AS AllPax FROM tblPassengerBookDetails t WHERE t.fkBookMaster = a.pkId  GROUP BY t.fkBookMaster) AS 'AllPax' 
								from (SELECT * from (SELECT pid, paxFName, paxLName, fkBookMaster, ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails) AS tblPBD where rn = 1) AS T1 
					JOIN tblBookMaster  a ON a.pkId = t1.fkBookMaster   
					LEFT JOIN tblBookItenary tbi ON a.pkId = tbi.fkBookMaster 
					and a.frmSector = tbi.frmSector   
					LEFT JOIN Paymentmaster c ON a.OrderId = c.order_id 
					INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID 
					INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID    
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
