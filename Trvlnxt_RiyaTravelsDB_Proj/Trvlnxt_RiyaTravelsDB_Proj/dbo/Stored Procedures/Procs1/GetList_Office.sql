
create Procedure [dbo].[GetList_Office]

as
begin
SELECT PKID,OfficeID, CountryCode,Currency
from tblAmadeusOfficeID


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Office] TO [rt_read]
    AS [dbo];

