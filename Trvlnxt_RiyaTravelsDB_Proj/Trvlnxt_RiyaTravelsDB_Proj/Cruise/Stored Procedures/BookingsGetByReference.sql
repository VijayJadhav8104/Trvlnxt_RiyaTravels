-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Cruise].[BookingsGetByReference]
	@Id varchar(100)
AS
BEGIN
	Select * from Cruise.Bookings where BookingReferenceid = @Id
END
