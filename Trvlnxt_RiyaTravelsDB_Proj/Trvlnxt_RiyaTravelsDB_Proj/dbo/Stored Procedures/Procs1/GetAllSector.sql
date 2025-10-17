-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <13-02-2023>
-- Description:	<This Procedure is Used to get all sector data carrier wise>
-- =============================================   
--declare @RecordCount int
--EXEC [dbo].[GetAllSector] 0,1000,1,'SG',@RecordCount
CREATE PROCEDURE [dbo].[GetAllSector]
@Start Int,
@PageSize Int,
@IsPaging Int,
@Carrier Varchar(50),
@SearchText Varchar(100),
@RecordCount int OUTPUT
AS
BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableSector') IS NOT NULL
		DROP table  #tempTableSector
	SELECT * INTO #tempTableSector
	FROM (
		SELECT 
		TAS.Id,
		TAS.Carrier,
		TAS.fromSector AS [FromSector],
		TAS.toSector AS [ToSector]
		FROM tblAirlineSectors TAS
		WHERE TAS.Carrier=@Carrier AND TAS.IsActive=1
		AND (@SearchText='' OR (TAS.fromSector=@SearchText OR TAS.toSector=@SearchText))
	) History

	SELECT @RecordCount = @@ROWCOUNT

	IF(@IsPaging=1)
	BEGIN
		SELECT * FROM #tempTableSector
		ORDER BY Id desc
		OFFSET @Start ROWS    
		FETCH NEXT @Pagesize ROWS ONLY 
	END
	ELSE
	BEGIN
		SELECT * FROM #tempTableSector
	END
END