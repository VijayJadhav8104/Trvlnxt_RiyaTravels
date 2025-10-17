
CREATE PROC [dbo].[UdspGetHoldTickets] -- [UdspGetHoldTickets] '6'
	@UserId VARCHAR(25) = NULL
	,@MainAgentId VARCHAR(25)   = NULL
	,@BookingStatus INT
AS
BEGIN
	        --DECLARE @UserId varchar(500) = '1'

	DECLARE @Error_msg VARCHAR(500) = NULL
	DECLARE @parent VARCHAR(800) = NULL

	IF (@MainAgentId != 0)
	
	BEGIN
	
		SELECT  distinct(t.pkId) AS pid
			,t.riyaPNR AS RiyaPNR
			,OrderId
			,GDSPNR AS GDSPNR
			,t.[airName] AS airname
			,t.emailId AS email
			,t.mobileNo AS mob
			,t.depDate AS deptdate
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			,     t.AgentID
			, BR.AgencyName  
			,BR.Icast  
			,case when MainAgentId <>0 then M.UserName
			else Br.AgencyName end as BookedBy
		--	,isnull(M.UserName,BR.AgencyName) AS BookedBy 
			,MainAgentId
			,t.BookedBy 
			,pm.payment_mode
			, ISNULL(inserteddate_old,t.inserteddate) as  inserteddateshow
			,t.inserteddate
			, t.BookingStatus
			,t.OfficeID
			,t.VendorName
			,case t.BookingSource when 'Desktop' then 'Web'
			else t.BookingSource end as BookingSource
			,(
				SELECT STUFF((
							SELECT '/' + s.frmSector + '-' + toSector
							FROM tblBookItenary s
							WHERE s.orderId = bi.orderId
							FOR XML PATH('')
							), 1, 1, '') AS Sector
				FROM tblBookItenary bi
				WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
				) AS 'TravelSector'
		FROM   [dbo].[tblBookMaster] t
		LEFT JOIN dbo.Paymentmaster pm ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B ON  t.AgentID = B.UserID
		INNER JOIN B2BRegistration BR ON B.UserID = BR.FKUserID
		LEFT JOIN mUser M ON M.id = t.BookedBy

		WHERE  t.AgentID IN (
				SELECT UserID
				FROM AgentLogin  where BookingCountry IN (
						SELECT CountryCode
						FROM mUserCountryMapping CM  inner
						JOIN mCountry C ON CM.CountryId = C.ID
						WHERE UserId = @MainAgentId
						)
				)
			AND t.BookingStatus = @BookingStatus
			AND T.totalFare > 0 AND T.AgentID !='B2C'
		ORDER BY t.inserteddate DESC
	END
	ELSE
	IF (@UserId != 0)
	BEGIN
	
		SELECT  distinct(t.pkId) AS pid
			,t.riyaPNR AS RiyaPNR
			,OrderId
			,GDSPNR AS GDSPNR
			,t.[airName] AS airname
			,t.emailId AS email
			,t.mobileNo AS mob
			,t.depDate AS deptdate
			, t.Country
			, t.OfficeID
			, t.AgentID
			, t.IsBooked
			,     t.AgentID
			, br.AgencyName  
			,BR.Icast  
		,case when MainAgentId <>0 then M.UserName
			else Br.AgencyName end as BookedBy
		--	,isnull(M.UserName,BR.AgencyName) AS BookedBy
		,MainAgentId  
			,pm.payment_mode  
			, ISNULL(inserteddate_old,t.inserteddate) as  inserteddateshow
			,t.inserteddate
			, t.BookingStatus
			,t.OfficeID
			,t.VendorName
			,case t.BookingSource when 'Desktop' then 'Web'
			else t.BookingSource end as BookingSource
			,(
				SELECT STUFF((
							SELECT '/' + s.frmSector + '-' + toSector
							FROM tblBookItenary s
							WHERE s.orderId = bi.orderId
							FOR XML PATH('')
							), 1, 1, '') AS Sector
				FROM tblBookItenary bi
				WHERE bi.fkBookMaster = t.pkId  GROUP BY bi.orderId
				) AS 'TravelSector'
		FROM   [dbo].[tblBookMaster] t
		LEFT JOIN dbo.Paymentmaster pm ON pm.order_id = t.orderId
		LEFT JOIN AgentLogin B ON  t.AgentID = B.UserID
		left JOIN B2BRegistration BR ON B.UserID = BR.FKUserID
		LEFT JOIN mUser M ON M.id = t.MainAgentId
		WHERE t.AgentID = @UserId
			AND t.BookingStatus = @BookingStatus
			AND T.totalFare > 0 and t.AgentID !='B2C'
		ORDER BY t.inserteddate DESC
	END
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetHoldTickets] TO [rt_read]
    AS [dbo];

