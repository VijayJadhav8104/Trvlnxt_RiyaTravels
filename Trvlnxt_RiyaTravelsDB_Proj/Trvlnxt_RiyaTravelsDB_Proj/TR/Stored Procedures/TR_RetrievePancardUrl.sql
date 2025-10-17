      
CREATE PROCEDURE [TR].[TR_RetrievePancardUrl]      
    @BookId INT      
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    SELECT DocumentURL      
    FROM TR.TR_BookingMaster      
    WHERE BookingId = @BookId;      
END; 