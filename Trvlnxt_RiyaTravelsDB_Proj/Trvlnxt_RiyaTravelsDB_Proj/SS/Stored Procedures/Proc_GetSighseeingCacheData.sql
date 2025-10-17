
--Proc_GetLatestCacheData'AllHotelData_ffc48170-1ee7-45a9-b9af-38e876e82129638122316727755186ufaedmrpyesaytyvqhu5hlrh'      
CREATE Procedure [SS].[Proc_GetSighseeingCacheData]        
	@CacheKey varchar(200)      
As        
Begin        
	SELECT * 
	FROM [AllAppLogs].[SS].[SighseeingCacheData] WITH(NOLOCK)
	Where CacheKey = @CacheKey and IsActive = 1
End      
      
