  
CREATE Procedure [dbo].[Sp_GetCountrybyAgent]  
	@AgentCountries nvarchar(100)=null
AS
BEGIN
	IF(@AgentCountries IS NOT NULL)  
	BEGIN  
		SELECT ID
				, CountryName AS CountryCode 
		FROM mCountry WITH(NOLOCK)
		WHERE CountryCode IN (SELECT DATA FROM sample_split(@AgentCountries,','))  
	END  
	ELSE  
	BEGIN  
		SELECT ID
				, CountryName AS CountryCode 
		FROM mCountry WITH(NOLOCK)  
	END   
END  
  
  
--select * from mCountry
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetCountrybyAgent] TO [rt_read]
    AS [dbo];

