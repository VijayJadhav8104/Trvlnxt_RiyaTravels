CREATE procedure [dbo].[Get_CountryList]


as
begin

select distinct Country
from 
mastCountry

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_CountryList] TO [rt_read]
    AS [dbo];

