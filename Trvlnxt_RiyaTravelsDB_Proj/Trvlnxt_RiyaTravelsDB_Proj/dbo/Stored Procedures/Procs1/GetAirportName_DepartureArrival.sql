CREATE PROCEDURE GetAirportName_DepartureArrival
	@CityNameDep VARCHAR(2000) = NULL
	,@CityNameArr VARCHAR(2000) = NULL
	,@SectorCodeDep VARCHAR(2000) = NULL
	,@SectorCodeArr VARCHAR(2000) = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @DubaiSectorsDep VARCHAR(10)
	, @DubaiSectorsArr VARCHAR(10)
	, @UAESectorCountDep Int
	, @UAESectorCountArr Int

	SELECT @UAESectorCountDep = COUNT(1) FROM tblAirportCity 
	WHERE MainCode = 'DXB' 
	AND CODE IN (SELECT Item FROM dbo.SplitString(@SectorCodeDep, ','))

	SELECT @UAESectorCountArr = COUNT(1) FROM tblAirportCity 
	WHERE MainCode = 'DXB' 
	AND CODE IN (SELECT Item FROM dbo.SplitString(@SectorCodeArr, ','))

	SET @DubaiSectorsDep = (CASE WHEN @UAESectorCountDep > 0 THEN 'DXB' ELSE '' END)
	SET @DubaiSectorsArr = (CASE WHEN @UAESectorCountArr > 0 THEN 'DXB' ELSE '' END)

	SELECT 
		(SELECT CODE AS SectorCode
		, CODE AS AirportName
		--, LTRIM(RTRIM(REPLACE(SUBSTRING(NAME, CHARINDEX('-', NAME) + 1, LEN(NAME)), 'Airport', ''))) AS AirportName
		FROM 
		(
			SELECT CODE, NAME FROM tblAirportCity WHERE MainCode = @DubaiSectorsDep

			UNION ALL

			SELECT CODE, NAME FROM tblAirportCity 
			WHERE SEARCHNAME IN (SELECT LTRIM(Item) FROM dbo.SplitString(@CityNameDep, ','))
		) AS tbl
		FOR JSON PATH) AS DepAirports

		, (SELECT CODE AS SectorCode
		, CODE AS AirportName
		--, LTRIM(RTRIM(REPLACE(SUBSTRING(NAME, CHARINDEX('-', NAME) + 1, LEN(NAME)), 'Airport', ''))) AS AirportName
		FROM 
		(
			SELECT CODE, NAME FROM tblAirportCity WHERE MainCode = @DubaiSectorsArr

			UNION ALL

			SELECT CODE, NAME FROM tblAirportCity 
			WHERE SEARCHNAME IN (SELECT LTRIM(Item) FROM dbo.SplitString(@CityNameArr, ','))
		) AS tbl
		FOR JSON PATH) AS ArrAirports
	FOR JSON PATH

END