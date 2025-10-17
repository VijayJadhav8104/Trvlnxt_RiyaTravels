
CREATE proc [dbo].[spUpdateExpiry]
 @expiredOn datetime
,@cacheKey varchar(100)
as
begin
update tblCacheMaster set expiredOn=@expiredOn where cacheKey=@cacheKey;
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateExpiry] TO [rt_read]
    AS [dbo];

