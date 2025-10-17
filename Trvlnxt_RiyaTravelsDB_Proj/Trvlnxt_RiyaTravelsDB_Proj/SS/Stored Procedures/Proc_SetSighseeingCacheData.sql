
CREATE PROCEDURE [SS].[Proc_SetSighseeingCacheData]          
	@CacheKey varchar(200),          
	@CacheData varchar(MAX), 
	@MethodName varchar(200)=null
AS          
BEGIN          
      
	IF EXISTS(SELECT id FROM [AllAppLogs].[SS].[SighseeingCacheData] WITH(NOLOCK) WHERE CacheKey = @CacheKey AND IsActive = 1)      
	BEGIN      
		UPDATE [AllAppLogs].[SS].[SighseeingCacheData]
		Set CacheData = @CacheData, CacheUpdateTime = GETDATE(),
			IsActive = 1, MethodName = @MethodName 
		WHERE CacheKey = @CacheKey      
	End      
	ELSE      
	BEGIN      
		INSERT INTO [AllAppLogs].[SS].[SighseeingCacheData]
			(CacheKey,CacheData,CacheTime,IsActive,MethodName)          
		Values
			(@CacheKey, @CacheData, DATEADD(minute,30,GETDATE()), 1, @MethodName)         
	End      
End 
