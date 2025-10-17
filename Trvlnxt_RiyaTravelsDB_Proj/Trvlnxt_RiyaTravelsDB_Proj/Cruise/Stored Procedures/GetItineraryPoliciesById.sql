-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[GetItineraryPoliciesById]
	@BookingId bigint
AS
BEGIN
	
	select CancellationPolicy from Cruise.Bookings where Id = @BookingId

END
