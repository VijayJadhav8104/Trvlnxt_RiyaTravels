--exec UdspGetCancellationGrid '22249','3','6','2023-06-27','2023-06-29','49NW8S','','1,2,3,4,5',NULL,NULL,'','IN,US,CA,AE,UK'
CREATE PROC [dbo].[UdspGetCancellationGrid]
	@UserId VARCHAR(25) = NULL
	,@MainAgentId VARCHAR(25)   = NULL
	,@BookingStatus INT
    ,@Frmdt Datetime=null
	,@Todt Datetime=null
	,@riyaPNR varchar(20)=''
	,@Country varchar(max)=''
	,@UserType varchar(20)=''
	,@AirportId varchar(20)=''
	,@Airline varchar(max)=''
	,@AgentId int=''
	,@LoginAgentCountries nvarchar(50)=''
	,@AgencySearchID nvarchar(50)=''
AS
BEGIN
	        --DECLARE @UserId varchar(500) = '1'

	DECLARE @Error_msg VARCHAR(500) = NULL
	DECLARE @parent VARCHAR(800) = NULL

	IF (@MainAgentId != 0)	
	BEGIN
	    IF(@riyaPNR != '')
		BEGIN
		SELECT distinct(t.pkId) AS pid
			, t.riyaPNR AS RiyaPNR
			, t.OrderId
			, GDSPNR AS GDSPNR
			, t.[airName] AS airname
			, ISNULL(AddrMobileNo,AddrLandlineNo) AS mob
			, AddrEmail AS email
			, t.depDate AS deptdate
			, Format(cast(t.deptTime AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS deptdate1
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			, BR.AgencyName
			, BR.Icast  
			, (CASE WHEN MainAgentId <> 0 THEN M.UserName ELSE Br.AgencyName END) AS BookedBy
			, MainAgentId
			, t.BookedBy 
			, pm.payment_mode
			, ISNULL(inserteddate_old,t.inserteddate) AS  inserteddateshow
			, t.inserteddate
			, t.BookingStatus
			, t.OfficeID
			, 'Offline' AS Terminaltype
			, t.VendorName
			, (CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR END) AS CRSPNR
			, (CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END) AS BookingSource
			, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
								FROM tblBookItenary s WITH(NOLOCK)
								WHERE s.fkBookMaster = t.pkId
								FOR XML PATH('')
								), 1, 1, '') AS Sector) AS 'TravelSector'
			, DATEDIFF(DAY, GETDATE(),t.depDate) AS LblDifferenceDAY
			, (SELECT TOP 1 tbi.airlinePNR 
				FROM tblBookItenary tbi WITH(NOLOCK)
				WHERE t.pkId=tbi.fkBookMaster) AS AirlinePNR
			, (SELECT TOP 1 tb.RemarkCancellation 
				FROM tblPassengerBookDetails tb  WITH(NOLOCK)
				WHERE fkBookMaster IN (SELECT pkId 
										FROM tblBookMaster WITH(NOLOCK)
										WHERE riyapnr=t.riyaPNR)
				AND tb.BookingStatus=6) AS RemarkCancellation
			, ac.type AS AirlineType	
	
			, (SELECT TOP 1 pid FROM tblPassengerBookDetails tb WHERE t.pkid=tb.fkBookMaster AND tb.BookingStatus=6) PassPid
	  		, Format(cast(ISNULL(t.canceledDate,t.inserteddate) AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS TobecancellationDate
			, ac.type AS AirlineType	
			, (SELECT TOP 1 CASE WHEN CounterCloseTime=1 THEN 'Domestic' ELSE 'International' End Sector FROM tblBookMaster tb WITH(NOLOCK) WHERE t.pkid=tb.pkId) AS Sector
			, (SELECT TOP 1 CASE WHEN isReturnJourney=1 THEN 'Return' ELSE 'Oneway' End Bookingtype FROM tblBookMaster tb1 WITH(NOLOCK) WHERE t.pkid=tb1.pkId) AS Bookingtype
	   		, (SELECT TOP 1 ISNULL(m.UserName,br.AgencyName) UserName  
				FROM tblPassengerBookDetails tp WITH(NOLOCK)
				LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=tp.CancelByBackendUser
				LEFT JOIN B2BRegistration br WITH(NOLOCK) ON br.FKUserID=tp.CancelByAgency
				WHERE fkBookMaster IN (SELECT pkId 
										FROM tblBookMaster WITH(NOLOCK) 
										WHERE riyapnr=t.riyaPNR)
				AND tb.BookingStatus=6 
				ORDER BY tp.TobecancellationDate DESC) AS UserName
			, t.canceledDate
			, t.inserteddate
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) ON ac.AirlineCode=t.airCode
		LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.pkId
		LEFT JOIN mUser M ON M.id = t.BookedBy
		WHERE  t.AgentID IN (SELECT UserID 
								FROM AgentLogin WITH(NOLOCK)
								WHERE BookingCountry IN (SELECT CountryCode
															FROM mUserCountryMapping CM WITH(NOLOCK)
															INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
															WHERE UserId = @MainAgentId))
		AND t.BookingStatus = @BookingStatus
		AND T.totalFare > 0 
		AND T.AgentID !='B2C' 
		AND t.returnFlag=0  --AND t.deptTime>=GETDATE()
		--avinash added
		--AND ((@Frmdt = '') OR (CONVERT(DATE,ISNULL(t.canceledDate,t.inserteddate)) >= @Frmdt))
 		--AND ((@ToDt = '') OR (CONVERT(DATE,ISNULL(t.canceledDate,t.inserteddate)) <= @ToDt))
        AND ((@riyaPNR IS NOT NULL OR @riyaPNR != '') OR (@Frmdt = '' AND CONVERT(DATE,ISNULL(t.canceledDate, t.inserteddate)) >= @Frmdt)
 			AND @ToDt = '' OR (CONVERT(DATE,ISNULL(t.canceledDate, t.inserteddate)) <= @ToDt))
		AND ((@UserType = '') OR ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
		AND ((@AirportId IS NULL OR @AirportId = '')  
				OR ((@AirportId = '1') and (t.CounterCloseTime = 1)) 
				OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		AND ((@Airline IS NULL OR @Airline = '') 
				OR (t.airCode IN (SELECT Data FROM sample_split(@Airline,','))))
		AND ((@AgentId = '') 
				or (t.AgentID =cast(@AgentId AS varchar(50))) 
				OR (b.ParentAgentID=@AgentId))
		AND ((@riyaPNR IS NULL OR @riyaPNR = '') 
				OR (t.riyaPNR = @riyaPNR) 
				OR (t.GDSPNR = @riyaPNR) 
				OR (tbi.airlinePNR = @riyaPNR))
		ORDER BY t.inserteddate DESC
		END
		ELSE
		BEGIN
		SELECT distinct(t.pkId) AS pid
			, t.riyaPNR AS RiyaPNR
			, t.OrderId
			, GDSPNR AS GDSPNR
			, t.[airName] AS airname
			, ISNULL(AddrMobileNo,AddrLandlineNo) AS mob
			, AddrEmail AS email
			, t.depDate AS deptdate
			, Format(cast(t.deptTime AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS deptdate1
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			, BR.AgencyName
			, BR.Icast  
			, (CASE WHEN MainAgentId <> 0 THEN M.UserName ELSE Br.AgencyName END) AS BookedBy
			, MainAgentId
			, t.BookedBy 
			, pm.payment_mode
			, ISNULL(inserteddate_old,t.inserteddate) AS  inserteddateshow
			, t.inserteddate
			, t.BookingStatus
			, t.OfficeID
			, 'Offline' AS Terminaltype
			, t.VendorName
			, (CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR END) AS CRSPNR
			, (CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END) AS BookingSource
			, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
								FROM tblBookItenary s WITH(NOLOCK)
								WHERE s.fkBookMaster = t.pkId
								FOR XML PATH('')
								), 1, 1, '') AS Sector) AS 'TravelSector'
			, DATEDIFF(DAY, GETDATE(),t.depDate) AS LblDifferenceDAY
			, (SELECT TOP 1 tbi.airlinePNR 
				FROM tblBookItenary tbi WITH(NOLOCK)
				WHERE t.pkId=tbi.fkBookMaster) AS AirlinePNR
			, (SELECT TOP 1 tb.RemarkCancellation 
				FROM tblPassengerBookDetails tb  WITH(NOLOCK)
				WHERE fkBookMaster IN (SELECT pkId 
										FROM tblBookMaster WITH(NOLOCK)
										WHERE riyapnr=t.riyaPNR)
				AND tb.BookingStatus=6) AS RemarkCancellation
			, ac.type AS AirlineType	
	
			, (SELECT TOP 1 pid FROM tblPassengerBookDetails tb WHERE t.pkid=tb.fkBookMaster AND tb.BookingStatus=6) PassPid
	  		, Format(cast(ISNULL(t.canceledDate,t.inserteddate) AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS TobecancellationDate
			, ac.type AS AirlineType	
			, (SELECT TOP 1 CASE WHEN CounterCloseTime=1 THEN 'Domestic' ELSE 'International' End Sector FROM tblBookMaster tb WITH(NOLOCK) WHERE t.pkid=tb.pkId) AS Sector
			, (SELECT TOP 1 CASE WHEN isReturnJourney=1 THEN 'Return' ELSE 'Oneway' End Bookingtype FROM tblBookMaster tb1 WITH(NOLOCK) WHERE t.pkid=tb1.pkId) AS Bookingtype
	   		, (SELECT TOP 1 ISNULL(m.UserName,br.AgencyName) UserName  
				FROM tblPassengerBookDetails tp WITH(NOLOCK)
				LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
				LEFT JOIN mUser m WITH(NOLOCK) ON m.id=tp.CancelByBackendUser
				LEFT JOIN B2BRegistration br WITH(NOLOCK) ON br.FKUserID=tp.CancelByAgency
				WHERE fkBookMaster IN (SELECT pkId 
										FROM tblBookMaster WITH(NOLOCK) 
										WHERE riyapnr=t.riyaPNR)
				AND tb.BookingStatus=6 
				ORDER BY tp.TobecancellationDate DESC) AS UserName
			, t.canceledDate
			, t.inserteddate
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) ON ac.AirlineCode=t.airCode
		LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.pkId
		LEFT JOIN mUser M ON M.id = t.BookedBy
		WHERE  t.AgentID IN (SELECT UserID 
								FROM AgentLogin WITH(NOLOCK)
								WHERE BookingCountry IN (SELECT CountryCode
															FROM mUserCountryMapping CM WITH(NOLOCK)
															INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
															WHERE UserId = @MainAgentId))
		AND t.BookingStatus = @BookingStatus
		AND T.totalFare > 0 
		AND T.AgentID !='B2C' 
		AND t.returnFlag=0  --AND t.deptTime>=GETDATE()
		--avinash added
		AND ((@Frmdt = '') OR (CONVERT(DATE,ISNULL(t.canceledDate,t.inserteddate)) >= @Frmdt))
 		AND ((@ToDt = '') OR (CONVERT(DATE,ISNULL(t.canceledDate,t.inserteddate)) <= @ToDt))
        AND ((@riyaPNR IS NOT NULL OR @riyaPNR != '') OR (@Frmdt = '' AND CONVERT(DATE,ISNULL(t.canceledDate, t.inserteddate)) >= @Frmdt)
 			AND @ToDt = '' OR (CONVERT(DATE,ISNULL(t.canceledDate, t.inserteddate)) <= @ToDt))
		AND ((@UserType = '') OR ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
		AND ((@AirportId IS NULL OR @AirportId = '')  
				OR ((@AirportId = '1') and (t.CounterCloseTime = 1)) 
				OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		AND ((@Airline IS NULL OR @Airline = '') 
				OR (t.airCode IN (SELECT Data FROM sample_split(@Airline,','))))
		AND ((@AgentId = '') 
				or (t.AgentID =cast(@AgentId AS varchar(50))) 
				OR (b.ParentAgentID=@AgentId))
		AND ((@riyaPNR IS NULL OR @riyaPNR = '') 
				OR (t.riyaPNR = @riyaPNR) 
				OR (t.GDSPNR = @riyaPNR) 
				OR (tbi.airlinePNR = @riyaPNR))
		ORDER BY t.inserteddate DESC
		END
	END
	ELSE
	IF (@UserId != 0)
	BEGIN
		SELECT DISTINCT(t.pkId) AS pid
				, t.riyaPNR AS RiyaPNR
				, t.OrderId
				, GDSPNR AS GDSPNR
				, t.[airName] AS airname
				--,t.emailId AS email
				--,t.mobileNo AS mob
				, ISNULL(AddrMobileNo,AddrLandlineNo) AS mob
				, AddrEmail AS email
				, t.depDate AS deptdate
				, DATEDIFF(DAY, GETDATE(),t.depDate) AS LblDifferenceDAY
				, FORMAT(CAST(t.deptTime AS datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS deptdate1
				, t.Country
				, t.OfficeID
				, t.AgentID
				, t.IsBooked
				, t.AgentID
				, br.AgencyName  
				, BR.Icast  
				, CASE 
						WHEN MainAgentId <> 0 
							THEN M.UserName
						ELSE Br.AgencyName 
					END AS BookedBy
				, MainAgentId  
				, pm.payment_mode  
				, ISNULL(inserteddate_old,t.inserteddate) AS  inserteddateshow
				, t.inserteddate
				, t.BookingStatus
				, t.OfficeID
				, t.VendorName
				, 'Offline' AS Terminaltype
				, CASE t.BookingSource 
						WHEN 'Desktop' 
							THEN 'Web'
						ELSE t.BookingSource 
					END AS BookingSource
				, (SELECT STUFF((SELECT '/' + s.frmSector + '-' + toSector
									FROM tblBookItenary s WITH(NOLOCK)
									WHERE s.fkBookMaster = t.pkId
									FOR XML PATH('')), 1, 1, '') AS Sector) AS 'TravelSector'
				, (SELECT TOP 1 pid FROM tblPassengerBookDetails tb WITH(NOLOCK) WHERE t.pkid=tb.fkBookMaster and tb.BookingStatus=6) PassPid
	  			, Format(cast(ISNULL(t.canceledDate,t.inserteddate) AS datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  AS TobecancellationDate
				, (SELECT TOP 1  tbi.airlinePNR FROM tblBookItenary tbi WITH(NOLOCK) WHERE t.pkId=tbi.fkBookMaster) AS AirlinePNR
	  			, CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR End CRSPNR
				, ac.type AS AirlineType	
				, (SELECT TOP 1 CASE WHEN CounterCloseTime=1 THEN 'Domestic' ELSE 'International' End Sector FROM tblBookMaster tb WITH(NOLOCK) WHERE t.pkid=tb.pkId) Sector
				, (SELECT TOP 1 CASE WHEN isReturnJourney=1 THEN 'Return' ELSE 'Oneway' End Bookingtype FROM tblBookMaster tb1 WITH(NOLOCK) WHERE t.pkid=tb1.pkId) Bookingtype
				, (SELECT TOP 1 tb.RemarkCancellation 
						FROM tblPassengerBookDetails tb WITH(NOLOCK)
						WHERE fkBookMaster IN (SELECT pkId FROM tblBookMaster WITH(NOLOCK) WHERE riyapnr=t.riyaPNR) 
						and tb.BookingStatus=6) AS RemarkCancellation
	   			, (SELECT TOP 1 ISNULL(m.UserName,br.AgencyName) UserName  
						FROM tblPassengerBookDetails tp WITH(NOLOCK)
						LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=tp.fkBookMaster
						LEFT JOIN mUser m WITH(NOLOCK) ON m.id=tp.CancelByBackendUser
						LEFT JOIN B2BRegistration br WITH(NOLOCK) ON br.FKUserID=tp.CancelByAgency
						WHERE fkBookMaster IN (SELECT pkId FROM tblBookMaster WITH(NOLOCK) WHERE riyapnr=t.riyaPNR) and tb.BookingStatus=6 ORDER BY tp.TobecancellationDate DESC) UserName
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) ON ac.AirlineCode=t.airCode
		LEFT JOIN mUser M WITH(NOLOCK) ON M.id = t.MainAgentId
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.pkId
		WHERE t.AgentID = @UserId
		AND t.BookingStatus = @BookingStatus
		AND T.totalFare > 0 and t.AgentID !='B2C' --and t.deptTime>=getdate()
		--avinash added
		AND (@riyaPNR IS NOT nULL OR @riyaPNR != '' OR (@Frmdt = '' or (CONVERT(date,ISNULL(t.canceledDate,t.inserteddate)) >= @Frmdt))
 		AND (@ToDt = '' or (CONVERT(date,ISNULL(t.canceledDate,t.inserteddate)) <= @ToDt)))
		AND ((@UserType = '') or ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') or (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
		AND ((@AirportId = '')  
		or ((@AirportId = '1') and (t.CounterCloseTime = 1)) 
		or ((@AirportId = '2') and (t.CounterCloseTime != 1)))
		AND ((@Airline = '') or (t.airCode IN ( SELECT Data FROM sample_split(@Airline,','))))
		AND ((@AgentId = '') or  (t.AgentID =cast(@AgentId AS varchar(50))) or (b.ParentAgentID=@AgentId))
		AND ((@riyaPNR = '') or (t.riyaPNR = @riyaPNR) or (t.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @riyaPNR))
		ORDER BY t.inserteddate DESC
		--SELECT  distinct(t.pkId) AS pid
		--	,t.riyaPNR AS RiyaPNR
		--	,t.OrderId
		--	,GDSPNR AS GDSPNR
		--	,t.[airName] AS airname
		--	--,t.emailId AS email
		--	--,t.mobileNo AS mob
		--	 ,isnull(AddrMobileNo,AddrLandlineNo) as mob
  --            ,AddrEmail as email
		--	,t.depDate AS deptdate
		--	,DATEDIFF(Day, getdate(),t.depDate) AS LblDifferenceDAY
		--		,Format(cast(t.deptTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as deptdate1
		--	, t.Country
		--	, t.OfficeID
		--	, t.AgentID
		--	, t.IsBooked
		--	,     t.AgentID
		--	, br.AgencyName  
		--	,BR.Icast  
		--,case when MainAgentId <>0 then M.UserName
		--	else Br.AgencyName end as BookedBy
		----	,isnull(M.UserName,BR.AgencyName) AS BookedBy
		--,MainAgentId  
		--	,pm.payment_mode  
		--	, ISNULL(inserteddate_old,t.inserteddate) as  inserteddateshow
		--	,t.inserteddate
		--	, t.BookingStatus
		--	,t.OfficeID
		--	,t.VendorName
		--	,'Offline' as Terminaltype
		--	,case t.BookingSource when 'Desktop' then 'Web'
		--	else t.BookingSource end as BookingSource
		--	,(
		--		SELECT STUFF((
		--					SELECT '/' + s.frmSector + '-' + toSector
		--					FROM tblBookItenary s
		--					WHERE s.orderId = bi.orderId
		--					FOR XML PATH('')
		--					), 1, 1, '') AS Sector
		--		FROM tblBookItenary bi
		--		WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
		--		) AS 'TravelSector'

		--,(select TOP 1 pid from tblPassengerBookDetails tb where t.pkid=tb.fkBookMaster and tb.BookingStatus=6) PassPid
	 -- --,(select TOP 1 Format(cast(tb.TobecancellationDate as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') from tblPassengerBookDetails tb 
	 -- --where fkBookMaster in (select pkId from tblBookMaster where riyapnr=t.riyaPNR) and tb.BookingStatus=6) TobecancellationDate
	 -- 	   	,Format(cast(isnull(t.canceledDate,t.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as TobecancellationDate
	 -- ,(select TOP 1  tbi.airlinePNR from tblBookItenary tbi where t.pkId=tbi.fkBookMaster) AS AirlinePNR
	 -- 	, case when ac.type='LCC' then 'NA' else t.GDSPNR End CRSPNR
		--,ac.type as AirlineType	
		--,(select TOP 1 case when CounterCloseTime=1 then 'Domestic' else 'International' End Sector from tblBookMaster tb where t.pkid=tb.pkId) Sector
		--,(select TOP 1 case when isReturnJourney=1 then 'Return' else 'Oneway' End Bookingtype from tblBookMaster tb1 where t.pkid=tb1.pkId) Bookingtype
		-- ,(select TOP 1 tb.RemarkCancellation from tblPassengerBookDetails tb 
	 --      where fkBookMaster in (select pkId from tblBookMaster where riyapnr=t.riyaPNR) and tb.BookingStatus=6 ) RemarkCancellation
	 --  	,(select TOP 1 isnull(m.UserName,br.AgencyName) UserName  from tblPassengerBookDetails tp
		--left join tblBookMaster tb on tb.pkid=tp.fkBookMaster
		--left join mUser m on m.id=tp.CancelByBackendUser
		--left join B2BRegistration br on br.FKUserID=tp.CancelByAgency
		-- where fkBookMaster in (select pkId from tblBookMaster where riyapnr=t.riyaPNR) and tb.BookingStatus=6 ORDER BY tp.TobecancellationDate DESC) UserName

		--FROM   [dbo].[tblBookMaster] t
		--LEFT JOIN dbo.Paymentmaster pm ON pm.order_id = t.orderId
		--LEFT JOIN AgentLogin B ON  t.AgentID = B.UserID
		--left JOIN B2BRegistration BR ON B.UserID = BR.FKUserID
		--left join [AirlineCode_Console] ac on ac.AirlineCode=t.airCode
		--LEFT JOIN mUser M ON M.id = t.MainAgentId
		--inner join tblBookItenary tbi on tbi.fkBookMaster=t.pkId
		--WHERE t.AgentID = @UserId
		--	AND t.BookingStatus = @BookingStatus
		--	AND T.totalFare > 0 and t.AgentID !='B2C' --and t.deptTime>=getdate()

		--		 --avinash added
		--	AND ((@Frmdt = '') or (CONVERT(date,isnull(t.canceledDate,t.inserteddate)) >= @Frmdt))
 	--	   AND ((@ToDt = '') or (CONVERT(date,isnull(t.canceledDate,t.inserteddate)) <= @ToDt))
		--	AND ((@UserType = '') or ( b.UserTypeID IN  ( select Data from sample_split(@UserType,','))))
		--	AND ((@Country = '') or (b.BookingCountry IN ( select Data from sample_split(@Country,','))))
	 --      AND ((@AirportId = '')  
		--	or ((@AirportId = '1') and (t.CounterCloseTime = 1)) 
		--	or ((@AirportId = '2') and (t.CounterCloseTime != 1)))
		--	 AND ((@Airline = '') or (t.airCode IN ( select Data from sample_split(@Airline,','))))
		--  AND ((@AgentId = '') or  (t.AgentID =cast(@AgentId as varchar(50))) or (b.ParentAgentID=@AgentId))
		--  AND ((@riyaPNR = '') or (t.riyaPNR = @riyaPNR) or (t.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @riyaPNR))
		--ORDER BY t.inserteddate DESC
	END
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetCancellationGrid] TO [rt_read]
    AS [dbo];

