CREATE PROCEDURE [Cruise].[BookingsGetById]
	@Id bigint
AS
BEGIN
	Select * from Cruise.Bookings where Id = @Id
END
