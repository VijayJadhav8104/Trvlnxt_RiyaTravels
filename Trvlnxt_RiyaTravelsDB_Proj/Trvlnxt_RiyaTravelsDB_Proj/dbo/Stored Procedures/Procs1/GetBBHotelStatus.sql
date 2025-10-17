CREATE PROCEDURE GetBBHotelStatus  
 -- Add the parameters for the stored procedure here  
   
AS  
BEGIN  
 select * from Hotel_Status_Master where Id in(3,4,7,2,1,5,9,10,13) 
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBBHotelStatus] TO [rt_read]
    AS [dbo];

