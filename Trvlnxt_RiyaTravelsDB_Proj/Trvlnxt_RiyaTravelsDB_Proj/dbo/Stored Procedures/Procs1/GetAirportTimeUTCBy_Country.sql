
--select * from [dbo].[AirlinesName]


CREATE PROCEDURE [dbo].[GetAirportTimeUTCBy_Country]	-- [dbo].[sp_AirportTimeUTC] 'JFK,PEK,DEL,AUH,DXB,FRA,AMS,CDG,LHR,ZRH,MUC,ORD,'
	@CountryCode varchar(10) 
AS
BEGIN
	SELECT top 1
		[CODE] AS Code
		,[NAME] AS AirportName
		,[SEARCHNAME] AS City
		,[COUNTRY] AS CountryCode
		,[UTC] AS UTC
		,[newUTCTime] AS NewUTC
		,[State_code] AS StateCode
		,0 As[Index]
	FROM [RiyaTravels].[dbo].[tblAirportCity] 
	WHERE COUNTRY =@CountryCode and newUTCTime is not null
END



