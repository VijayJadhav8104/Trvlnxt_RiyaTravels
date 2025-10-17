CREATE PROCEDURE [dbo].[InsertXMLData]
@xml XML
AS
BEGIN
      SET NOCOUNT ON;
 
      INSERT INTO Hotel_CountryMaster
      SELECT    
      Countrytable.value('(Code/text())[1]','VARCHAR(100)') AS CountryCode, --TAG
      Countrytable.value('(Name/text())[1]','VARCHAR(100)') AS CountryName --TAG
      FROM
      @xml.nodes('/Response/Country')AS TEMPTABLE(Countrytable)
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertXMLData] TO [rt_read]
    AS [dbo];

