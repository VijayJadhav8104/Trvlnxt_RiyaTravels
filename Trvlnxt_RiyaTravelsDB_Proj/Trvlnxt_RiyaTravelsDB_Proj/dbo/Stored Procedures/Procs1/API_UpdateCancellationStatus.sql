CREATE PROCEDURE [dbo].[API_UpdateCancellationStatus]                 
@RemarkCancellation varchar(max)= '',   
@RemarkCancellation2 varchar(max)=null,  
@RiyaPNR varchar(10)=null,  
@IsHoldBookingCancel bit = 0  
                  
AS                   
BEGIN                   
--REMARK  @CancellationPenalty AMOUNT IS REFUNDABLE AMOUNT FOR WHOLE PNR                 
                
DECLARE @AgentId VARCHAR(10),@MainAgentId VARCHAR(10)  
  
SET @AgentId=(SELECT  TOP 1 AgentID FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)      
                                 
SET @MainAgentId=(SELECT  TOP 1 MainAgentId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                                  
 
IF @MainAgentId > 0    
BEGIN   
	IF @IsHoldBookingCancel = 1                  
	BEGIN                  
	 UPDATE tblBookMaster SET BookingStatus=9,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                  
	 UPDATE tblPassengerBookDetails                   
	 SET                   
	   RemarkCancellation=@RemarkCancellation,     
	   RemarkCancellation2=@RemarkCancellation2,                
	   BookingStatus=9,                  
	   cancellationDate=GETDATE(),                
	   CancelledDate=GETDATE(),             
	   TobecancellationDate=GETDATE(),            
	   CancelByAgency=@AgentId,            
	   CancelByAgency1=@AgentId,            
	   CancelByBackendUser1=@MainAgentId                     
	WHERE fkBookMaster IN (SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'                 
	END                  
	ELSE                  
	BEGIN                   
	 UPDATE tblBookMaster SET BookingStatus=11,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                  
	 UPDATE tblPassengerBookDetails                   
	 SET                   
	  RemarkCancellation=@RemarkCancellation,     
	  RemarkCancellation2=@RemarkCancellation2,                
	  BookingStatus=11,                  
	  cancellationDate=GETDATE(),                
	  CancelledDate=GETDATE(),              
	  TobecancellationDate=GETDATE(),            
	  CancelByAgency1=@AgentId,            
	  CancelByAgency=@AgentId,            
	  CancelByBackendUser1=@MainAgentId                  
	 WHERE fkBookMaster in(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'                    
	END                  
	END  
ELSE                                  
BEGIN    
IF @IsHoldBookingCancel = 1                  
	BEGIN                  
	 UPDATE tblBookMaster SET BookingStatus=9,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                  
	 UPDATE tblPassengerBookDetails                   
	 SET                   
	   RemarkCancellation=@RemarkCancellation,     
	   RemarkCancellation2=@RemarkCancellation2,                
	   BookingStatus=9,                  
	   cancellationDate=GETDATE(),                
	   CancelledDate=GETDATE(),             
	   TobecancellationDate=GETDATE(),            
	   CancelByAgency=@AgentId,            
	   CancelByAgency1=@AgentId,            
	   CancelByBackendUser1=@AgentId                  
	 WHERE fkBookMaster IN (SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'                 
	END                  
	ELSE                  
	BEGIN                   
	 UPDATE tblBookMaster SET BookingStatus=11,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                  
	 UPDATE tblPassengerBookDetails                   
	 SET                   
	  RemarkCancellation=@RemarkCancellation,     
	  RemarkCancellation2=@RemarkCancellation2,                
	  BookingStatus=11,                  
	  cancellationDate=GETDATE(),                
	  CancelledDate=GETDATE(),              
	  TobecancellationDate=GETDATE(),            
	   CancelByAgency1=@AgentId,            
	  CancelByAgency=@AgentId,            
	  CancelByBackendUser1=@AgentId                  
	 WHERE fkBookMaster in (SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) --AND paxType!='INFANT'                    
	END                  
	END  
end  
  
  