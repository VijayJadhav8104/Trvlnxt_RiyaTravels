    
CREATE PROCEDURE SS.RetrievePancardUrl    
    @BookId INT    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    SELECT     DocumentURL as PanCardURL
    FROM Ss.SS_BookingMaster  WITH (NOLOCK)   
    WHERE BookingId = @BookId;    
END; 
 
 
    SELECT     DocumentURL
    FROM Ss.SS_BookingMaster