CREATE PROCEDURE [dbo].[API_CancellationPenalty]--  'test', 16500,6000,4500,0,'TRN3S0W2H3',1                                
@RemarkCancellation varchar(max)='',                                      
@CancellationPenalty decimal(18,4)=0,      
@ADTPenalty decimal(18,4)=0,           
@CHDPenalty decimal(18,4)=0,      
@INFPenalty decimal(18,4)=0,      
@RiyaPNR varchar(10)=null,      
@IsPaxWisePenalty int = 0      
      
AS                                         
BEGIN                                                                       
                                      
DECLARE @PaymentMode VARCHAR(20),@Total decimal(18,4)=0,@countrycode varchar(20) ,@paxcount int=0 ,@debit decimal(18,4) = 0,@SSRTotal decimal(18,4)=0,@PerPassPenalty decimal(18,4)=0       
       
SET @PaymentMode=(SELECT TOP 1 payment_mode FROM Paymentmaster WHERE order_id=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))                                        
               
SET @Total =(SELECT sum(convert(decimal(18,2),totalFare)) FROM tblBookMaster WHERE  riyaPNR=@RiyaPNR)      
   if exists ( SELECT * FROM tblSSRDetails WHERE  fkBookMaster IN (SELECT pkid FROM tblBookMaster WHERE  riyaPNR=@RiyaPNR))    
   begin    
  SET @SSRTotal +=(SELECT sum(convert(decimal(18,2),SSR_Amount)) FROM tblSSRDetails WHERE  fkBookMaster IN (SELECT pkid FROM tblBookMaster WHERE  riyaPNR=@RiyaPNR))      
   end    
SET @Total +=@SSRTotal       
      
SET @countrycode=(SELECT TOP 1 currency FROM Paymentmaster WHERE order_id=(SELECT TOP 1 orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))      
      
if @CancellationPenalty > 0                              
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
       
if @IsPaxWisePenalty = 1      
begin      
      
 UPDATE tblPassengerBookDetails SET       
 RemarkCancellation =@RemarkCancellation,RemarkCancellation2=@RemarkCancellation,CancellationPenalty=@ADTPenalty,                                        
 --Debit=@debit,                                        
 BookingStatus=11, cancellationDate=GETDATE(),CancelledDate=GETDATE(),TobecancellationDate=GETDATE(),                                  
 CancelByAgency=@AgentId,CancelByAgency1=@AgentId,CancelByBackendUser1= (case when @MainAgentId > 0 then @MainAgentId else @AgentId end)                                        
 WHERE pid IN (select pid From tblPassengerBookDetails       
 where fkBookMaster in (select pkId from tblBookMaster where riyapnr = @RiyaPNR and paxType= 'adult' and totalFare > 0))        
                         
 if exists (select count(*) From tblPassengerBookDetails where fkBookMaster       
  in (select pkId from tblBookMaster where riyapnr = @RiyaPNR and paxType= 'child' and isReturn = 0))                     
 begin                          
   UPDATE tblPassengerBookDetails SET       
  RemarkCancellation =@RemarkCancellation,RemarkCancellation2=@RemarkCancellation,CancellationPenalty=@CHDPenalty,                                        
  --Debit=@debit,                                        
  BookingStatus=11, cancellationDate=GETDATE(),CancelledDate=GETDATE(),TobecancellationDate=GETDATE(),                                  
  CancelByAgency=@AgentId,CancelByAgency1=@AgentId,CancelByBackendUser1= (case when @MainAgentId > 0 then @MainAgentId else @AgentId end)                                        
  WHERE pid IN (select pid From tblPassengerBookDetails       
  where fkBookMaster in (select pkId from tblBookMaster where riyapnr = @RiyaPNR and paxType= 'child' and totalFare > 0))        
 end        
 if exists (select count(*) From tblPassengerBookDetails where fkBookMaster       
  in (select pkId from tblBookMaster where riyapnr = @RiyaPNR and paxType= 'infant' and isReturn = 0))                   
 begin                          
   UPDATE tblPassengerBookDetails SET       
  RemarkCancellation =@RemarkCancellation,RemarkCancellation2=@RemarkCancellation,CancellationPenalty=@INFPenalty,                                        
  --Debit=@debit,                                        
  BookingStatus=11, cancellationDate=GETDATE(),CancelledDate=GETDATE(),TobecancellationDate=GETDATE(),                                  
  CancelByAgency=@AgentId,CancelByAgency1=@AgentId,CancelByBackendUser1= (case when @MainAgentId > 0 then @MainAgentId else @AgentId end)                                        
  WHERE pid IN (select pid From tblPassengerBookDetails       
  where fkBookMaster in (select pkId from tblBookMaster where riyapnr = @RiyaPNR and paxType= 'infant' and totalFare > 0))      
 end        
end      
else       
begin      
 set @paxcount=(SELECT COUNT(*) FROM tblPassengerBookDetails WHERE fkBookMaster IN (SELECT pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR))              
 set @PerPassPenalty = @CancellationPenalty / @paxcount      
      
 UPDATE tblPassengerBookDetails SET       
 RemarkCancellation =@RemarkCancellation,RemarkCancellation2=@RemarkCancellation,CancellationPenalty=@PerPassPenalty,                                        
 --Debit=@debit,                                        
 BookingStatus=11, cancellationDate=GETDATE(),CancelledDate=GETDATE(),TobecancellationDate=GETDATE(),                                  
 CancelByAgency=@AgentId,CancelByAgency1=@AgentId,CancelByBackendUser1= (case when @MainAgentId > 0 then @MainAgentId else @AgentId end)                                        
 WHERE pid IN (select pid From tblPassengerBookDetails       
 where fkBookMaster in (select pkId from tblBookMaster where riyapnr = @RiyaPNR)) and totalFare > 0      
end      
      
update tblBookMaster SET BookingStatus=11,canceledDate = GETDATE() WHERE riyaPNR=@RiyaPNR      
                   
update TRVLNXT_Tickets_ERPStatus SET BookingStatus=11,CancellationPenalty=@CancellationPenalty where riyaPNR=@RiyaPNR                          
             
IF(@PaymentMode='Check')                                         
BEGIN                                        
 DECLARE @AGENTBALANCE decimal(18,4)=0,@AgencybalanceTotalAgent decimal(18,4)=0                                        
 SET @AGENTBALANCE=(SELECT TOP 1 AgentBalance FROM AgentLogin WHERE UserID=@AgentID)                                        
 SET @AgencybalanceTotalAgent=@AGENTBALANCE+@debit                                        
                                        
 UPDATE AgentLogin SET AgentBalance=@AgencybalanceTotalAgent WHERE userid=@AgentID                                        
                                        
 DECLARE @OrderId VARCHAR(50)                                        
 SET @OrderId=(SELECT DISTINCT orderId FROM tblBookMaster WHERE riyaPNR=@RiyaPNR)                                        
                                        
 INSERT INTO tblAgentBalance (AgentNo,BookingRef,PaymentMode,OpenBalance,TranscationAmount,CloseBalance,CreatedOn,CreatedBy,IsActive,TransactionType,Remark,Reference)                                         
 VALUES (@AgentID,@OrderId,@PaymentMode,@AGENTBALANCE,@debit,@AgencybalanceTotalAgent, GETDATE(),@AgentID,1,'Credit',@RemarkCancellation,'null')                                         
END                                        
                                        
Else                                        
BEGIN                                        
 DECLARE @CountryID INT                                        
 DECLARE @Agencybalance decimal(18,4)=0                                        
 DECLARE @AgencybalanceTotal decimal(18,4)=0                                        
                                        
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