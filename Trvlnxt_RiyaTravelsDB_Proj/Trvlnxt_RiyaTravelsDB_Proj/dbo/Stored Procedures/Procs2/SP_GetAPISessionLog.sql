
create procedure [dbo].[SP_GetAPISessionLog]                
@trackID varchar(300) = ''
,@methodName varchar(100) = ''
,@logType varchar(50) = ''        
,@officeID varchar(100) = ''
as                          
begin

  select top 1 * from [AllAppLogs].[dbo].apisessionLog
  where trackID = @trackID and methodName = @methodName and logType = @logType order by insertedDateTime desc

end  