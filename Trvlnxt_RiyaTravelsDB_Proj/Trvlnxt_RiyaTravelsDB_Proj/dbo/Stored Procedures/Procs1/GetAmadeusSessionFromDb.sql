CREATE procedure [dbo].[GetAmadeusSessionFromDb]      
      
@OfficeId varchar(30)=null,    
@WsapId varchar(30)=null,  
@ApplicationName varchar(30)=null  
AS      
BEGIN       
if(@ApplicationName='EDOC' or @ApplicationName='LFS' )  
 BEGIN  
  
  SELECT top 1 SessionData from AmadeusSessions   
  WHERE OfficeId=@OfficeId and WsapId=@WsapId and SessionStatus='Active'  and ApplicationName = @ApplicationName
 END   
ELSE   
 BEGIN  
  SELECT SessionData from AmadeusSessions   
  WHERE OfficeId=@OfficeId and WsapId=@WsapId and SessionStatus='Active' and ApplicationName=@ApplicationName  --and ID=611   
 END  
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAmadeusSessionFromDb] TO [rt_read]
    AS [dbo];

