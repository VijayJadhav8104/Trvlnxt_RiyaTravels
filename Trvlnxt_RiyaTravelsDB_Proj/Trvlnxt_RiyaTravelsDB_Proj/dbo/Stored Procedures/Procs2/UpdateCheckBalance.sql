---UpdateCheckBalance 51379,'1728.98','Debit',51379,'TNH20250703131712268'
CREATE PROCEDURE UpdateCheckBalance                   
 @UserId    int,                           
 @Balance   decimal(18,2),                           
 @TransactionType varchar(10),                           
 @AgentNo   int,                           
 @BookingRef varchar(50)= null                   
AS BEGIN                  
              
 Begin Tran        
 Declare @Amt decimal(18,2)=0                                
 declare @Parentid INT;                            
 declare @ModelID varchar(max);                  
 DECLARE @TransactionPkId INT                   
 DECLARE @BookingStatus VARCHAR(50)       
 Declare @CheckDebitEntry varchar(100)=''      
 Declare @CheckCreditEntry varchar(100)=''      
                            
 --SELECT @Parentid = ParentAgentID FROM AgentLogin with (nolock) WHERE UserID = @UserId           
 SELECT @Parentid = ParentAgentID FROM AgentLogin  WHERE UserID = @UserId            
                            
 IF (@Parentid IS NOT NULL)                            
 BEGIN                            
  SELECT @Amt = AgentBalance FROM AgentLogin with (XLOCK) WHERE UserID = @Parentid                            
                            
  SET @AgentNo = @Parentid                  
 END                            
 ELSE                            
 BEGIN                            
  SELECT @Amt = AgentBalance FROM AgentLogin with (XLOCK) WHERE UserID = @UserId                  
 END                            
                            
 --Below If condition added on 07-01-2022                      
 IF(@AgentNo=0 OR @AgentNo IS NULL )                      
 BEGIN                      
  select @AgentNo = AgentID from tblBookMaster with (nolock) where orderId=@BookingRef                  
 END                      
  
   IF (@Amt<@Balance and @TransactionType = 'Debit')  
 BEGIN  
  SELECT 1.11 AS AgentBalance  FROM AgentLogin  WITH (XLOCK)  WHERE UserID = @UserId  
 END  
 ELSE  
 BEGIN  
	IF (@TransactionType = 'Debit' and @Balance !=0 and @Amt > 0)                            
	BEGIN           
		Select  @CheckDebitEntry=TransactionType from  tblAgentBalance  where BookingRef=@BookingRef and AgentNo=@AgentNo and TransactionType='Debit'       
		if(@CheckDebitEntry='' or @CheckDebitEntry is null)        
		BEGIN        
			UPDATE tblAgentBalance SET IsActive = 0 WHERE AgentNo = @AgentNo AND IsActive = 1                                              
			INSERT INTO tblAgentBalance (AgentNo                            
			,OpenBalance                            
			,TranscationAmount                            
			,CloseBalance                            
			,IsActive                            
			,TransactionType                            
			,BookingRef)                            
			VALUES (@AgentNo                            
			,@Amt                            
			,@Balance                            
			,(@Amt - @Balance)                            
			,1                            
			,@TransactionType                            
			,@BookingRef)                            

			UPDATE AgentLogin SET AgentBalance = (@Amt - @Balance) WHERE UserID = @AgentNo                     
                  
			SELECT @TransactionPkId= SCOPE_IDENTITY()                  
			SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM Hotel_Status_History HSH JOIN Hotel_BookMaster BM ON BM.pkId=HSH.FKHotelBookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE orderId=@BookingRef ORDER BY HSH.CreateDate DESC      
 
			if(@BookingRef Like 'TNA%')               
				BEGIN              
					SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM SS.SS_Status_History HSH JOIN SS.SS_BookingMaster BM ON BM.BookingId=HSH.BookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE BM.BookingRefId=@BookingRef ORDER BY HSH.CreateDate   DESC                  
				END              
			INSERT INTO hotel.Agentbalance_StatusLog(FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)                
                   
			SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'-'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);                  
                  
			insert into ExceptionLog(ErrorMessage,ErrorProcedure,ErrorNumber) values(@BookingRef,@ModelID,@AgentNo)                  
            -- BUGFIX: Added ISNULL by hardik for solve DBNULL bug 09.10.2023                  
			SELECT ISNULL(AgentBalance,0) AS AgentBalance FROM AgentLogin with (XLOCK) WHERE UserID = @UserId                      
		END       
	END      
                          
	IF (@TransactionType = 'Credit')                            
	BEGIN      
		Select  @CheckCreditEntry=TransactionType from  tblAgentBalance  where BookingRef=@BookingRef and AgentNo=@AgentNo and TransactionType='Credit'        
		if(@CheckCreditEntry='' or @CheckCreditEntry is null)      
		BEGIN      
			UPDATE tblAgentBalance SET IsActive = 0 WHERE AgentNo = @AgentNo AND IsActive = 1                                           
			INSERT INTO tblAgentBalance (AgentNo,OpenBalance,TranscationAmount,CloseBalance ,IsActive,TransactionType,BookingRef,CreatedBy,Remark)                            
			VALUES (@AgentNo,@Amt,@Balance,(@Amt + @Balance),1 ,@TransactionType,@BookingRef,@AgentNo,'payment recieved')                            
               
			UPDATE AgentLogin SET AgentBalance = (@Amt + @Balance) WHERE UserID = @AgentNo                      
                
			SELECT @TransactionPkId= SCOPE_IDENTITY()                  
			SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM Hotel_Status_History HSH JOIN Hotel_BookMaster BM ON BM.pkId=HSH.FKHotelBookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE orderId=@BookingRef ORDER BY HSH.CreateDate DESC      

			if(@BookingRef Like 'TNA%')               
			BEGIN              
				SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM SS.SS_Status_History HSH JOIN SS.SS_BookingMaster BM ON BM.BookingId=HSH.BookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE BM.BookingRefId=@BookingRef ORDER BY HSH.CreateDate  DESC                  
			END             
			INSERT INTO hotel.Agentbalance_StatusLog(FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)                
                   
			SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'+'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);                  
                  
			insert into ExceptionLog(ErrorMessage,ErrorProcedure,ErrorNumber) values(@BookingRef,@ModelID,@AgentNo)                  
            -- BUGFIX: Added ISNULL by hardik for solve DBNULL bug 09.10.2023                  
			SELECT ISNULL(AgentBalance,0) AS AgentBalance FROM AgentLogin with (XLOCK) WHERE UserID = @UserId      
		END      
	END                        
	commit 
  END  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCheckBalance] TO [rt_read]
    AS [dbo];

