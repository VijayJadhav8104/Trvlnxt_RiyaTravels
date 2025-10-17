-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Rail].[GetBookingPaxDetails]
@BookingId varchar(200)   	
AS
BEGIN

	select * from rail.PaxDetails pax
	  inner JOIN RAIL.BookingItems bki ON pax.fk_ItemId=bki.Id

	where bki.bookingId = @BookingId and pax.leadTraveler=1


END



--select * from Rail.BookingItems where id = 753
--select * from Rail.Bookings where id = 198

--select * from rail.PaxDetails where fk_ItemId=244

--select * from rail.Bookings where BookingReference='S934495007'