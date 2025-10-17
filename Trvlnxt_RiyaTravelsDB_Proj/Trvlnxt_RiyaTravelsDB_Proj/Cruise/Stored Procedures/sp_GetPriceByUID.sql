-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[sp_GetPriceByUID]
	@Search_UID varchar(100),
	@ItineraryId varchar(100)
AS
BEGIN
	
	select * from Cruise.CacheRoomPrices where Search_UID = 'VIS_VIS_1992022_CORDELIA_EMPRESS' and ItineraryId = '4a46d3a3-caea-405a-a425-00b7b2e363ba'
	and DATEDIFF(hour, CreatedOn, GETDATE()) = 0

END
