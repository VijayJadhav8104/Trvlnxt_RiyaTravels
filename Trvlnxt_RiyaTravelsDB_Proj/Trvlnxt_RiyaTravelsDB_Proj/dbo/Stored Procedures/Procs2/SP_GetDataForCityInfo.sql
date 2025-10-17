CREATE procedure [dbo].[SP_GetDataForCityInfo]


as
begin

WITH cwi AS
(   SELECT *, ROW_NUMBER() OVER (PARTITION BY CountryName ORDER BY CountryName ASC) AS rn
    FROM Conti_Country where IsActive=0
)
SELECT Id,CountryName as Country
FROM cwi
WHERE rn = 1 order by CountryName;


WITH cci AS
(   SELECT *, ROW_NUMBER() OVER (PARTITION BY CityName ORDER BY CityName ASC) AS rn
    FROM TblCity where IsActive=0
)
SELECT Id,CityName
FROM cci
WHERE rn = 1 order by CityName;

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetDataForCityInfo] TO [rt_read]
    AS [dbo];

