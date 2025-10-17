-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[GetItineraryByBookingId]
	@BookingId bigint
AS
BEGIN
	
	select * from Cruise.BookedItineraries where FkBookingId = @BookingId

END
