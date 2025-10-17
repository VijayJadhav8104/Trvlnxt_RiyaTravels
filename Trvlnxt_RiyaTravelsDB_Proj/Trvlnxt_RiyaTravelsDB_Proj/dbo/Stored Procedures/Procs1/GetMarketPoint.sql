CREATE proc [dbo].[GetMarketPoint]
@UserId INT

as
begin



select C.CountryCode  as Country,C.ID from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1

end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetMarketPoint] TO [rt_read]
    AS [dbo];

