-- =============================================  
-- Author:  Bhavika kawa  
-- Description: TO get Airline popup details  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_GetAirlinePopup]  
@UserType varchar(10),  
@Country varchar(10)  
AS  
BEGIN  
   
 SELECT * FROM mAirlinePopup m  
  where   
  (m.UserType=@UserType) and (m.Country=@Country)  
 and m.IsActive=1 and m.IsBlocked=0  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAirlinePopup] TO [rt_read]
    AS [dbo];

