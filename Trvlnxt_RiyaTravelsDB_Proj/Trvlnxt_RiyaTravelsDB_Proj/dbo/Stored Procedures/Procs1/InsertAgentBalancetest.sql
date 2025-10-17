  
CREATE Proc [dbo].InsertAgentBalancetest  
 @AgentNo int=NULL,  
 @AgencyName varchar(800),  
 @PaymentMode varchar(20),  
 @BookingRef varchar(50),  
 @CloseBalance decimal(18,2),  
 @CreatedBy int,  
 @TransactionType varchar(10),  
 @Remark varchar(2000)=null,  
 @Reference varchar(50)=null,  
 @DueClear varchar(50)=null,  
 @DeadLineDate Datetime=null -- added by aman  
  
AS   
BEGIN  
 --Declare @Amt decimal(18,2) =0  
 Declare @Amt decimal(18,2) =0  
   
  IF EXISTS(SELECT 1 FROM tblAgentBalance where AgentNo=@AgentNo AND IsActive=1)  
  BEGIN  
  
   SELECT @Amt= ISNULL(AgentBalance,0) FROM AgentLogin where UserID=@AgentNo  
  
   UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1  
  
   IF(@TransactionType='Credit')  
   BEGIN  
   --UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1 -- added by asmi  
    INSERT INTO tblAgentBalance(AgentNo,PaymentMode,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,IsActive,TransactionType,Remark,Reference,DueClear,DeadlineDate)   
    VALUES (@AgentNo,@PaymentMode,@BookingRef,@Amt,@CloseBalance,(@Amt+@CloseBalance),@CreatedBy,1,@TransactionType,@Remark,@Reference,@DueClear,@DeadLineDate)  
  
    UPDATE AgentLogin SET AgentBalance=(@Amt+@CloseBalance) WHERE UserID=@AgentNo   
   END  
   ELSE  
   BEGIN  
   --IF(@Amt>=@CloseBalance) -- ADDED BY ASMI  
   --BEGIN  
   --UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1 -- added by asmi  
    INSERT INTO tblAgentBalance(AgentNo,PaymentMode,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,IsActive,TransactionType,Remark,Reference,DueClear,DeadLineDate)   
    VALUES (@AgentNo,@PaymentMode,@BookingRef,@Amt,@CloseBalance,(@Amt-@CloseBalance),@CreatedBy,1,@TransactionType,@Remark,@Reference,@DueClear,@DeadLineDate)  
  
    UPDATE AgentLogin SET AgentBalance=(@Amt-@CloseBalance) WHERE UserID=@AgentNo  
    --END  
   END  
  
   select SCOPE_IDENTITY();  
  END  
  ELSE  
  BEGIN  
   SELECT @Amt= ISNULL(AgentBalance,0) FROM AgentLogin where UserID= @AgentNo  
  
     
   UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1  
   IF(@TransactionType='Credit')  
   begin  
   --UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1 -- added by asmi  
    INSERT INTO tblAgentBalance(AgentNo,PaymentMode,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,IsActive,TransactionType,Remark,Reference,DueClear,DeadLineDate)   
    VALUES (@AgentNo,@PaymentMode,@BookingRef,@Amt,@CloseBalance,(@Amt+@CloseBalance),@CreatedBy,1,@TransactionType,@Remark,@Reference,@DueClear,@DeadLineDate)  
  
    UPDATE AgentLogin   
    SET AgentBalance=(@Amt+@CloseBalance)   
    WHERE UserID=@AgentNo  
   end  
   ELSE  
   BEGIN  
   --IF(@Amt>=@CloseBalance) -- ADDED BY ASMI  
   --BEGIN  
   UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1 -- added by asmi  
    INSERT INTO tblAgentBalance(AgentNo,PaymentMode,BookingRef,OpenBalance,TranscationAmount,CloseBalance,CreatedBy,IsActive,TransactionType,Remark,Reference,DueClear,DeadLineDate)   
    VALUES (@AgentNo,@PaymentMode,@BookingRef,@Amt,@CloseBalance,(@Amt-@CloseBalance),@CreatedBy,1,@TransactionType,@Remark,@Reference,@DueClear,@DeadLineDate)  
      
    UPDATE AgentLogin   
    SET AgentBalance=(@Amt-@CloseBalance)   
    WHERE UserID=@AgentNo  
    --END  
   END  
   select SCOPE_IDENTITY();  
  END  
  
END