CREATE PROCEDURE ss.ssBBHotelGetPNRDetails      
 -- Add the parameters for the stored procedure here      
 @id int=0      
AS      
BEGIN      
       
 select * from ss.SS_BookingMaster     
 where BookingId=@id      
      
END 