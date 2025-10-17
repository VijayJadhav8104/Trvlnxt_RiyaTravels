CREATE procedure [dbo].[SaveAmadeusSessionToDB]    
    
@SessionData varchar(max)=null,    
@AgentId int=null,    
@SessionStatus varchar(10)=null,    
@OfficeId varchar(30)=null,    
@SessionId varchar(30)=null ,  
@WsapId varchar(20)=null,  
@ApplicationName varchar(30)=null,
@SequenceNumber varchar(20)=null,
@APIName varchar(100)=null  
AS    
BEGIN     
    
  declare @id int=(  
    
    
  --select Id from AmadeusSessions with (updlock,serializable)  
    select Id from AmadeusSessions with (nolock) 
 where SessionId = @SessionId and WsapId=@WsapId and OfficeId=@OfficeId  
  );  
  
  if (@id>0)  
  BEGIN  
  
 UPDATE AmadeusSessions 
 
 set SequenceNumber=@SequenceNumber,
 SessionData=@SessionData,
 SessionStatus=@SessionStatus,
 APIName=@APIName,
 LastUpdate=getdate()
 
 where Id=@id;  
  
 Exec SaveAmadeusSessionUsedHistory @id,@SessionId,@AgentId,@SequenceNumber,@APIName 
  
  END  
  
  Else  
  
  BEGIN  
  
 INSERT INTO AmadeusSessions
 (SessionId,WsapId,SessionData,SessionOwnerAgentId,SessionStatus,OfficeId,ApplicationName,SequenceNumber,APIName)    
 VALUES(@SessionId,@WsapId,@SessionData,@AgentId,@SessionStatus,@OfficeId,@ApplicationName,@SequenceNumber,@APIName);  
  
 set @id=(SELECT SCOPE_IDENTITY());  
  
 Exec SaveAmadeusSessionUsedHistory @id,@SessionId,@AgentId,@SequenceNumber,@APIName
  
 END  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SaveAmadeusSessionToDB] TO [rt_read]
    AS [dbo];

