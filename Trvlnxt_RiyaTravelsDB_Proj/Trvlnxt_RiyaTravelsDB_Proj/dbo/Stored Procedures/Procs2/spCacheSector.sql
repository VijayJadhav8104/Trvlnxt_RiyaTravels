
CREATE proc [dbo].[spCacheSector] --'RAJ','BLR'
@depFrom varchar(10)
,@depTo varchar(10)
--,@rtnFrom varchar(10)=null
--,@rtnTo varchar(10)=null

as
begin

 if exists(select id from [dbo].[tblCacheSector] where ltrim(rtrim([From])) = @depFrom or ltrim(rtrim([From])) = @depTo)
   begin
    select  1 as [days], 0 as [hours],0 as [minute],1 as specialSector
     --  from [dbo].[tblCacheSector] --where Code like('%DEL%')
      -- where ltrim(rtrim([From])) = @depFrom or  ltrim(rtrim([From])) = @depTo
   end 
   else 
   begin 
       select 1 as [days],0 as [hours],0 as [minute],0 as specialSector -- default 30 minute
   end
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spCacheSector] TO [rt_read]
    AS [dbo];

