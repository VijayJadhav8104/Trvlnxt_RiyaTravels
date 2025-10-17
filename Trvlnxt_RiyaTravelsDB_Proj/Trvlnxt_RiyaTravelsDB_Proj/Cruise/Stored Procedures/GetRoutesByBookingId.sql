-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[GetRoutesByBookingId]
	@BookingId bigint
AS
BEGIN
	
	select * from Cruise.BookedRoutes where FkBookingId = @BookingId

END
