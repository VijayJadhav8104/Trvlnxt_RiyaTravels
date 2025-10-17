
CREATE proc [dbo].[spUpdateDbChanges]
@FlightSearchData varchar(max)
,@cacheKey varchar(100)
as
begin
 --begin try   
 --  begin tran  

   UPDATE [dbo].[tblCacheMaster]
   SET 
      [FlightSearchData] = @FlightSearchData
       WHERE cacheKey=@cacheKey;
	  
--      insert into [dbo].[tblCacheMasterLog]([cacheKey],remark) values(@cacheKey,'spUpdateDbChanges Updated,Update Db Changes in CacheObj');

 --  commit tran;  

 --end try  
 --begin catch  
   
 --   rollback tran;  
	--  DECLARE @ErrorNumber INT = ERROR_NUMBER();
 --   DECLARE @ErrorLine INT = ERROR_LINE();
 --   DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
 --   DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
 --   DECLARE @ErrorState INT = ERROR_STATE();
 
 ----insert into tblException_Details([EDate],[ErrorMsg]) values(GETDATE(),'test not avl');
 --   RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

 --end catch;  
               
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateDbChanges] TO [rt_read]
    AS [dbo];

