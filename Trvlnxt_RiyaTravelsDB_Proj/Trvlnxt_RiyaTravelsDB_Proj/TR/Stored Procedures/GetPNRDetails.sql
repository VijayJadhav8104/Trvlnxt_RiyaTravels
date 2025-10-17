CREATE PROCEDURE TR.GetPNRDetails        
 -- Add the parameters for the stored procedure here        
 @id int=0        
AS        
BEGIN        
         
 select * from TR.TR_BookingMaster     
 where BookingId=@id        
        
END 