---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UdspGetHoldTickets2 '45187', '3', '2', '2023-05-19', '2023-05-19', 'C3R63U','', '1,2,3,4,5', '',NULL, '45187', 'IN,US,CA,AE,UK'
CREATE PROC [dbo].[UdspGetHoldTickets2_UAT] 
	@UserId VARCHAR(25) = NULL
	, @MainAgentId VARCHAR(25)   = NULL
	, @BookingStatus varchar(100)
	, @Frmdt Datetime=null
	, @Todt Datetime=null
	, @riyaPNR varchar(20)=''
	, @Country varchar(max)=''
	, @UserType varchar(20)=''
	, @AirportId varchar(20)=''
	, @Airline varchar(max)=''
	, @AgentId int=''
	, @LoginAgentCountries nvarchar(50)=null

AS
BEGIN

	Declare @TillDate DateTime
	-- IF MAIN AGENT ID = 0 AND AGENT ID > 0 
	IF(@MainAgentId = 0 AND @AgentID <= 0)
	BEGIN		
		Return;
	END

	SELECT @TillDate = TillDate FROM tblBlockTransaction WITH(NOLOCK) WHERE AgentId = @AgentID

	IF(@TillDate IS NOT NULL AND (@TillDate >= @Frmdt AND @TillDate >= @Todt))
	BEGIN
		Return;
	END
	
	IF(@TillDate IS NOT NULL AND (@TillDate >= @Frmdt))
	BEGIN
		SET @Frmdt = DATEADD(DAY, 1, @TillDate)
	END
	--END
	        --DECLARE @UserId varchar(500) = '1'

	DECLARE @Error_msg VARCHAR(500) = NULL
	DECLARE @parent VARCHAR(800) = NULL

	
	DECLARE @AirlinePNR VARCHAR(20) = NULL
	
    select top 1  @AirlinePNR= airlinePNR from tblBookItenary t left join tblBookMaster tbm on t.orderId=tbm.orderId 
	  where tbm.riyaPNR=@riyaPNR and airlinePNR !=''
	--Declare @Countrycode varchar(20)=null
	--if(@Country !='')
	--set @Countrycode=(SELECT CountryCode FROM mCountry WHERE id=@Country)
	--ELSE
	--set @Countrycode=''

	IF (@MainAgentId != 0)
	BEGIN
		SELECT  distinct(t.pkId) AS pid
			, t.riyaPNR AS RiyaPNR
			, t.OrderId
			, GDSPNR AS GDSPNR
			,CASE  WHEN airlinePNR IS NULL THEN @AirlinePNR   ELSE airlinePNR END AS airlinePNR
			, t.[airName] AS airname
			, t.emailId AS email
	
		, t.mobileNo AS mob
			, t.depDate AS deptdate
			, FORMAT(CAST(t.deptTime AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS deptdate1
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			, BR.AgencyName
			--,B.UserID AS AgencyID
			, BR.Icast  
			, (CASE WHEN MainAgentId <> 0
						THEN M.UserName
					ELSE Br.AgencyName 
				END) AS BookedBy
		    , ISNULL(M.UserName,BR.AgencyName) AS BookedBy 
			, MainAgentId
			, pm.payment_mode
			, FORMAT(CAST(ISNULL(inserteddate_old,t.inserteddate) AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us') AS  inserteddateshow
			, t.inserteddate
			, t.BookingStatus
			, t.OfficeID
			, 'Offline' AS Terminaltype
			,case when t.VendorName IN ('SQNDC','GFNDC','EKNDC','WYNDC','EYNDC','AmadeusNDC','Sabre','Verteil','TKNDC', 'VerteilNDC','Indigo','OneAPIAirArabia','Spicejet','ETNDC','FlyDubai') then 'APIOUT' else t.VendorName end as VendorName
			, t.VendorName
			, t.FareSellKey
			, (CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR END) AS CRSPNR
			, (CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END) AS BookingSource
			,(SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
								FROM tblBookItenary s WITH(NOLOCK)
								WHERE s.orderId = bi.orderId
								FOR XML PATH('')), 1, 1, '') AS Sector
						FROM tblBookItenary bi WITH(NOLOCK)
						WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId) AS 'TravelSector'
			, DATEDIFF(DAY, GETDATE(),t.depDate) AS LblDifferenceDAY
			, ISNULL(M.AutoTicketing,0) AutoTicketing
			, t.HoldText
			,ISNULL(t.APITrackID,'') AS APITrackID
			,ISNULL(t.TripType,'') as TripType   --added by satya
			,ISNULL(M1.UserName,'') as UserName
	    ,Format(cast(ISNULL(t.ClosedDate,'') as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') as  ClosedDate
		,t.HoldBookingDate
		,t.HoldDate
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) ON ac.AirlineCode=t.airCode
		LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.pkId
		LEFT JOIN mUser M WITH(NOLOCK) ON M.id = t.BookedBy
		LEFT JOIN mUser M1 ON M1.id = t.ClosedBy
		WHERE t.AgentID IN (SELECT UserID FROM AgentLogin WITH(NOLOCK) WHERE BookingCountry IN (SELECT CountryCode 
																								FROM mUserCountryMapping CM WITH(NOLOCK)
																								INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
																								WHERE 
UserId = @MainAgentId ))
    --AND (t.AgentID in (select UserID from agentLogin where UserID=@MainAgentId))
		AND t.BookingStatus IN (SELECT DATA FROM sample_split(@BookingStatus,',')) 
		AND T.totalFare > 0 
		AND T.AgentID !='B2C' AND t.returnFlag=0
		--avinash added
		AND ((@riyaPNR != '') OR (@Frmdt = '') OR (CONVERT(DATE, ISNULL(t.inserteddate_old,t.inserteddate)) >= @Frmdt))
 		AND ((@riyaPNR != '') OR (@ToDt = '') OR (CONVERT(DATE, ISNULL(t.inserteddate_old,t.inserteddate)) <= @ToDt))
		AND ((@UserType = '') OR ( b.UserTypeID IN  (SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (b.BookingCountry IN (SELECT Data FROM sample_split(@Country,','))))
	    AND ((@AirportId = '') OR ((@AirportId = '1') AND (t.CounterCloseTime = 1)) OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		AND ((@AgentId = '') OR (t.AgentID =CAST(@AgentId AS varchar(50))) OR (b.ParentAgentID=@AgentId))
		AND ((@Airline IS NULL) OR (@Airline = '') OR (t.airCode IN (SELECT Data FROM sample_split(@Airline,','))))		
		AND ((@riyaPNR = '') OR (t.riyaPNR = @riyaPNR) OR (t.GDSPNR = @riyaPNR) OR (tbi.airlinePNR = @riyaPNR))
		AND t.Country IN ( SELECT Data FROM sample_split(@LoginAgentCountries,','))
		--AND t.riyaPNR=@riyaPNR
		ORDER BY t.inserteddate DESC
	END
	ELSE
	IF (@UserId != 0)
	BEGIN
		SELECT DISTINCT(t.pkId) AS pid
				, t.riyaPNR AS RiyaPNR				
				, T.OrderId
		
		, GDSPNR AS GDSPNR
			,CASE  WHEN airlinePNR IS NULL THEN @AirlinePNR   ELSE airlinePNR END AS airlinePNR
				, t.[airName] AS airname
				, t.emailId AS email
				, t.mobileNo AS mob
				, t.depDate AS deptdate
				, t.Country
				, t.OfficeID
				,case when t.VendorName IN ('SQNDC','GFNDC','EKNDC','WYNDC','Sabre','EYNDC','AmadeusNDC','Verteil','TKNDC', 'VerteilNDC','Indigo','OneAPIAirArabia','Spicejet','ETNDC','FlyDubai') then 'APIOUT' else t.VendorName end as VendorName
				, t.AgentID
				, t.IsBooked
				, t.AgentID
				, br.AgencyName  
				, BR.Icast  
				, (CASE WHEN MainAgentId <> 0 THEN M.UserName ELSE Br.AgencyName END) AS BookedBy
				, ISNULL(M.UserName,BR.AgencyName) AS BookedBy
				, MainAgentId  
				, pm.payment_mode 
				--, '' AS payment_mode 
				--, ISNULL(inserteddate_old,t.inserteddate) AS  inserteddateshow
				, FORMAT(CAST(ISNULL(inserteddate_old, t.inserteddate) AS DateTime), 'dd/MM/yyyy HH:mm:ss tt','en-us') AS  inserteddateshow
				, t.inserteddate
				, t.BookingStatus
				, t.OfficeID
				, t.VendorName
		
		, t.FareSellKey
				, (CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END) AS BookingSource
				, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
									FROM tblBookItenary s
									WHERE s.orderId = bi.orderId
								
	FOR XML PATH('')
									), 1, 1, '') AS Sector
						FROM tblBookItenary bi
						WHERE bi.fkBookMaster = t.pkId  
						GROUP BY bi.orderId) AS 'TravelSector'
				, ISNULL(M.AutoTicketing,0) AutoTicketing
				, t.HoldText
				,ISNULL(t.APITrackID,'') AS APITrackID
				,ISNULL(t.TripType,'') as TripType    --added by satya
				 ,ISNULL(M1.UserName,'') as UserName
	    ,Format(cast(ISNULL(t.ClosedDate,'') as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') as  ClosedDate
		,t.HoldBookingDate
		,t.HoldDate
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		left JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		LEFT JOIN mUser M WITH(NOLOCK) ON M.id = t.MainAgentId
		LEFT JOIN mUser M1 ON M1.id = t.ClosedBy
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.pkId
		WHERE (t.AgentID = @UserId or t.AgentID in (select UserID from agentLogin where ParentAgentID=@UserId))
		AND t.BookingStatus IN (SELECT DATA FROM sample_split(@BookingStatus,',')) 
		AND T.totalFare > 0 
		AND t.AgentID !='B2C'
		--avinash added
		AND ((@riyaPNR != '') OR (@Frmdt = '') OR (CONVERT(DATE,ISNULL(t.inserteddate_old,t.inserteddate)) >= @Frmdt))
 		AND ((@riyaPNR != '') OR (@ToDt = '') OR (CONVERT(DATE,ISNULL(t.inserteddate_old,t.inserteddate)) <= @ToDt))
		AND ((@UserType = '') OR ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
	    AND ((@AirportId = '') OR ((@AirportId = '1') AND (t.CounterCloseTime = 1)) OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		AND ((@AgentId = '') OR  (t.AgentID =CAST(@AgentId AS varchar(50))) OR (b.ParentAgentID=@AgentId))
		AND ((@Airline is null) OR (@Airline = '') OR (t.airCode IN ( SELECT Data FROM sample_split(@Airline,','))))		
		AND ((@riyaPNR = '') OR (t.riyaPNR = @riyaPNR) OR (t.GDSPNR = @riyaPNR) OR (tbi.airlinePNR = @riyaPNR))
		AND t.Country IN ( SELECT Data FROM sample_split(@LoginAgentCountries,','))
		ORDER BY t.inserteddate DESC
	END
	
END


