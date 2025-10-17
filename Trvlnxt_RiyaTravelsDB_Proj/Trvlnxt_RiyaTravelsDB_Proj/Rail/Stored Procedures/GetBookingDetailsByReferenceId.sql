-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [Rail].[GetBookingDetailsByReferenceId]
@fk_bookingId varchar(200) 	
AS
BEGIN
	
	select * from rail.BookingItems

END
