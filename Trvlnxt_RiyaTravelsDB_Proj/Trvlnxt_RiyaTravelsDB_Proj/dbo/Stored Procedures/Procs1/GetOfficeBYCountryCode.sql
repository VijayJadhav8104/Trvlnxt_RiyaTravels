CREATE PROCEDURE [dbo].[GetOfficeBYCountryCode]
(  
  @CountryCode VARCHAR(10)  
)  
AS  
BEGIN 
select top 1 OfficeID from tblAmadeusOfficeID where CompanyName= '1A' and CountryCode =@CountryCode and Business='B2B'

END


