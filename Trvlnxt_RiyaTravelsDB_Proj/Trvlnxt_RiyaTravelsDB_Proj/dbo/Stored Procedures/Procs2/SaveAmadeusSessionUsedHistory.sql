CREATE procedure [dbo].[SaveAmadeusSessionUsedHistory]    
    
@SessionPkId int=null,  
@SessionId varchar(30)=null,    
@AgentId int=null,
@SequenceNumber int=null,
@APIName varchar(100)=null
  
AS    
BEGIN     
    
 INSERT INTO AmadeusSessionUsedHistory(SessionPkId,SessionId,AgentId,SequenceNumber,APIName)    
 VALUES(@SessionPkId,@SessionId,@AgentId,@SequenceNumber,@APIName)    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SaveAmadeusSessionUsedHistory] TO [rt_read]
    AS [dbo];

