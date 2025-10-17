CREATE PROCEDURE [dbo].[SP_Insert_NationalityData]
@xml XML
AS
BEGIN
      SET NOCOUNT ON;
 
      INSERT INTO Hotel_Nationality_Master
      SELECT    
      NationalityTable.value('(Code/text())[1]','VARCHAR(100)') AS Code, --TAG
      NationalityTable.value('(Nationality/text())[1]','VARCHAR(100)') AS Nationality ,--TAG
	  NationalityTable.value('(IsoCode/text())[1]','VARCHAR(100)') AS ISOCode --TAG
      FROM
      @xml.nodes('/Response/NationalitiesInfo')AS TEMPTABLE(NationalityTable)
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_Insert_NationalityData] TO [rt_read]
    AS [dbo];

