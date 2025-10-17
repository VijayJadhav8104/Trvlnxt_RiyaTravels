-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Rail].[GetBookingItemDetails]
@Id varchar(200)   	
AS
BEGIN

	select * from rail.BookingItems where fk_bookingId = @Id

END

