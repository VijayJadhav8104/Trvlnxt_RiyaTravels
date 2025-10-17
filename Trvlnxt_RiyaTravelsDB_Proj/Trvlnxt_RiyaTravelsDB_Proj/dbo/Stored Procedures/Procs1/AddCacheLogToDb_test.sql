      
CREATE PROCEDURE [dbo].[AddCacheLogToDb_test]        
        
@LogKey varchar(300)=NULL,        
@LogData varchar(max)=NULL,        
@DepartureDate date=NULL,        
@APIName varchar(200)=NULL,      
@fromSec varchar(50)=NULL,      
@toSec varchar(50)=NULL,      
@isReturn varchar(10)=NULL      
AS         
        
if exists (select Id from cachelogs_test with (updlock,serializable) where LogKey = @LogKey)        
begin        
   update cachelogs_test set LogData=@LogData, UpdatedDate=Getdate()       
   where LogKey = @LogKey        
end        
else        
begin        
    
 --if(@DepartureDate>CONVERT(date, getdate()))    
 --begin    
    
    insert into cachelogs_test (LogKey,LogData,DepartureDate,APIName,FromSector,ToSector,IsReturn)        
    values (@LogKey, @LogData,@DepartureDate,@APIName,@fromSec,@toSec,@isReturn)       
   --end    
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddCacheLogToDb_test] TO [rt_read]
    AS [dbo];

