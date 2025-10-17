-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Cruise.UpdateCancellationById
	@BookingId bigint
AS
BEGIN
	
	Update Cruise.Bookings
	Set IsConfirmed = 0,
	IsCancelled = 1,
	[Status] = 4
	Where Id = @BookingId

END
