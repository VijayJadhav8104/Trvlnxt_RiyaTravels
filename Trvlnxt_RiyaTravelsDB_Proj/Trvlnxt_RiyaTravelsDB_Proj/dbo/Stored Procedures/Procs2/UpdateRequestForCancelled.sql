        
CREATE PROCEDURE UpdateRequestForCancelled        
@BookingId VARCHAR(200)   
AS        
BEGIN            
        
 UPDATE Hotel_BookMaster SET RequestForCancelled='Yes' WHERE BookingReference=@BookingId        
END        

