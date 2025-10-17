CREATE PROCEDURE USP_LCCCancellationPassengersfail  
@RemarkCancellation2 varchar(max)=null,                  
@CancellationPenalty decimal(18,4)=null,                  
@RiyaPNR varchar(10)=null                          
                  
AS                   
BEGIN                   
         
DECLARE @MainAgentId VARCHAR(10),@AgentId VARCHAR(10)                  
SET @MainAgentId=(SELECT  TOP 1 MainAgentId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                  
SET @AgentId=(SELECT  TOP 1 AgentID FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                  
  
  
                 
 UPDATE tblBookMaster SET BookingStatus=6,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                  
 UPDATE tblPassengerBookDetails                   
 SET                   
  RemarkCancellation =@RemarkCancellation2,  
  TobecancellationDate=GETDATE(),            
  BookingStatus=6,                  
  CancelByBackendUser1=@MainAgentId,                  
  CancelByAgency=@AgentId,            
  CancelByAgency1=@AgentId     
  
  WHERE fkBookMaster IN(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)         
                 
  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_LCCCancellationPassengersfail] TO [rt_read]
    AS [dbo];

