-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
--  GetCancelText  RT2041323
-- =============================================  
CREATE PROCEDURE GetCancelText  
   
 @bookingid varchar(200)=null  
  
AS  
BEGIN  
   
 select CancellationPolicy from Hotel_BookMaster where BookingReference=@bookingid  
  
END  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCancelText] TO [rt_read]
    AS [dbo];

