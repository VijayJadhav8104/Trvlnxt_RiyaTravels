CREATE Procedure [dbo].[Sp_GetAirlinesList]    
AS    
BEGIN    
	SELECT DISTINCT _code AS AirlineId
			, _code + ' - ' + _NAME AS AirlineName 
	FROM AirlinesName WITH(NOLOCK)
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAirlinesList] TO [rt_read]
    AS [dbo];

