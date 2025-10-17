
CREATE proc [dbo].[spGetCachedObject]
@cacheKey varchar(100)
as
begin
  select FlightSearchData from [dbo].[tblCacheMaster] where cacheKey=@cacheKey
end







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetCachedObject] TO [rt_read]
    AS [dbo];

