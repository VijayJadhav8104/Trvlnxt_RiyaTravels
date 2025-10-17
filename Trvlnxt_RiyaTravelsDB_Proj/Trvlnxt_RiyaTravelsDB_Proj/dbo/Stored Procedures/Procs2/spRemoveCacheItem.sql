
CREATE proc [dbo].[spRemoveCacheItem]
@cacheKey varchar(100)
,@remark varchar(500)
as
begin
 --begin try   
 --  begin tran  

   insert into [tblCacheMasterRemoveItems] 
   ([cacheKey],[travelDate],[travelFrom],[travelTo],[travelClass],[returnFrom],[returnTo],[returnDate],[noOfAdult]
       ,[noOfChild],[noOfInfant],[expiredOn],[cachedOn],[FlightSearchData])
   select [cacheKey],[travelDate],[travelFrom],[travelTo],[travelClass],[returnFrom],[returnTo],[returnDate],[noOfAdult]
       ,[noOfChild],[noOfInfant],[expiredOn],[cachedOn],[FlightSearchData] 
	   from [dbo].[tblCacheMaster] where cacheKey = @cacheKey;

   delete from tblCacheMaster where cacheKey = @cacheKey;

    insert into [dbo].[tblCacheMasterLog]([cacheKey],remark) values(@cacheKey,@remark);
 --  commit tran;  
 --end try  
 --begin catch  

 --   rollback tran;  
	--DECLARE @ErrorNumber INT = ERROR_NUMBER();
 --   DECLARE @ErrorLine INT = ERROR_LINE();
 --   DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
 --   DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
 --   DECLARE @ErrorState INT = ERROR_STATE();

 --   RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

 --end catch;  
               
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spRemoveCacheItem] TO [rt_read]
    AS [dbo];

