-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_getAllcodesForList]
	
AS
BEGIN
	
	select ci.CityCode ,ctr.CountryCode from [dbo].[Hotel_City_Master] ci
	inner join Hotel_CountryMaster ctr
	on ci.CountryID=ctr.ID
	where ctr.CountryCode=138

END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_getAllcodesForList] TO [rt_read]
    AS [dbo];

