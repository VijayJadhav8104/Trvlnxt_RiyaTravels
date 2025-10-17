
--select * from [dbo].[AirlinesName]


CREATE PROCEDURE [dbo].[sp_AirportTimeUTC]	-- [dbo].[sp_AirportTimeUTC] 'JFK,PEK,DEL,AUH,DXB,FRA,AMS,CDG,LHR,ZRH,MUC,ORD,'
	@AirportList varchar(1000) 
AS
BEGIN
	SELECT Distinct 
		[CODE] AS Code
		,[NAME] AS AirportName
		,[SEARCHNAME] AS City
		,[COUNTRY] AS CountryCode
		,[UTC] AS UTC
		,[newUTCTime] AS NewUTC
		,[State_code] AS StateCode
		,0 As[Index]
	FROM [RiyaTravels].[dbo].[tblAirportCity] 
	WHERE Code in (SELECT Element FROM [dbo].func_Split(@AirportList, ',')) --AND COUNTRY !='IN'

	--	SELECT Distinct *
	--FROM [dbo].[111] 
	--WHERE Code in (SELECT Element FROM [dbo].func_Split(@AirportList, ',')) AND CountryCode !='IN'
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_AirportTimeUTC] TO [rt_read]
    AS [dbo];

