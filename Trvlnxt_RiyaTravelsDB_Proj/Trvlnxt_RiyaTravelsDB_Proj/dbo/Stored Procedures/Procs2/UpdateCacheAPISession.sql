
CREATE PROCEDURE [dbo].[UpdateCacheAPISession]  
   
 @SessionToken varchar(200),  
 @SessionData varchar(max)  
AS  
BEGIN  
   
 update [AllAppLogs].[dbo].CacheAPISession set SessionData=@SessionData,UpdatedDate=GETDATE() where SessionToken=@SessionToken;  
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCacheAPISession] TO [rt_read]
    AS [dbo];

