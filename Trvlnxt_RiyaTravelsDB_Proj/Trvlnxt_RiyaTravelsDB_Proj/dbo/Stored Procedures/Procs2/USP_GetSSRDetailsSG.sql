-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USP_GetSSRDetailsSG --'2021-10-06T01:50:00Z','2021-10-06T04:05:00Z'
@FromDate datetime,
@ToDate datetime
AS
BEGIN
	select * from tblSSRListwithAbbreviation 
	where
		--START DATE TIME LOGIC
		((cast(FromTime as time(0)) > cast(@FromDate as time(0))
		AND cast(ToTime as time(0)) < cast(@ToDate as time(0))
		AND Quarters = DATEPART(QUARTER, @FromDate))OR 
		(FromTime IS NULL AND ToTime IS NULL AND  (Quarters = DATEPART(QUARTER, @FromDate) OR Quarters='5')))
		--END DATE TIME LOGIC
		AND Carrier='SG'
		AND IsActive=1 

		select * from tblSSRListwithAbbreviation 
		where Carrier='SG' and Type='Baggage'
		AND IsActive=1 
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_GetSSRDetailsSG] TO [rt_read]
    AS [dbo];

