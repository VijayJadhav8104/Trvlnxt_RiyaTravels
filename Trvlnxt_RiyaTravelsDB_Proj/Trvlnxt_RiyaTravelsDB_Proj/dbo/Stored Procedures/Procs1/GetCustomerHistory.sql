-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <09-02-2023>
-- Description:	<This Procedure is Used to get unique carrier from t>
-- =============================================   
--'Customer Creation', 'Customer Mapping', 'ALL'
--declare @RecordCount int
--EXEC [dbo].[GetCustomerHistory] '2022-01-01','2023-02-14',1,100,1,'ALL',@RecordCount
CREATE PROCEDURE [dbo].[GetCustomerHistory]
@FromDate Datetime,
@ToDate Datetime,
@Start Int,
@PageSize Int,
@IsPaging Int,
@PageType Varchar(50),
@RecordCount int OUTPUT
AS
BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableHistory') IS NOT NULL
		DROP table  #tempTableHistory
	SELECT * INTO #tempTableHistory
	FROM (
		SELECT 
		ROW_NUMBER() OVER(ORDER BY ALH.ModifiedOn desc) As [SrNo],
		ALH.ID,
		ALH.AL_PKID AS AgentLoginID,
		BR.CustomerCOde AS CustomerCode,
		BR.AgencyName AS  CustomerName,
		BR.CustomerCOde+' - '+BR.AgencyName AS [Agency Name],
		'' as [Create By],
		AL.InsertedDate as [Created Date],
		MUSR.UserName +' - '+ MUSR.FullName AS [Modify By],
		ALH.ModifiedOn AS [Modify Date],
		ALH.PageName,
		(CASE ALH.Action WHEN 1 THEN 'ADD' WHEN 2 THEN 'Update' WHEN 3 THEN 'Delete' END) AS Action
		--1-Add, 2-Update, 3-Delete
		FROM AgentLoginAllHistory ALH
		LEFT JOIN AgentLogin AS AL ON ALH.AL_PKID=AL.UserID
		LEFT JOIN B2BRegistration AS BR ON AL.UserID=BR.FKUserID
		--LEFT JOIN mUser CUSR ON BR.=CUSR.ID
		LEFT JOIN mUser MUSR ON ALH.ModifiedBy=MUSR.ID
		WHERE 
		((@FROMDate = NULL) or (CONVERT(date,ALH.ModifiedOn) >= CONVERT(date,@FROMDate)))    
 		AND ((@ToDate = NULL) or (CONVERT(date,ALH.ModifiedOn) <= CONVERT(date,@ToDate)))    
		AND (@PageType='All' OR ALH.PageName=@PageType)
	) History
	ORDER BY History.[Modify Date] DESC

	SELECT @RecordCount = @@ROWCOUNT

	IF(@IsPaging=1)
	BEGIN
		SELECT * FROM #tempTableHistory
		ORDER BY [Modify Date] DESC
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT * FROM #tempTableHistory
		ORDER BY [Modify Date] DESC
	END
END