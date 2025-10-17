CREATE PROCEDURE [dbo].[Searchprocessdata] -- [Searchprocessdata]'15-May-2024','15-May-2024',NULL,NULL,NULL,NULL,NULL,'All',NULL,NULL,NULL,0,500,3,1,NULL,NULL
	-- Add the parameters for the stored procedure here
	@FROMDate Date= NULL
	, @ToDate Date= NULL
	, @paxname varchar(100)=''
	, @RiyaPNR varchar(20)=''
	, @AirlinePNR varchar(20)=''
	, @EmailID varchar(30)=''
	, @MobileNo varchar(20)=''
	, @Status varchar(30)=NULL
	, @Status2 varchar(30)=NULL
	, @GDSPNR varchar(30)=''
	, @OrderID varchar(30)=''
	, @Start int=NULL
	, @Pagesize int=NULL
	, @RecordCount INT OUTPUT
	, @Userid int
	, @OfficeID VARCHAR(50)=NULL
	, @AgentName varchar(200)=NULL
	, @UserType varchar(50)=NULL
	, @Country varchar(20)=NULL
AS
BEGIN
	IF(@Status = 'All' )
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
			DROP table #tempTableA
		
		SELECT * INTO #tempTableA FROM( 
			SELECT 
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE
					(SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON b.ID=al.UserTypeID
					WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'') + ' ' + b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare +  ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
					Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, order_status
			, c.payment_mode
			, c.getway_name
			, CASE WHEN ((b.Iscancelled = 1 OR B.isProcessRefund=1) AND a.IsBooked = 1) THEN 'Cancelled'
					WHEN (b.Iscancelled = 0 AND b.IsRefunded =0 AND a.IsBooked = 1) THEN 'Confirmed' 	
					WHEN (b.IsRefunded = 1 ) THEN 'Refunded'
					WHEN (a.IsBooked = 0 OR a.IsBooked IS NULL) THEN 'Failed' 						
					END AS [Ticketstatus]
			, c.tracking_id
			, A.Country
			, A.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE
					(ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID),
					(SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID) IN
					(SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' 
					when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub'
					END) AS AgencyType
			FROM tblBookMaster a WITH(NOLOCK)
			INNER JOIN tblPassengerBookDetails b WITH(NOLOCK) ON a.pkId=b.fkBookMaster
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
			AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
			AND ( b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname IS NULL OR @paxname='')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='' )
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL OR @OfficeID='')
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			--AND a.isbooked=1 
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END  
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--	INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--	(@UserType='All' AND A.AGENTID='B2C'))
			AND (a.Country=@Country OR @Country IS NULL)
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON 
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC
		
		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA

		SELECT * FROM #tempTableA
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE IF (UPPER(@Status) = UPPER('Cancelled') )
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
			DROP table #tempTableC
		
		SELECT * INTO #tempTableC FROM (
			SELECT
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK)
					ON b.ID=al.UserTypeID WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'')+' '+b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare + ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
				Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, b.Iscancelled AS order_status
			, c.payment_mode
			, c.getway_name
			, CASE WHEN ((b.Iscancelled = 1 OR B.isProcessRefund=1) AND a.IsBooked = 1) THEN 'Cancelled' 
					WHEN (b.Iscancelled = 0 AND b.IsRefunded =0) THEN 'Confirmed' WHEN (b.IsRefunded = 1) THEN 'Refunded' 				
					END AS [Ticketstatus]
			, tracking_id
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID)
			, (SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID) IN
					(SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) 
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' 
					when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL
					THEN 'Sub' END) AS AgencyType
			FROM tblPassengerBookDetails b WITH(NOLOCK)
			INNER JOIN tblBookMaster a WITH(NOLOCK) ON b.fkBookMaster = a.pkId
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
   			LEFT Join Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
					AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
			AND (b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname = '')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND a.isbooked=1 AND b.Iscancelled = 1
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')	
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL)
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' 
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END 
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C'))  
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON 
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC

		SELECT @RecordCount =@@ROWCOUNT
		
		SELECT * FROM #tempTableC
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END

	ELSE IF(UPPER(@Status) = UPPER('Refunded'))
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableR') IS NOT NULL
			DROP table #tempTableR
		-- SELECT 'Refunded'
		SELECT * INTO #tempTableR FROM ( 
			SELECT DISTINCT
			(a.GDSPNR)
			, b.pid
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON b.ID=al.UserTypeID
					WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, ISNULL(b.paxfname,'')+' '+b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare + ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
					Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, b.Iscancelled
			, '' AS 'payment_mode'
			, '' AS 'getway_name'
			, CASE WHEN ((b.Iscancelled = 1 OR B.isProcessRefund=1) AND a.IsBooked = 1) THEN 'Cancelled' 
					WHEN (b.Iscancelled = 0 AND b.IsRefunded =0) THEN 'Confirmed'
					WHEN (b.IsRefunded = 1) THEN 'Refunded' END AS [Ticketstatus]
			, c.tracking_ID AS 'tracking_id'
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) 
					WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID),
					(SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID) IN
					(SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) 
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) 
					FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub' END) AS AgencyType
			FROM tblPassengerBookDetails b WITH(NOLOCK)
			INNER JOIN tblBookMaster a WITH(NOLOCK) ON b.fkBookMaster = a.pkId
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT Join Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,b.RefundedDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)
					AND (CONVERT(date,b.RefundedDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
			AND (b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname = '')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND  b.IsRefunded = 1 
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
				INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)	
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL)  
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%'
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C')) 
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON 
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC
		
		SELECT @RecordCount =@@ROWCOUNT

 		SELECT * FROM #tempTableR
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END

	ELSE IF (@Status = 'Failed' )
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableF') IS NOT NULL
			DROP table #tempTableF
		
		SELECT * INTO #tempTableF FROM (
			SELECT 
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON b.ID=al.UserTypeID
					WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'')+' '+b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare + ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
					Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, order_status
			, c.payment_mode
			, c.getway_name
			, 'Failed' AS [Ticketstatus]
			, c.tracking_id
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID), (SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID) IN (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK)
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' 
					when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub'
					END) AS AgencyType
			FROM tblBookMaster a WITH(NOLOCK)
			INNER JOIN tblPassengerBookDetails b WITH(NOLOCK) ON a.pkId=b.fkBookMaster
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
					AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
			AND ( b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname IS NULL OR @paxname='')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')		 
			AND (a.isbooked=0 OR a.IsBooked IS NULL OR a.IsBooked='')
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL )	
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' 
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END 
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C'))  
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC
	
		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		
		SELECT * FROM #tempTableF
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END

	ELSE IF (@Status = 'Hold' )
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableHold') IS NOT NULL
			DROP table #tempTableHold
		
		SELECT * INTO #tempTableHold FROM( 
			SELECT 
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON b.ID=al.UserTypeID
					WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'') + ' ' + b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId, b.totalfare
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, order_status
			, c.payment_mode
			, c.getway_name, 'Hold' AS [Ticketstatus]
			, c.tracking_id
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID), (SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID) IN (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK)
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK)
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' when (SELECT CAST(ParentAgentID AS VARCHAR(50))
					FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub' END) AS AgencyType
			FROM tblBookMaster a WITH(NOLOCK)
			INNER JOIN tblPassengerBookDetails b WITH(NOLOCK) ON a.pkId=b.fkBookMaster
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
					AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
			AND (b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname IS NULL OR @paxname='')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')		 
			--AND (a.isbooked=0 OR a.IsBooked IS NULL OR a.IsBooked='')
			AND c.order_status='Hold'
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL )	
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' 
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END 
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C'))  
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) 
				inner JOIN mCommon c WITH(NOLOCK) ON ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC

		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA

		SELECT * FROM #tempTableHold
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END

	ELSE IF (@Status = 'Pending' )
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTablePending') IS NOT NULL
			DROP table #tempTablePending
		
		SELECT * INTO #tempTablePending FROM( 
			SELECT
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON
					b.ID=al.UserTypeID WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'') + ' ' + b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare +  ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
					Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, order_status
			, c.payment_mode
			, c.getway_name
			, 'Booked' AS [Ticketstatus]
			, c.tracking_id
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE
				 (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID),
				(SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK) WHERE CONVERT(varchar(50),B.FKUserID) IN
				 (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' 
				 when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub'
				 END) AS AgencyType
			FROM tblBookMaster a WITH(NOLOCK)
			INNER JOIN tblPassengerBookDetails b WITH(NOLOCK) ON a.pkId=b.fkBookMaster
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
					AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
			AND ( b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname IS NULL OR @paxname='')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')		 
			--AND (a.isbooked=0 OR a.IsBooked IS NULL OR a.IsBooked='')
			-- AND c.order_status<> 'Hold' AND a.isbooked=0 
			AND a.isbooked=0 AND c.order_status ='Success'
			AND (c.payment_mode='Merchant' OR c.payment_mode='Check' OR c.payment_mode='PassThrough')
			--OR (c.order_status ='Success' AND c.PaymentMode='Merchant') OR (c.order_status ='Success' AND c.PaymentMode='PassThrough'))
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')
			AND (a.OfficeID=@OfficeID OR @OfficeID IS NULL)
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' 
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C'))  
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON 
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC
	
		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		
		SELECT * FROM #tempTablePending
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE 
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableA1') IS NOT NULL
			DROP table #tempTableA1 
		
		SELECT * INTO #tempTableA1 FROM(
			SELECT 
			CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (SELECT b.Value FROM mCommon B WITH(NOLOCK) JOIN AgentLogin al WITH(NOLOCK) ON 
					b.ID=al.UserTypeID WHERE al.UserID=a.AgentID) END AS 'AgentUserType'
			, b.pid
			, ISNULL(b.paxfname,'')+' '+b.paxlname AS paxname
			, a.emailId AS email
			, a.mobileNo AS mob
			, a.RiyaPNR
			, a.airName
			, tbi.airlinePNR
			, a.frmsector
			, a.tosector AS tosector
			, a.depDate AS deptdate
			, a.arrivaldate AS arrivaldate
			, a.OrderId
			--CHANGED BY BHAVIKA
			, b.totalfare +  ISNULL((SELECT SUM(SSR_Amount) FROM tblSSRDetails AS ssr WITH(NOLOCK)
					Where ssr.fkBookMaster IN (SELECT pkid From tblBookMaster WITH(NOLOCK) WHERE pkId = a.pkId)),0) AS 'totalfare'
			, a.inserteddate AS booking_date
			, a.GDSPNR
			, c.order_status
			, c.payment_mode
			, c.getway_name
			, CASE WHEN (b.Iscancelled = 1) THEN 'Cancelled' WHEN (b.Iscancelled = 0 AND b.IsRefunded = 0) THEN 'Ticketed'
					WHEN (b.IsRefunded = 1) THEN 'Refunded' END AS [Ticketstatus]
			, c.tracking_id
			, a.Country
			, a.OfficeID
			, CASE WHEN A.AgentID='B2C' THEN 'B2C' ELSE (ISNULL((SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID)=a.AgentID), (SELECT B.AgencyName FROM B2BRegistration B WITH(NOLOCK)
					WHERE CONVERT(varchar(50),B.FKUserID) IN (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK)
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID)))) END AS AgencyName
			, (case when a.AgentID='B2C' THEN '-' when (SELECT CAST(ParentAgentID AS VARCHAR(50)) FROM agentLogin WITH(NOLOCK)
					WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NULL THEN 'Main' when (SELECT CAST(ParentAgentID AS VARCHAR(50))
					FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))=a.AgentID) IS NOT NULL THEN 'Sub' END) AS AgencyType
			FROM tblBookMaster a WITH(NOLOCK)
			INNER JOIN tblPassengerBookDetails b WITH(NOLOCK) ON a.pkId=b.fkBookMaster
			LEFT JOIN B2BRegistration br WITH(NOLOCK) ON CONVERT(varchar(50),br.FKUserID)=a.AgentID
			LEFT JOIN Paymentmaster c WITH(NOLOCK) ON a.OrderId=c.order_id
			LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON a.pkId=tbi.fkBookMaster AND a.frmSector=tbi.frmSector
			WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
			AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
			AND ( b.paxfname+' '+b.paxlname like '%'+ @paxname +'%' OR @paxname IS NULL OR @paxname='')
			AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' OR @RiyaPNR IS NULL OR @RiyaPNR='')
			AND (tbi.airlinePNR = @AirlinePNR OR @AirlinePNR IS NULL OR @AirlinePNR='')
			AND (a.emailId like '%'+ @EmailID +'%' OR @EmailID IS NULL OR @EmailID='')
			AND (a.mobileNo like '%'+ @MobileNo +'%' OR @MobileNo IS NULL OR @MobileNo='')
			AND ( c.order_id =@OrderID OR @OrderID IS NULL OR @OrderID='')
			AND ( a.GDSPNR =@GDSPNR OR @GDSPNR IS NULL OR @GDSPNR='')	
			AND ( br.AgencyName =@AgentName OR @AgentName IS NULL OR @AgentName='')
			AND a.isbooked=1 AND B.Iscancelled = 0 AND B.IsRefunded=0
			AND a.Country IN (SELECT C.CountryCode FROM mUserCountryMapping UM WITH(NOLOCK)
					INNER JOIN mCountry C WITH(NOLOCK) ON C.ID=UM.CountryId WHERE UserID=@Userid AND IsActive=1)	
			AND (a.Country=@Country OR @Country IS NULL OR @Country='')
			AND A.AgentID LIKE CASE WHEN @UserType = 'B2C' THEN 'B2C%' 
			WHEN @UserType = 'B2B' THEN '[0-9]%' ELSE '%' END 
			--AND	(a.AgentID IN (SELECT CAST(AL.UserID AS VARCHAR(50)) FROM AgentLogin AL
			--INNER JOIN mUserTypeMapping UT ON UT.UserTypeId=AL.UserTypeID WHERE UT.UserID=@Userid AND UT.IsActive=1) OR
			--(@UserType='ALL' AND A.AGENTID='B2C'))  
		) p
		WHERE p.AgentUserType IN (SELECT c.Value FROM mUserTypeMapping ut WITH(NOLOCK) inner JOIN mCommon c WITH(NOLOCK) ON
				ut.UserTypeId=c.ID WHERE ut.UserId=@Userid AND UT.IsActive=1)
		ORDER BY P.booking_date DESC
		
		SELECT @RecordCount =@@ROWCOUNT

		SELECT * FROM #tempTableA1
		ORDER BY booking_date 
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Searchprocessdata] TO [rt_read]
    AS [dbo];

