-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 24/July/2020
-- Description:	To get the PNR Created Report
-- [DBO].[sp_GETCrypticCommandPNRCreationReport] '','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_GETCrypticCommandPNRCreationReport]
	@FromDate Date='' 
	, @ToDate Date=''
	, @GDSType varchar(20) =''
	, @Country varchar(10)=''
	, @UsertypeId varchar(10)=''
	, @AgentId int=0
	, @GDSPnr varchar(50)=''
AS
BEGIN
	SELECT
	CreatedOn AS [Date/Time]
	--BCretatedBY.CustomerCOde AS [CUST ID],
	, (CASE WHEN BCretatedBY.CustomerCOde IS NULL THEN (SELECT CustomerCOde from B2BRegistration WITH(NOLOCK) 
			WHERE al.ParentAgentID=FKUserID) ELSE BCretatedBY.CustomerCOde END) AS [CUST ID]
	, PNRNumber AS [GDS PNR]
	, CRS AS [GDS Type]
	, CASE WHEN pnr.GDSPNR IS NOT NULL THEN 'Ticketed' ELSE 'Non-Ticketed'END AS [Status]
	, pnr.RiyaPNR AS 'Booking Id'
	--BCretatedBY.AgencyName AS CreatedBy,
	, (CASE WHEN BCretatedBY.AgencyName IS NULL THEN (SELECT AgencyName from B2BRegistration WITH(NOLOCK) 
			WHERE al.ParentAgentID=FKUserID) ELSE BCretatedBY.AgencyName END) AS CreatedBy
	, BIssuedBy.AgencyName AS 'Issued By'
	FROM (SELECT PNRNumber, CreatedBy, MIN(CreatedOn) AS CreatedOn
			, CRS from CrypticCommand WITH(NOLOCK) WHERE ISNULL(PNRNumber,'') <> '' 
			group by PNRNumber,CRS,CreatedBy 
	) CrypticCommand
	inner join agentLogin al WITH(NOLOCK) ON al.UserID=CrypticCommand.Createdby
	left join PNRRetriveDetails pnr WITH(NOLOCK) ON pnr.GDSPNR = CrypticCommand.PNRNumber and TicketIssue=1
	left join B2BRegistration BCretatedBY WITH(NOLOCK) ON BCretatedBY.FKUserID=al.UserID 
	left join B2BRegistration BIssuedBy WITH(NOLOCK) ON BIssuedBy.FKUserID= pnr.LoginId
	WHERE (( @GDSType='') OR (CRS = @GDSType))
	AND ((@FROMDate = '') OR (CONVERT(date,CreatedOn) >= CONVERT(date,@FROMDate)))
 	AND ((@ToDate = '') OR (CONVERT(date,CreatedOn) <= CONVERT(date, @ToDate)))
	--AND ((@Country = '') OR (al.BookingCountry = @Country))
	--AND ((@UsertypeId = '') OR (al.UserTypeID = @UsertypeId))
	AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))
	AND ((@UsertypeId = '') OR (al.UserTypeID IN (SELECT Data FROM sample_split(@UsertypeId, ','))))
	AND ((@AgentId = '') OR (al.UserId = @AgentId))
	AND ((@GDSPnr='') OR (PNRNumber=@GDSPnr))
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GETCrypticCommandPNRCreationReport] TO [rt_read]
    AS [dbo];

