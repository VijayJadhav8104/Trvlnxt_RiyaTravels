
CREATE proc [dbo].[spInsertCacheRemovedKeys]
@cacheKey varchar(100)
,@remark varchar(500)
,@FSCacheMaster varchar(max)
as
begin
 if not exists(select id from tblCacheRestoration where cacheKey=@cacheKey)
 begin
 insert into tblCacheRestoration(cacheKey,Remark,FSReqParaJson) values(@cacheKey,@remark,@FSCacheMaster)
 end
 else 
 begin
   update tblCacheRestoration set Remark=  Remark + ';' +@remark,FSReqParaJson=@FSCacheMaster where cacheKey=@cacheKey;
   insert into tblCacheRestorationLog(cacheKey,Remark) values(@cacheKey,'cacheKey Updated - ' + @remark);
 end
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertCacheRemovedKeys] TO [rt_read]
    AS [dbo];

