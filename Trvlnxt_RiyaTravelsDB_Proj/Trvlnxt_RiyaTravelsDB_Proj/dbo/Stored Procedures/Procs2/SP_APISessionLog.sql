
create procedure [dbo].[SP_APISessionLog]                
@trackID varchar(300) = ''                        
,@fromDestination varchar(50) = ''                        
,@toDestination varchar(50) = ''                        
,@departureDateTime varchar(100) = ''                        
,@apiName varchar(50) = ''                     
,@methodName varchar(100) = ''        
,@officeID varchar(100) = ''        
,@logType varchar(50) = ''        
,@xmlRequest varchar(max) = ''        
,@xmlResponse varchar(max) = ''
as                          
begin

  insert into [AllAppLogs].[dbo].apisessionLog (trackID,fromDestination,toDestination,departureDateTime,apiName,methodName,officeID,logType,xmlRequest,xmlResponse)                        
  Values (@trackID,@fromDestination,@toDestination,@departureDateTime,@apiName,@methodName,@officeID,@logType,@xmlRequest,@xmlResponse)
  
end  