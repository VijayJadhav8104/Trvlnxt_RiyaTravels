
CREATE proc [dbo].[spGetCacheMasterDataForRestor]
@cacheKey varchar(max)=null
as
begin
    select [FSReqParaJson] from tblCacheRestoration where (@cacheKey=@cacheKey or @cacheKey is null)
--select a.cacheKey,a.expiredOn,a.travelFrom,a.travelTo,a.returnFrom,a.returnTo,a.cachedOn,a.expiredOn,a.noOfAdult,
--a.noOfChild,a.noOfInfant,a.returnDate,a.travelDate,a.sector,a.travelClass,a.[IsSpecialSector]
--,b.Remark as removeRemark,b.createdOn as removedOn
-- from tblCacheMaster a 
--inner join tblCacheRestoration b
--on a.cacheKey=b.cacheKey
--where a.cacheKey in (select element from [dbo].[func_Split](@cacheKey,',')) or @cacheKey is null
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetCacheMasterDataForRestor] TO [rt_read]
    AS [dbo];

