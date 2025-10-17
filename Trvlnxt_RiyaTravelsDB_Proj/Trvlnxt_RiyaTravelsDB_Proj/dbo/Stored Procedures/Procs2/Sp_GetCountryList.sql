CREATE Procedure [dbo].[Sp_GetCountryList]
@UserId INT=NULL
as
begin
select C.CountryCode  as CountryCode,c.ID from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetCountryList] TO [rt_read]
    AS [dbo];

