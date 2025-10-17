CREATE proc [dbo].[API_Airport_Airlines_AgentBalance] --[retrivepnr] '','','','RIYA USA'      
@cityCode varchar(3)=''      
,@AirlineCode varchar(3)=''      
,@AgentName varchar(max)=''      
As      
BEGIN      
    
if(@cityCode!='' and @AirlineCode = '')      
 Begin      
  select  NAME from tblAirportCity where CODE=@cityCode      
 END      
 if(@AirlineCode!='' and @cityCode = '')      
 Begin      
  select  _NAME from AirlinesName where _CODE=@AirlineCode      
 END     
    
if(@cityCode!='' and @AirlineCode!='' )      
 Begin      
  select top 1 NAME,(select top 1 _NAME from AirlinesName where _CODE=@AirlineCode) as _Name from tblAirportCity where CODE=@cityCode     
 END     
    
 if(@AgentName!='')      
 Begin      
  select ISNULL(AgentBalance,0) AS AgentBalance,userid from AgentLogin where UserID= @AgentName      
 END      
      
END 