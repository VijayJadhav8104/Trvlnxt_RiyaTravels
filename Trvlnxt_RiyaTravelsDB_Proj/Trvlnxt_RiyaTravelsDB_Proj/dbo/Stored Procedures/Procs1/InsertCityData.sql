
CREATE PROCEDURE [dbo].[InsertCityData]
@xml XML,
@Coutry_code int
AS
BEGIN
      SET NOCOUNT ON;
      INSERT INTO Hotel_CityMaster
      SELECT    
      Citytable.value('(CityCode/text())[1]','VARCHAR(100)') AS CityCode, --TAG
      Citytable.value('(Name/text())[1]','VARCHAR(100)') AS CityName ,--TAG
	  @Coutry_code AS CountryID
      FROM
      @xml.nodes('/Response/CityInfo')AS TEMPTABLE(Citytable)
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCityData] TO [rt_read]
    AS [dbo];

