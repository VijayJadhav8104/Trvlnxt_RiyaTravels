--exec UdspGetRescheduleGrid '0',2,8,'2022-09-19','2022-09-19'

CREATE PROC [dbo].[UdspGetRescheduleGrid]
	@UserId VARCHAR(25) = NULL
	,@MainAgentId VARCHAR(25)   = NULL
	,@BookingStatus INT
		,@Frmdt Datetime=null
	,@Todt Datetime=null
	,@UserType varchar(20)=''
	,@riyaPNR varchar(20)=''
	,@Country varchar(max)=''
	,@AgentId int=''
	,@AirportId varchar(20)=''
	,@Airline varchar(max)=''
	,@LoginAgentCountries nvarchar(50)=null
AS
BEGIN
	        --DECLARE @UserId varchar(500) = '1'

	DECLARE @Error_msg VARCHAR(500) = NULL
	DECLARE @parent VARCHAR(800) = NULL

	IF (@MainAgentId != 0)
	BEGIN
		SELECT distinct(t.pkId) AS pid
			, 1
			, BR.AgencyName
			, t.riyaPNR AS RiyaPNR
			, BR.Icast  
			, (SELECT TOP 1 tbi.airlinePNR FROM tblBookItenary tbi WITH(NOLOCK) WHERE t.pkId=tbi.fkBookMaster) AS AirlinePNR
			, CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR END CRSPNR
			, 'Offline' AS RequestType
			, t.frmSector AS Origin
			, t.toSector AS Destination
			, t.[airName] AS airname
			, ac.type AS AirlineType	
			, (SELECT TOP 1 tb.ContactNo 
				FROM RescheduleData tb WITH(NOLOCK)
				WHERE riyaPNR = t.riyaPNR 
				AND tb.Status=7) AS ContactNumber
			, (SELECT TOP 1 tb.Remarks 
				FROM RescheduleData tb WITH(NOLOCK)
				WHERE riyaPNR=t.riyaPNR 
				AND tb.Status=7
				ORDER BY ID DESC) AS RemarkReschedule
			, (SELECT TOP 1 FORMAT(CAST(tb.CreatedDate AS DateTime), 'dd/MM/yyyy HH:mm:ss tt','en-us') 
				FROM RescheduleData tb WITH(NOLOCK)
				WHERE riyaPNR=t.riyaPNR 
				AND tb.Status=7 
				ORDER BY ID DESC) AS RescheduleDate
			--,(SELECT TOP 1 tb.ContactNo FROM RescheduleData tb 
			--   WHERE riyaPNR in (SELECT riyaPNR FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7 ) ContactNumber
			--			 ,(SELECT TOP 1 tb.Remarks FROM RescheduleData tb 
			--   WHERE riyaPNR in (SELECT riyaPNR FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7  ORDER BY ID DESC) RemarkReschedule
			-- ,(SELECT TOP 1 FORMAT(CAST(tb.CreatedDate AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us') FROM RescheduleData tb 
			--   WHERE riyaPNR in (SELECT riyaPNR FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7 ) RescheduleDate
			, t.OrderId
			, ac.type AS AirlineType	
			, CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END AS BookingSource
			, 'Offline' AS Terminaltype
			, (SELECT TOP 1 (CASE WHEN isReturnJourney=1 THEN 'Return' ELSE 'Oneway' END) AS Bookingtype 
				FROM tblBookMaster tb1 WITH(NOLOCK)
				WHERE t.pkid=tb1.pkId) Bookingtype
			, '1000' PassPid
			, t.BookingStatus
			, t.OfficeID
			, t.VendorName
			, (SELECT STUFF((SELECT '/' + s.Origin + '-' + Destination
								FROM RescheduleData s WITH(NOLOCK)
								WHERE s.orderId = bi.orderId
								FOR XML PATH('')), 1, 1, '') AS Sector
				FROM RescheduleData bi WITH(NOLOCK)
				WHERE bi.Pkid = t.pkId
				GROUP BY bi.orderId) AS 'TravelSector'
			, (SELECT TOP 1 (CASE WHEN CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS Sector
				FROM tblBookMaster tb WITH(NOLOCK)
				WHERE t.pkid=tb.pkId) AS Sector
			, t.airCode
			, (SELECT TOP 1 ISNULL(m.UserName, br.AgencyName) AS UserName
				FROM RescheduleData r WITH(NOLOCK)
				LEFT JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkid=r.Pkid
				LEFT JOIN mUser m WITH(NOLOCK) on m.id=r.RescheduleBackEnduser
				LEFT JOIN B2BRegistration br WITH(NOLOCK) on br.FKUserID=r.ReschedulebyAgency
				WHERE tb.BookingStatus=7
				ORDER BY r.CreatedDate DESC) UserName
		FROM [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK) ON  t.AgentID = B.UserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) on ac.AirlineCode=t.airCode
		INNER JOIN B2BRegistration BR WITH(NOLOCK) ON B.UserID = BR.FKUserID
		INNER JOIN tblBookItenary tbi WITH(NOLOCK) on tbi.fkBookMaster=t.pkId
		LEFT JOIN mUser M WITH(NOLOCK) ON M.id = t.BookedBy
		LEFT JOIN RescheduleData rs WITH(NOLOCK) on t.pkid=rs.Pkid
		inner join tbl_AmendmentRequest amr on amr.BookMasterId=t.pkId
		WHERE  t.AgentID IN (SELECT UserID 
								FROM AgentLogin WITH(NOLOCK)
								WHERE BookingCountry IN (SELECT CountryCode
															FROM mUserCountryMapping CM  WITH(NOLOCK)
															INNER JOIN mCountry C WITH(NOLOCK) ON CM.CountryId = C.ID
															WHERE UserId = @MainAgentId))
		AND t.BookingStatus = @BookingStatus
		AND T.totalFare > 0 AND T.AgentID !='B2C' AND t.returnFlag=0
		AND ((@Frmdt = '') OR (CONVERT(date,isnull(amr.Inserteddate,t.inserteddate)) >= @Frmdt))
 		AND ((@ToDt = '') OR (CONVERT(date,isnull(amr.Inserteddate,t.inserteddate)) <= @ToDt))
		AND ((@UserType = '') OR ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
	    AND ((@AirportId = '') OR ((@AirportId = '1') and (t.CounterCloseTime = 1)) OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		AND ((@Airline = '') OR (t.airCode IN ( SELECT Data FROM sample_split(@Airline,','))))
		AND ((@AgentId = '') OR  (t.AgentID =CAST(@AgentId AS varchar(50))) OR (b.ParentAgentID=@AgentId))
		AND ((@riyaPNR = '') OR (t.riyaPNR = @riyaPNR) OR (t.GDSPNR = @riyaPNR) OR (tbi.airlinePNR = @riyaPNR))
		AND t.Country IN ( SELECT Data FROM sample_split(@LoginAgentCountries,','))
		ORDER BY t.pkId DESC
	END
	ELSE
	IF (@UserId != 0)
	BEGIN
		SELECT DISTINCT(t.pkId) AS pid
				, 2
				, BR.AgencyName
				, t.riyaPNR AS RiyaPNR
				, BR.Icast  
				, (SELECT TOP 1  tbi.airlinePNR FROM tblBookItenary tbi WITH(NOLOCK) WHERE t.pkId=tbi.fkBookMaster) AS AirlinePNR
				, CASE WHEN ac.type='LCC' THEN 'NA' ELSE t.GDSPNR END CRSPNR
				, 'Offline' AS RequestType
				, t.frmSector AS Origin
				, t.toSector AS Destination
		   		, t.[airName] AS airname
				, ac.type AS AirlineType	
				, (SELECT TOP 1 tb.ContactNo 
					FROM RescheduleData tb WITH(NOLOCK)
					WHERE riyaPNR =t.riyaPNR 
					AND tb.Status=7 ) AS ContactNumber
		   		, (SELECT TOP 1 tb.Remarks 
					FROM RescheduleData tb WITH(NOLOCK)
					WHERE riyaPNR=t.riyaPNR 
					AND tb.Status=7
					ORDER BY ID DESC) AS RemarkReschedule
				, (SELECT TOP 1 FORMAT(CAST(tb.CreatedDate AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us')
					FROM RescheduleData tb  WITH(NOLOCK)
					WHERE riyaPNR=t.riyaPNR 
					AND tb.Status=7) AS RescheduleDate
				--,(SELECT TOP 1 tb.ContactNo FROM RescheduleData tb 
				--   WHERE pkId in (SELECT pkId FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7 ) ContactNumber
				--,(SELECT TOP 1 tb.Remarks FROM RescheduleData tb 
				--   WHERE pkId in (SELECT pkId FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7 ) RemarkReschedule
				--  ,(SELECT TOP 1 FORMAT(CAST(tb.CreatedDate AS DateTime),'dd/MM/yyyy HH:mm:ss tt','en-us') FROM RescheduleData tb 
				--   WHERE pkId in (SELECT pkId FROM tblBookMaster WHERE riyapnr=t.riyaPNR) AND tb.Status=7 ) RescheduleDate
				, t.OrderId
				, ac.type AS AirlineType	
				, (CASE t.BookingSource WHEN 'Desktop' THEN 'Web' ELSE t.BookingSource END) AS BookingSource
				, 'Offline' AS Terminaltype
				, (SELECT TOP 1 (CASE WHEN isReturnJourney=1 THEN 'Return' ELSE 'Oneway' END) AS Bookingtype 
					FROM tblBookMaster tb1 WITH(NOLOCK) 
					WHERE t.pkid=tb1.pkId) AS Bookingtype
			    , '1000' PassPid
				, t.BookingStatus
				, t.OfficeID
				, t.VendorName
				, (SELECT STUFF((SELECT '/' + s.Origin + '-' + Destination
				 					FROM RescheduleData s WITH(NOLOCK)
				 					WHERE s.orderId = bi.orderId
				 					FOR XML PATH('')), 1, 1, '') AS Sector
				 	FROM RescheduleData bi WITH(NOLOCK)
				 	WHERE bi.Pkid = t.pkId  
				 	GROUP BY bi.orderId) AS 'TravelSector'
				, (SELECT TOP 1 (CASE WHEN CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS Sector 
					FROM tblBookMaster tb WITH(NOLOCK)
					WHERE t.pkid=tb.pkId) AS Sector
				, t.airCode
				, (SELECT TOP 1 ISNULL(m.UserName,br.AgencyName) UserName 
					FROM RescheduleData r WITH(NOLOCK)
					LEFT JOIN tblBookMaster tb WITH(NOLOCK) on tb.pkid=r.Pkid
					LEFT JOIN mUser m WITH(NOLOCK) on m.id=r.RescheduleBackEnduser
					LEFT JOIN B2BRegistration br WITH(NOLOCK) on br.FKUserID=r.ReschedulebyAgency
					WHERE tb.BookingStatus=7
					ORDER BY r.CreatedDate DESC) AS UserName
		FROM   [dbo].[tblBookMaster] t WITH(NOLOCK)
		LEFT JOIN dbo.Paymentmaster pm WITH(NOLOCK) ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B WITH(NOLOCK)ON  t.AgentID = B.UserID
		LEFT JOIN B2BRegistration BR WITH(NOLOCK)ON B.UserID = BR.FKUserID
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) on ac.AirlineCode=t.airCode
		LEFT JOIN mUser M WITH(NOLOCK) ON M.id = t.MainAgentId
		LEFT JOIN RescheduleData rs WITH(NOLOCK) on t.pkid=rs.Pkid
		INNER JOIN tblBookItenary tbi WITH(NOLOCK)on tbi.fkBookMaster=t.pkId
		inner join tbl_AmendmentRequest amr on amr.BookMasterId=t.pkId
		WHERE t.AgentID = @UserId
			AND t.BookingStatus = @BookingStatus
			AND T.totalFare > 0 AND t.AgentID !='B2C'

		AND ((@Frmdt = '') OR (CONVERT(date,isnull(amr.Inserteddate,t.inserteddate)) >= @Frmdt))
 		   AND ((@ToDt = '') OR (CONVERT(date,isnull(amr.Inserteddate,t.inserteddate)) <= @ToDt))
			AND ((@UserType = '') OR ( b.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
			AND ((@Country = '') OR (b.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
	       AND ((@AirportId = '')  
			OR ((@AirportId = '1') and (t.CounterCloseTime = 1)) 
			OR ((@AirportId = '2') AND (t.CounterCloseTime != 1)))
		 AND ((@Airline = '') OR (t.airCode IN ( SELECT Data FROM sample_split(@Airline,','))))
		 AND ((@AgentId = '') OR  (t.AgentID =CAST(@AgentId AS varchar(50))) OR (b.ParentAgentID=@AgentId))
		  AND ((@riyaPNR = '') OR (t.riyaPNR = @riyaPNR) OR (t.GDSPNR = @riyaPNR) OR (tbi.airlinePNR = @riyaPNR))
		  	AND t.Country IN ( SELECT Data FROM sample_split(@LoginAgentCountries,','))
		ORDER BY t.pkId DESC
	END
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetRescheduleGrid] TO [rt_read]
    AS [dbo];

