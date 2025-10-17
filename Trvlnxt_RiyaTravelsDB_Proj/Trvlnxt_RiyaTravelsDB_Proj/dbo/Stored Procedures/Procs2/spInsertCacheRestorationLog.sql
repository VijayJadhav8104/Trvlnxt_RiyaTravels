
CREATE proc [dbo].[spInsertCacheRestorationLog]
@cacheKey varchar(100)
as
begin
 --  insert into [dbo].[tblCacheRestorationLog]([cacheKey],[Remark],[date])
 -- select cacheKey,Remark,createdOn from [tblCacheRestoration] where cacheKey=@cacheKey;
   delete from [tblCacheRestoration] where cacheKey=@cacheKey
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertCacheRestorationLog] TO [rt_read]
    AS [dbo];

