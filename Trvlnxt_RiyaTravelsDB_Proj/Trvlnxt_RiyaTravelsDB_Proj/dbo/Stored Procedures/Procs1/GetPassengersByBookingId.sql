CREATE PROCEDURE [dbo].[GetPassengersByBookingId]
    @BookingId INT
AS
BEGIN
    SELECT 
        pid 
    FROM tblPassengerBookDetails 
    WHERE fkBookMaster = @BookingId order by pid
END
