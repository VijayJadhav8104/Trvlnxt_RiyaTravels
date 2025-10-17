
CREATE PROCEDURE [dbo].[FetchOfficeID]
AS

BEGIN
SELECT * FROM tblAmadeusOfficeID
--SELECT PKID,OfficeID,CountryCode,Currency FROM tblAmadeusOfficeID
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchOfficeID] TO [rt_read]
    AS [dbo];

