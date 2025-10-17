CREATE PROCEDURE BBHotelGetPNRDetails  
 -- Add the parameters for the stored procedure here  
 @id int=0  
AS  
BEGIN  
   
 select  '' as myblance ,* from Hotel_BookMaster HB  
 join Hotel_Pax_master PM on PM.book_fk_id=HB.pkId  
 where pkId=@id  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBHotelGetPNRDetails] TO [rt_read]
    AS [dbo];

