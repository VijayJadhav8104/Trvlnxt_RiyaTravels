

--select * from sectors


CREATE proc [dbo].[GetRecords_SectorsCalculation]

@CountryCode varchar(20),
@Code varchar(50)


as
begin

--DECLARE
--@CountryCode varchar(20)= 'IN',
--@Code varchar(50)='BOM'



SELECT
COUNT(*) Count
--Code,
--[Airport Name],
--City,
--Continent,
--[Country Code], 
--[Itinerary Type]
FROM
sectors

WHERE 
Code = @Code 
AND [Country Code] = @CountryCode


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecords_SectorsCalculation] TO [rt_read]
    AS [dbo];

