-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[GetPaxDetailsByBookingId]
	@BookingId bigint
AS
BEGIN
	
	select * from Cruise.BookedPaxDetails where FkBookingId = @BookingId

END
