      
CREATE PROCEDURE [dbo].[AddCacheLogToDb]        
        
@LogKey varchar(300)=NULL,        
@LogData varchar(max)=NULL,        
@DepartureDate date=NULL,        
@APIName varchar(200)=NULL,      
@fromSec varchar(50)=NULL,      
@toSec varchar(50)=NULL,      
@isReturn varchar(10)=NULL      
AS         
        
if exists (select Id from [AllAppLogs].[dbo].CacheLogs with (updlock,serializable) where LogKey = @LogKey)        
begin        
   update [AllAppLogs].[dbo].CacheLogs set LogData=@LogData, UpdatedDate=Getdate()       
   where LogKey = @LogKey        
end        
else        
begin        
    
 --if(@DepartureDate>CONVERT(date, getdate()))    
 --begin    
    
    insert into [AllAppLogs].[dbo].CacheLogs (LogKey,LogData,DepartureDate,APIName,FromSector,ToSector,IsReturn)        
    values (@LogKey, @LogData,@DepartureDate,@APIName,@fromSec,@toSec,@isReturn)       
   --end    
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddCacheLogToDb] TO [rt_read]
    AS [dbo];

