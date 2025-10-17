--Proc_GetLatestCacheData'AllHotelData_ffc48170-1ee7-45a9-b9af-38e876e82129638122316727755186ufaedmrpyesaytyvqhu5hlrh'        
CREATE Procedure Proc_GetLatestCacheData          
@CacheKey varchar(200)        
As          
Begin          
Select *,
CASE WHEN (CacheTime > GETDATE()) THEN DATEDIFF(SS, GETDATE(), CacheTime) ELSE 0 END AS CacheExpiresInSecond 
from [AllAppLogs].[dbo].HotelCacheData Where CacheKey=@CacheKey and IsActive=1  
End        