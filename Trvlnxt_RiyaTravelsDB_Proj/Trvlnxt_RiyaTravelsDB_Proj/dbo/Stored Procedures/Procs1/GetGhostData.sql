
CREATE PROC [dbo].[GetGhostData] --'22172','2'
	@UserId VARCHAR(25) = NULL
	,@MainAgentId VARCHAR(25)   = NULL
	,@GDSPNR varchar(10)=''
	,@BookingId varchar(10)=''
	,@CustId varchar(20)='',
	@FROMDate Date= null,
	@ToDate Date= null
AS
BEGIN
	        --DECLARE @UserId varchar(500) = '1'

	DECLARE @Error_msg VARCHAR(500) = NULL
	DECLARE @parent VARCHAR(800) = NULL

	IF (@MainAgentId != 0)
	
	BEGIN
	
		SELECT  distinct(t.pkId) AS pid
		, BR.AgencyName  
			,BR.Icast  
			--, ISNULL(inserteddate_old,t.inserteddate) as  inserteddateshow
			,Format(cast(ISNULL(inserteddate_old,t.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') as  inserteddateshow
			,t.inserteddate
			,CASE WHEN BookingStatus = 0 THEN 'NA'
			WHEN BookingStatus = 1 THEN 'Ticket Issued'
			WHEN BookingStatus = 2 THEN 'Hold'
			WHEN BookingStatus = 3 THEN 'Ticket Pending'
			WHEN BookingStatus = 4 THEN 'Cancel'
			WHEN BookingStatus = 5 THEN 'Cancel'
			ELSE 'NA' END as BookingStatus
			,BookingStatus as BookingStatusID
			,t.[airName] AS airname
			,t.riyaPNR AS RiyaPNR --BookingID
			,OrderId
			,GDSPNR AS GDSPNR			
			,t.emailId AS email
			,t.mobileNo AS mob
			,t.depDate AS deptdate
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			,     t.AgentID			
			,case when MainAgentId <>0 then M.UserName
			else Br.AgencyName end as BookedBy
		--	,isnull(M.UserName,BR.AgencyName) AS BookedBy 
			,MainAgentId
			,t.BookedBy 
			,pm.payment_mode			
			, t.BookingStatus
			,t.OfficeID
			,t.VendorName
			,IsGhost
			,case t.BookingSource when 'Desktop' then 'Web'
			else t.BookingSource end as BookingSource
			,(SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector 
			FROM tblBookItenary s 
			WHERE s.orderId = bi.orderId							
			FOR XML PATH('')), 1, 1, '') AS Sector FROM tblBookItenary bi
			WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId) AS 'TravelSector'
			,(				SELECT STUFF((
							SELECT s.airlinePNR
							FROM tblBookItenary s
							WHERE s.orderId = bi.orderId
							FOR XML PATH('')
							), 1, 1, '') AS Sector
				FROM
				tblBookItenary bi
				WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
				) AS 'airlinePNR',isnull(m.UserName,b.UserName) as 	UserName
				
		FROM   [dbo].[tblBookMaster] t
		LEFT JOIN dbo.Paymentmaster pm ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B ON  t.AgentID = B.UserID
		INNER JOIN B2BRegistration BR ON B.UserID = BR.FKUserID
		LEFT JOIN mUser M ON M.id = t.BookedBy
				WHERE  t.AgentID IN (SELECT UserID
				FROM AgentLogin  where BookingCountry IN (
						SELECT CountryCode
						FROM mUserCountryMapping CM  inner
						JOIN mCountry C ON CM.CountryId = C.ID
						WHERE UserId = @MainAgentId
						)
				)
			
			AND T.totalFare > 0 AND T.AgentID !='B2C'
			and IsGhost = 1
			and returnFlag = 0 
			AND (t.GDSPNR=@GDSPNR or @GDSPNR='') 
			AND (t.riyaPNR=@BookingId or @BookingId='')
			AND (BR.Icast=@CustId or @CustId='') 
			AND (CONVERT(date,t.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  	AND (CONVERT(date,t.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)
		ORDER BY t.inserteddate DESC
	END
	ELSE
	IF (@UserId != 0)
	BEGIN
	
		SELECT  distinct(t.pkId) AS pid			,

 BR.AgencyName  ,BR.Icast  
			--, ISNULL(inserteddate_old,t.inserteddate) as  inserteddateshow
			,Format(cast(ISNULL(inserteddate_old,t.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') as  inserteddateshow
			,t.inserteddate
				,CASE WHEN BookingStatus = 0 THEN 'NA'
			WHEN BookingStatus = 1 THEN 'Ticket Issued'
			WHEN BookingStatus = 2 THEN 'Hold'
			WHEN BookingStatus = 3 THEN 'Ticket Pending'
			WHEN BookingStatus = 4 THEN 'Cancel'
			WHEN BookingStatus = 5 THEN 'Cancel'
			ELSE 'NA' END as BookingStatus
			,BookingStatus as BookingStatusID
			,t.[airName] AS airname


			,t.riyaPNR AS RiyaPNR --BookingID


			,OrderId
			,GDSPNR AS GDSPNR
		
	
			,t.emailId AS email
			,t.mobileNo AS mob
			,t.depDate AS deptdate
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			,     t.AgentID
			
			,case when MainAgentId <>0 then M.UserName
			else Br.AgencyName end as BookedBy
		--	,isnull(M.UserName,BR.AgencyName) AS BookedBy 

			,MainAgentId
			,t.BookedBy 
			,pm.payment_mode
			
			, t.BookingStatus
			,t.OfficeID
			,t.VendorName
			,IsGhost
			,case t.BookingSource when 'Desktop' then 'Web'
			else t.BookingSource end as BookingSource
			,(
				SELECT STUFF((
							SELECT
 '/' + s.frmSector + '-' + toSector
							FROM tblBookItenary s
							WHERE s.orderId = bi.orderId
							FOR XML PATH('')
							), 1, 1, '') AS Sector
				FROM tblBookItenary bi
				
WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
				) AS 'TravelSector'
			,(
				SELECT STUFF((
							SELECT s.airlinePNR
							FROM tblBookItenary s
							WHERE s.orderId = bi.orderId
							FOR XML PATH('')
							), 1, 1, '') AS Sector
				FROM

 tblBookItenary bi				
WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
				) AS 'airlinePNR'	,isnull(m.UserName,b.UserName) as 	UserName



		FROM   [dbo].[tblBookMaster] t
		LEFT JOIN dbo.
Paymentmaster pm ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B ON  t.AgentID = B.UserID
		left JOIN B2BRegistration BR ON B.UserID = BR.FKUserID
		LEFT JOIN mUser M ON M.id = t.MainAgentId
		WHERE t.AgentID = @UserId
			
			AND T.totalFare > 0 and t

.AgentID !='B2C'
			AND IsGhost = 1
			AND returnFlag = 0 
			AND (t.GDSPNR=@GDSPNR or @GDSPNR='') 
			AND (t.riyaPNR=@BookingId or @BookingId='')
			AND (BR.Icast=@CustId or @CustId='')
			AND (CONVERT(date,t.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  	AND (CONVERT(date,t.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)  
		ORDER BY t.inserteddate DESC
	END
	
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetGhostData] TO [rt_read]
    AS [dbo];

