CREATE PROCEDURE [dbo].[USP_LCCCancellationPassengers] --'test','771','346X3I'                                
@RemarkCancellation2 varchar(max)=null,                                
@CancellationPenalty decimal(18,4)=null,                                
@RiyaPNR varchar(10)=null                                
--@MainAgentId varchar(10)=null,                                
--@AgentId varchar(10)=null,                                
--@Total varchar(50)=null,                                
--@countrycode varchar(20)=null                                
                                
AS                                 
BEGIN                                 
--REMARK  @CancellationPenalty AMOUNT IS REFUNDABLE AMOUNT FOR WHOLE PNR                               
                              
 DECLARE @PaymentMode VARCHAR(20),@Total decimal(18,4)=0,@countrycode varchar(20) ,@paxcount int=0 ,@debit decimal(18,4) = null,          
 @PerPassPenalty decimal(18,4)=0   ,@SSRTotal decimal(18,4)=0         
 SET @PaymentMode=(SELECT TOP 1 payment_mode FROM Paymentmaster WHERE order_id=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))                                
 --SET @Total=(SELECT sum(convert(decimal(18,2),amount)) FROM Paymentmaster WHERE order_status='Success'      
 --and (order_id=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) or              
 --ParentOrderId=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)))        
 SET @Total =(SELECT sum(convert(decimal(18,2),totalFare)) FROM tblBookMaster WHERE  riyaPNR=@RiyaPNR)      
 SET @SSRTotal +=(SELECT sum(convert(decimal(18,2),SSR_Amount)) FROM tblSSRDetails WHERE  fkBookMaster IN (SELECT pkid FROM tblBookMaster WHERE  riyaPNR=@RiyaPNR))      
  if( @SSRTotal is null)    
  BEGIN    
  SET @Total +=0    
  END    
  else    
  BEGIN    
  SET @Total +=@SSRTotal    
  END    
 SET @countrycode=(SELECT TOP 1 currency FROM Paymentmaster WHERE order_id=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))                                
 if @CancellationPenalty != 0                      
 begin                      
 SET @Total=@Total-@CancellationPenalty                   
 set @debit=@Total                  
 end                   
 else                  
 begin                  
 set @debit=@Total                  
 SET @Total=@CancellationPenalty                    
 end                  
                  
 DECLARE @MainAgentId VARCHAR(10),@AgentId VARCHAR(10)                                
 SET @MainAgentId=(SELECT  TOP 1 MainAgentId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                                
 SET @AgentId=(SELECT  TOP 1 AgentID FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                                
 SET @paxcount=(SELECT COUNT(*) FROM tblPassengerBookDetails                               
 WHERE fkBookMaster IN(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))                              
 SET @Total=@Total / @paxcount           
 set @PerPassPenalty=@CancellationPenalty          
 if exists (select top 1 * from tblBookMaster where riyaPNR=@RiyaPNR and (VendorName='Indigo' or VendorName='Spicejet'  or VendorName='Go Air'         
 or VendorName='AKASAAIR' OR VendorName='AIExpress'))          
 begin          
 set @PerPassPenalty=@CancellationPenalty/@paxcount          
 end          
IF @MainAgentId>0                                
BEGIN                                
 UPDATE tblBookMaster SET BookingStatus=11,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                                
 UPDATE tblPassengerBookDetails                                 
 SET                                 
  RemarkCancellation =@RemarkCancellation2,                                
  RemarkCancellation2=@RemarkCancellation2,                                
  CancellationPenalty=@PerPassPenalty,                                
  Debit=@debit,                                
  BookingStatus=11,                                
  cancellationDate=GETDATE(),                   
  CancelledDate=GETDATE(),                           
  TobecancellationDate=GETDATE(),                          
CancelByAgency=@AgentId,                          
  CancelByAgency1=@AgentId,                          
  CancelByBackendUser1=@MainAgentId                                
  WHERE fkBookMaster IN(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) and isReturn = 0               
       
--new added                
update TRVLNXT_Tickets_ERPStatus                 
SET BookingStatus=11,CancellationPenalty=@CancellationPenalty                
where riyaPNR=@RiyaPNR                  
                
END                                
ELSE                                
BEGIN                                 
 UPDATE tblBookMaster SET BookingStatus=11,canceledDate=GETDATE() WHERE riyaPNR=@RiyaPNR                        
 UPDATE tblPassengerBookDetails                                 
 SET                                 
  RemarkCancellation=@RemarkCancellation2,             
  RemarkCancellation2=@RemarkCancellation2,                                
  CancellationPenalty=@PerPassPenalty,                                
  Debit=@debit,                                
  BookingStatus=11,                                
  cancellationDate=GETDATE(),                              
  CancelledDate=GETDATE(),                            
  TobecancellationDate=GETDATE(),                          
  CancelByAgency=@AgentId,                      
  CancelByAgency1=@AgentId,                            
  CancelByBackendUser1=@AgentId                                
  WHERE fkBookMaster in(SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR) and isReturn = 0                  
                  
--new added                
update TRVLNXT_Tickets_ERPStatus                 
SET BookingStatus=11,CancellationPenalty=@CancellationPenalty                
where riyaPNR=@RiyaPNR                 
                
end                                
--select * from AgentLogin where UserID=(select top 1 UserID from tblBookMaster where riyaPNR=@RiyaPNR)                              
                                
                                 
IF(@PaymentMode='Check')                                 
BEGIN                                
 DECLARE @AGENTBALANCE decimal(18,4)=null,@AgencybalanceTotalAgent decimal(18,4)=null                                
 SET @AGENTBALANCE=(SELECT TOP 1 AgentBalance FROM AgentLogin WHERE UserID=@AgentID)                                
 SET @AgencybalanceTotalAgent=@AGENTBALANCE+@debit                                
                                
 UPDATE AgentLogin SET AgentBalance=@AgencybalanceTotalAgent WHERE userid=@AgentID                                
                                
 DECLARE @OrderId VARCHAR(50)                                
 SET @OrderId=(SELECT DISTINCT orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                                
                                
 INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)                                 
 VALUES (@AgentID,@OrderId,@PaymentMode,@AGENTBALANCE,@debit,@AgencybalanceTotalAgent, GETDATE(),@AgentID,1,'Credit',@RemarkCancellation2,'null')                                 
END                                
                                
Else                                
BEGIN                                
 DECLARE @CountryID INT                                
 DECLARE @Agencybalance decimal(18,4)=null                                
 DECLARE @AgencybalanceTotal decimal(18,4)=null                                
                                
 SET @CountryID=(SELECT ID FROM mCountry WHERE Currency=@countrycode)                                
 SET @Agencybalance=(SELECT DISTINCT cm.AgentBalance FROM tblBookMaster t1     INNER JOIN  Paymentmaster pm ON pm.order_id=t1.orderId                                
    INNER JOIN AgentLogin ag ON ag.UserID=t1.AgentID                                
    INNER JOIN mUserCountryMapping cm ON cm.UserId=t1.MainAgentId                                
    WHERE t1.riyaPNR=@RiyaPNR and t1.mainagentid=@MainAgentId and cm.CountryId=@CountryID)                                
                   
 SET @AgencybalanceTotal=@Agencybalance+@debit                                
                                
UPDATE mUserCountryMapping SET AgentBalance=@AgencybalanceTotal FROM mUserCountryMapping uc                                
INNER JOIN tblBookMaster bm on bm.MainAgentId=uc.UserId                                
INNER JOIN mCountry mc on mc.CountryCode=bm.Country                        
WHERE uc.isActive=1 AND uc.UserId=@MainAgentId AND CountryId=@CountryID                                
                                
END                                
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_LCCCancellationPassengers] TO [rt_read]
    AS [dbo];

