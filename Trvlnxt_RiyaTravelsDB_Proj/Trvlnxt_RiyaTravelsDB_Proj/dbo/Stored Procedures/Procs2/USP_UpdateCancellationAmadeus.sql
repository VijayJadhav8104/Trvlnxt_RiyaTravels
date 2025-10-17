CREATE PROCEDURE [dbo].[USP_UpdateCancellationAmadeus]--'test','614.80','47Z00G'              
@RemarkCancellation2 varchar(max)=null,              
@RiyaPNR varchar(10)=null              
              
AS               
BEGIN               
--REMARK  @CancellationPenalty AMOUNT IS REFUNDABLE AMOUNT FOR WHOLE PNR             
            
DECLARE @MainAgentId VARCHAR(10),@AgentId VARCHAR(10)              
  SET @MainAgentId=(SELECT  TOP 1 MainAgentId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)              
  SET @AgentId=(SELECT  TOP 1 AgentID FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)              
IF @MainAgentId>0              
BEGIN              
 UPDATE tblBookMaster SET BookingStatus=6,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR              
 UPDATE tblPassengerBookDetails               
 SET               
   RemarkCancellation=@RemarkCancellation2, 
   RemarkCancellation2=@RemarkCancellation2,            
   BookingStatus=6,              
   cancellationDate=GETDATE(),            
   CancelledDate=GETDATE(),         
   TobecancellationDate=GETDATE(),        
   CancelByAgency=@AgentId,        
   CancelByAgency1=@AgentId,        
   CancelByBackendUser1=@MainAgentId              
 WHERE fkBookMaster IN(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'             
END              
ELSE              
BEGIN               
 UPDATE tblBookMaster SET BookingStatus=6,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR              
 UPDATE tblPassengerBookDetails               
 SET               
  RemarkCancellation=@RemarkCancellation2, 
  RemarkCancellation2=@RemarkCancellation2,            
  BookingStatus=6,              
  cancellationDate=GETDATE(),            
  CancelledDate=GETDATE(),          
  TobecancellationDate=GETDATE(),        
   CancelByAgency1=@AgentId,        
  CancelByAgency=@AgentId,        
  CancelByBackendUser1=@AgentId              
 WHERE fkBookMaster in(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'                
END              
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_UpdateCancellationAmadeus] TO [rt_read]
    AS [dbo];

