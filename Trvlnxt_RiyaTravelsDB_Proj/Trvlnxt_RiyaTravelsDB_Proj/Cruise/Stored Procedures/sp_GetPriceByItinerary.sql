-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[sp_GetPriceByItinerary]
	@ItineraryId varchar(100)
AS
BEGIN
	
	select * from Cruise.CacheRoomPrices where ItineraryId = @ItineraryId
	and DATEDIFF(hour, ValidTill, GETDATE()) = 0

END
