-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE GetBBHotelSBReversalStatus  
   
 @BookingRefrence varchar(200)=null    
  
AS  
BEGIN  
   
 select SB_ReversalStatus from Hotel_BookMaster  
 where BookingReference=@BookingRefrence  
  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBBHotelSBReversalStatus] TO [rt_read]
    AS [dbo];

