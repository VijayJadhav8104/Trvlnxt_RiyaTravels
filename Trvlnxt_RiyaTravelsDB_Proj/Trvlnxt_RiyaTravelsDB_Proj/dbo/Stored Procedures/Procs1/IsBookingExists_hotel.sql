  
  
  
      ---    IsBookingExists '1ZMA05'  
CREATE PROCEDURE [dbo].[IsBookingExists_hotel] --1P7CG3'  
@RiyaPNR   varchar(20)  
  
AS BEGIN  
  
IF(EXISTS(SELECT 1 FROM Hotel_BookMaster  WITH (NOLOCK) WHERE riyaPNR = @RiyaPNR))  
 BEGIN  
 SELECT TOP 1 'TRUE' AS IsExists, [PassengerPhone] as mobileNo,[PassengerEmail] as emailId FROM Hotel_BookMaster  WITH (NOLOCK) WHERE riyaPNR = @RiyaPNR  
 END  
ELSE  
 BEGIN  
 SELECT 'FALSE'  AS IsExists  
 END  
  
END  
  
  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[IsBookingExists_hotel] TO [rt_read]
    AS [dbo];

