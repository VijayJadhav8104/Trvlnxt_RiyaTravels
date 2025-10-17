CREATE PROCEDURE [Hotel].[Api_UpdateCheckBalance]                                             
                                                    
@UserId    int,                                                   
@Balance   decimal(18,2),                                                   
@TransactionType varchar(10),                                                   
@AgentNo   int,                                                   
@OrderId varchar(50)= null,            
@Amt decimal(18,2)=0               
AS                               
BEGIN                                                       
                          
--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;                              
BEGIN TRAN                               
                                                  
--Declare @Amt decimal(18,2)=0                                                        
declare @Parentid INT;                                                    
declare @ModelID varchar(max);                        
DECLARE @TransactionPkId INT                   
DECLARE @BookingStatus VARCHAR(50)                  
                                                    
SELECT @Parentid = ParentAgentID                                                    
FROM AgentLogin                                                   
WHERE UserID = @UserId                                                    
                                                    
IF (@Parentid IS NOT NULL)                                                    
BEGIN                                                    
 SELECT @Amt = AgentBalance                                                    
 FROM AgentLogin WITH (XLOCK/*,READPAST*/)                                                   
 WHERE UserID = @Parentid                                                    
                                                    
 SET @AgentNo = @Parentid                                                    
END                                                    
ELSE                                                    
BEGIN                                                    
 SELECT @Amt = AgentBalance                                                    
 FROM AgentLogin WITH (XLOCK/*,READPAST*/)                                                   
 WHERE UserID = @UserId                                                    
END                                                    
                
IF (@Amt<@Balance)                 
BEGIN                
  SELECT 1.11 AS AgentBalance                                               
  FROM AgentLogin  WITH (XLOCK/*,READPAST*/)                                                  
  WHERE UserID = @UserId                  
END                
ELSE                
BEGIN                
--Below If condition added on 07-01-2022                                              
IF(@AgentNo=0 OR @AgentNo IS NULL )                                              
BEGIN                                              
 select @AgentNo = AgentID from tblBookMaster where orderId=@OrderId                                              
END                                              
                                              
IF (@TransactionType = 'Debit')                                                    
BEGIN                                                    
                                            
 UPDATE tblAgentBalance                                                    
 SET IsActive = 0                                                    
 WHERE AgentNo = @AgentNo                                                    
  AND IsActive = 1                                                    
                                                    
 INSERT INTO tblAgentBalance (                                                    
  AgentNo                                                    
  ,OpenBalance                                                    
  ,TranscationAmount                                                    
  ,CloseBalance                                                    
  ,IsActive                                                    
  ,TransactionType                                                    
  ,BookingRef             
  )                                                    
 VALUES (                                                    
  @AgentNo                                              
  ,@Amt                                                    
  ,@Balance                                                      
  ,(@Amt - @Balance)                                                    
  ,1                                                    
  ,@TransactionType                                 
  ,@OrderId                                                    
  )                                                    
                                                
 UPDATE AgentLogin                                                    
 SET AgentBalance = (@Amt - @Balance)                       
 WHERE UserID = @AgentNo                                                   
                                           
 SELECT @TransactionPkId= SCOPE_IDENTITY()                  
 SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM Hotel_Status_History HSH JOIN Hotel_BookMaster BM ON BM.pkId=HSH.FKHotelBookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE orderId=@OrderId ORDER BY HSH.CreateDate DESC          
  
   
      
         
 INSERT INTO hotel.Agentbalance_StatusLog(FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)                                           
                                           
 SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'-'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);                                              
                                              
 insert into ExceptionLog(ErrorMessage,ErrorProcedure,ErrorNumber) values(@OrderId,@ModelID,@AgentNo)                                                        
                                          
                                                    
 SELECT AgentBalance                                               
 FROM AgentLogin  WITH (XLOCK/*,READPAST*/)                                                  
 WHERE UserID = @UserId                                              
                                            
                                            
                                             
END                                                    
                                                  
IF (@TransactionType = 'Credit')                                                    
BEGIN                              
                        
  --added for cancellation of previous month booking tds deduction                                  
 declare @tds decimal = (select                                   
                             case                                   
        when ((month(inserteddate) < month(getdate())) and (year(inserteddate) < year(getdate()))) OR (year(inserteddate) < year(getdate()))  then sum(isnull(B2BHotel_Commission.tds,0))                                   
        else 0                                   
        end                                     
 from hotel_bookmaster left join B2BHotel_Commission on hotel_bookmaster.pkId=B2BHotel_Commission.Fk_BookId where orderId=@OrderId group by inserteddate)                       
                      
 if (@tds is null)                       
 begin                         
 set @tds=0.0                      
 end                      
                                    
 set @Balance= @Balance-@tds                      
                      
 update hotel_bookmaster set TdsDeductedAfterCancel=@tds where orderId=@OrderId                             
                                    
 UPDATE tblAgentBalance                                                    
 SET IsActive = 0                                       
 WHERE AgentNo = @AgentNo                                         
  AND IsActive = 1                                                    
                                                    
 INSERT INTO tblAgentBalance (                                                   
  AgentNo                                               
  ,OpenBalance                                                    
  ,TranscationAmount                                                
  ,CloseBalance                                                    
  ,IsActive                                                    
  ,TransactionType                                                    
  ,BookingRef                                          
  ,CreatedBy                                                  
  ,Remark                                                  
  )                                                    
 VALUES (                                                    
  @AgentNo                                 
  ,@Amt                                                    
  ,@Balance                                                    
  ,(@Amt + @Balance)                                                    
  ,1                                     
  ,@TransactionType                                
  ,@OrderId                                                    
  ,@AgentNo                                                  
  ,'payment recieved'                                                  
  )                                                       
                           
 UPDATE AgentLogin                                                    
 SET AgentBalance = (@Amt + @Balance)                                                    
 WHERE UserID = @AgentNo                                    
                  
 SELECT @TransactionPkId= SCOPE_IDENTITY()                  
 SELECT TOP 1 @BookingStatus= ISNULL(HSM.Status,'') FROM Hotel_Status_History HSH JOIN Hotel_BookMaster BM ON BM.pkId=HSH.FKHotelBookingId JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id  WHERE orderId=@OrderId ORDER BY HSH.CreateDate DESC         
  
    
      
        
         
 INSERT INTO hotel.Agentbalance_StatusLog(FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)                
                 
 SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'+'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);                                              
                                              
 insert into ExceptionLog(ErrorMessage,ErrorProcedure,ErrorNumber) values(@OrderId,@ModelID,@AgentNo)                                                                    
                                                                           
 SELECT AgentBalance                                                  
 FROM AgentLogin  WITH (XLOCK/*,READPAST*/)                                                  
 WHERE UserID = @UserId                                              
                                            
                                             
                                            
END                                                    
                                
  COMMIT                              
END                              
 END                                                                                        
                
--select icast,FKUserID,AgencyName  from B2BRegistration where icast ='900'--Akash IN                
--NewGetPricingProfileDetailsByAgentId_ApiOut 51465,'IN'                
--select agentbalance,* from agentlogin where userid=51354                
--update agentlogin set agentbalance=agentbalance+1 where userid=51465 --0.00                
--update agentlogin set agentbalance=-1 where userid=51465 --0.00            
--select * from tblAgentBalance where BookingRef='TNHAPI00003637202408'--999231456.54