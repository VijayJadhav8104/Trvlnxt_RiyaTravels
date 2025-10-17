  
CREATE PROCEDURE RetrievePancardUrl  
    @BookId INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT PanCardURL  
    FROM Hotel_BookMaster  WITH (NOLOCK) 
    WHERE pkId = @BookId;  
END;  