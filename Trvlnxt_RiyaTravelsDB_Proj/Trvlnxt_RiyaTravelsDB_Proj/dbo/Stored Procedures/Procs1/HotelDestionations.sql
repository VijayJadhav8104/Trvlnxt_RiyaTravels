-- =============================================  
-- Author:  <Ketan Hiranandani>  
-- Create date: <05-May-2023>  
-- Description: <Hotel API Destinations>  
-- =============================================  
CREATE PROCEDURE HotelDestionations  
AS  
BEGIN  
   
 select HC.CountryName as [Name],HN.Nationality,HN.ISOCode as Code from Hotel_CountryMaster HC  
  
 LEFT JOIN Hotel_Nationality_Master as HN ON HC.CountryCode=HN.Code   
   
 where Nationality is not null  
  
END  