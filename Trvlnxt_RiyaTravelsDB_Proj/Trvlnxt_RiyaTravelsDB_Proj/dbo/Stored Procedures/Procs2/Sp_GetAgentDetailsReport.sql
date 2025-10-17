
-- =============================================
-- Author:		Bhavika kawa
-- Description:	Agent Details Report
-- [Sp_GetAgentDetailsReport] '2023-07-01','2023-07-14','IN,US,CA,AE,UK','','2,1,4,3,5','1','',0,100,1,100
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetAgentDetailsReport]
	 @Country varchar(10)=null
	, @AgentType varchar(40)=null
	, @Status varchar(10)=null
	, @Start int=null
	, @Pagesize int=null
	, @IsPaging bit
	, @RecordCount INT OUTPUT
AS
BEGIN
	SET @RecordCount=0
	IF(@IsPaging=1)
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
			DROP table  #tempTableA
		
		SELECT * INTO #tempTableA FROM (
			SELECT 
			-- b.InsertedDate AS 'Join Date Time',
	CASE 
        WHEN country.CountryCode = 'AE' THEN DATEADD(SECOND, -1*60*60 -29*60 -13, b.InsertedDate)
        WHEN country.CountryCode = 'US' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'CA' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'IN' THEN b.InsertedDate
    END as AdjustedDate,
FORMAT(
    CASE 
        WHEN country.CountryCode = 'AE' THEN DATEADD(SECOND, -1*60*60 -29*60 -13, b.InsertedDate)
        WHEN country.CountryCode = 'US' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'CA' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'IN' THEN b.InsertedDate
    END,
    'dd-MMM-yyyy'
) AS [JoinDateTime]

			,al.UserName
			,CONCAT(al.FirstName, ' ', al.LastName) AS 'Full Name'
			, al.MobileNumber AS 'Mobile No'
			,b.AddrLandlineNo As 'Contact NO'
			,b.AddrEmail as 'EmailID'
			, COALESCE(al.Address, '') + ' , ' + COALESCE(al.Pincode, '') + ' , ' + 
			 COALESCE(al.City, '') + ' , ' + COALESCE(al.Province, '') + ' , ' + COALESCE(al.Country, '') AS 'Permanent Address'
			, al.City AS 'City Name'
			, al.AgentBalance AS 'Customer Balance'
			, b.AgencyName AS 'Agency Name'
			, b.Icast AS 'Cust ID'
			, b.BranchCode AS 'Branch Name'
			,b.LocationCode
			,b.SalesPersonName
			,b.AccountPersonName,
			(SELECT STRING_AGG(mc.value, ',')
     FROM b2bregistration b2b
     OUTER APPLY sample_Split(b2b.PaymentMode, ',') ss
     LEFT JOIN mCommon mc ON mc.id = CAST(ss.data AS INT)
     WHERE mc.id IS NOT NULL and mc.Category = 'PaymentMode' AND b2b.FKUserID = b.FKUserID  -- Ensure we match the current row
     GROUP BY b2b.PaymentMode) AS Payment
			,b.LoginFromCountry
			,ag.GroupName
			,b.EntityName
			,b.EntityType
			,al.GhostTrack
			,al.AgentApproved
			,al.AutoTicketing
			,al.BookingCountry
			,b.BillingEntity
			,b.BillingID
			,b.CustomerType
			,b.AirlineCreditday AS 'Credit Days'
			,FORMAT(al.InsertedDate, 'dd-MMM-yyyy') AS InsertedDate
			,FORMAT(al.LastLoginDate, 'dd-MMM-yyyy') AS LastLoginDate
			,mu.UserName as CreatedBy
			,mu1.UserName as ModifiedBy
			,al.ModifiedOn
			, c.Value AS 'Agent Type'
			, (CASE b.Status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Approved' WHEN 2 THEN 'Rejected' WHEN 3 THEN 'Blocked' END) AS 'Status'		
			, b.PANNo AS 'Pan Number'
			, al.HomeNo AS 'Phone No'
			FROM B2BRegistration b WITH(NOLOCK)
			INNER JOIN AgentLogin al WITH(NOLOCK) ON al.UserID=b.FKUserID
			INNER JOIN magentgroup ag WITH(NOLOCK) ON ag.id=al.GroupId
			INNER JOIN mCommon c WITH(NOLOCK) ON c.ID=al.UserTypeID
			INNER JOIN mCountry country WITH(NOLOCK) ON b.Country=country.CountryName
			left join muser mu on mu.id = al.CreatedBy
			left join muser mu1 on mu1.id=al.ModifiedBy
			WHERE 
			--AND ((@Country = '') OR (al.BookingCountry = @Country))
 			((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
			-- AND ((@AgentType='') OR ( al.UserTypeID = @AgentType))
			AND ((@AgentType='') OR ( al.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentType, ','))))		 
			AND ((@Status = '') OR ( b.Status = @Status))
			
		) p
		order by p.[AdjustedDate] desc


		SELECT @RecordCount = @@ROWCOUNT
SELECT 
    [JoinDateTime],UserName,[Full Name],[Mobile No],
    [Contact NO],EmailID,[Permanent Address],[City Name],
    [Customer Balance],[Agency Name],[Cust ID],
    [Branch Name],LocationCode,SalesPersonName,AccountPersonName,
    Payment,LoginFromCountry,GroupName,EntityName,
    EntityType,GhostTrack,AgentApproved,AutoTicketing,
    BookingCountry,BillingEntity,BillingID,CustomerType,
    [Credit Days],InsertedDate,LastLoginDate,CreatedBy,
    ModifiedBy,ModifiedOn,[Agent Type],[Status],
    [Pan Number],[Phone No] FROM #tempTableA
		ORDER BY  [AdjustedDate] desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE if(@IsPaging=0)
	BEGIN
		SELECT --b.InsertedDate AS 'Join Date Time',
FORMAT(
    CASE 
        WHEN country.CountryCode = 'AE' THEN DATEADD(SECOND, -1*60*60 -29*60 -13, b.InsertedDate)
        WHEN country.CountryCode = 'US' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'CA' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, b.InsertedDate)
        WHEN country.CountryCode = 'IN' THEN b.InsertedDate
    END,
    'dd-MMM-yyyy'
) AS [JoinDateTime]
			,al.UserName
			,CONCAT(al.FirstName, ' ', al.LastName) AS 'Full Name'
			, al.MobileNumber AS 'Mobile No'
			,b.AddrLandlineNo As 'Contact NO'
			,b.AddrEmail as 'EmailID'
			, COALESCE(al.Address, '') + ' , ' + COALESCE(al.Pincode, '') + ' , ' + 
			 COALESCE(al.City, '') + ' , ' + COALESCE(al.Province, '') + ' , ' + COALESCE(al.Country, '') AS 'Permanent Address'
			, al.City AS 'City Name'
			, al.AgentBalance AS 'Customer Balance'
			, b.AgencyName AS 'Agency Name'
			, b.Icast AS 'Cust ID'
			, b.BranchCode AS 'Branch Name'
			,b.LocationCode
			,b.SalesPersonName
			,b.AccountPersonName
			,(SELECT STRING_AGG(mc.value, ',')
     FROM b2bregistration b2b
     OUTER APPLY sample_Split(b2b.PaymentMode, ',') ss
     LEFT JOIN mCommon mc ON mc.id = CAST(ss.data AS INT)
     WHERE mc.id IS NOT NULL and mc.Category = 'PaymentMode' AND b2b.FKUserID = b.FKUserID  -- Ensure we match the current row
     GROUP BY b2b.PaymentMode) AS Payment
			,b.LoginFromCountry
			,ag.GroupName
			,b.EntityName
			,b.EntityType
			,al.GhostTrack
			,al.AgentApproved
			,al.AutoTicketing
			,al.BookingCountry
			,b.BillingEntity
			,b.BillingID		
			,b.CustomerType
			,b.AirlineCreditday AS 'Credit Days'
			,FORMAT(al.InsertedDate, 'dd-MMM-yyyy') AS InsertedDate
			,FORMAT(al.LastLoginDate, 'dd-MMM-yyyy') AS LastLoginDate
			,mu.UserName as CreatedBy
			,mu1.UserName as ModifiedBy
			,al.ModifiedOn
			, c.Value AS 'Agent Type'
			, (CASE b.Status WHEN 0 THEN 'Pending' WHEN 1 THEN 'Approved' WHEN 2 THEN 'Rejected' WHEN 3 THEN 'Blocked' END) AS 'Status'
			--, '' AS 'Terminal Count'
			--, '' AS 'Service Tax'
			--, '' AS 'Payment Gateway Charge'
			--, '' AS 'TDS Percentage'		
			, b.PANNo AS 'Pan Number'
			, al.HomeNo AS 'Phone No'
		FROM B2BRegistration b WITH(NOLOCK)
		INNER JOIN AgentLogin al WITH(NOLOCK) ON al.UserID=b.FKUserID
		INNER JOIN magentgroup ag WITH(NOLOCK) ON ag.id=al.GroupId
		INNER JOIN mCommon c WITH(NOLOCK) ON c.ID=al.UserTypeID
		INNER JOIN mCountry country WITH(NOLOCK) ON b.Country=country.CountryName
		left join muser mu on mu.id = al.CreatedBy
		left join muser mu1 on mu1.id=al.ModifiedBy
		WHERE 
		--AND ((@Country = '') OR(al.BookingCountry = @Country))
		((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
		-- AND ((@AgentType='') OR ( al.UserTypeID = @AgentType))
		AND ((@AgentType='') OR ( al.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentType, ','))))
		AND ((@Status = '') OR ( b.Status = @Status))
	


	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentDetailsReport] TO [rt_read]
    AS [dbo];

