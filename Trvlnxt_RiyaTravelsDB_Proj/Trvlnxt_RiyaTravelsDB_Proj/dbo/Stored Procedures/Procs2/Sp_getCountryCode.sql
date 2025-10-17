  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE Sp_getCountryCode  
 -- Add the parameters for the stored procedure here  
 @CountryCode varchar(10)=''  
   ,@CityCode varchar(10)=''  
  
  
AS  
BEGIN  
 declare @Countryname varchar(50);  
 declare @Country varchar(50);  
  
 set @Countryname = (select CountryName from Hotel_CountryMaster where CountryCode=@CountryCode)  
 set @country=(SELECT REPLACE(@Countryname,'"',''))  
 print @country  
  
 Select A1 from country where country=@Country  
  
  
 select CityName from Hotel_City_Master where CityCode=@CityCode  
  
  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_getCountryCode] TO [rt_read]
    AS [dbo];

