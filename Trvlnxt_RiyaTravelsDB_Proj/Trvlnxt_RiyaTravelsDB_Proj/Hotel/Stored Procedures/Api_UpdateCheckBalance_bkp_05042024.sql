    
    
          
                   
CREATE PROCEDURE [Hotel].[Api_UpdateCheckBalance_bkp_05042024]                 
                        
@UserId    int,                       
@Balance   decimal(18,2),                       
@TransactionType varchar(10),                       
@AgentNo   int,                       
@OrderId varchar(50)= null AS  BEGIN                           
                      
Declare @Amt decimal(18,2)=0                            
declare @Parentid INT;                        
declare @ModelID varchar(max);              
                        
SELECT @Parentid = ParentAgentID                        
FROM AgentLogin                        
WHERE UserID = @UserId                        
                        
IF (@Parentid IS NOT NULL)                        
BEGIN                        
 SELECT @Amt = AgentBalance                        
 FROM AgentLogin                        
 WHERE UserID = @Parentid                        
                        
 SET @AgentNo = @Parentid                        
END                        
ELSE                        
BEGIN                        
 SELECT @Amt = AgentBalance                        
 FROM AgentLogin                        
 WHERE UserID = @UserId                        
END                        
                        
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
               
              
               
 SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'-'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);              
              
 insert into ExceptionLog(ErrorProcedure,ErrorNumber) values(@ModelID,@AgentNo)              
              
                        
 SELECT AgentBalance                   
 FROM AgentLogin                        
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
        
 set @balance= @Balance-@tds              
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
               
              
                
 SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'+'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);              
              
 insert into ExceptionLog(ErrorProcedure,ErrorNumber) values(@ModelID,@AgentNo)              
              
                      
 SELECT AgentBalance                        
 FROM AgentLogin                        
 WHERE UserID = @UserId                  
                
                 
                
END                        
                      
 END                        
                        
                        
                        
                        
--Alter PROCEDURE [dbo].[UpdateCheckBalance] --[UpdateCheckBalance] 51354,9117,'Debit',51354 @UserId    int, @Balance   decimal(18,2), @TransactionType varchar(10), @AgentNo   int, @BookingRef varchar(50)= null AS  BEGIN     Declare @Amt decimal(18,2)=0  
 
    
      
         
          
            
              
                
                  
                    
                       
--declare @Parentid int  SELECT @Parentid= ParentAgentID FROM AgentLogin where UserID=@UserId    if(@Parentid is not null)  begin  SELECT @Amt= AgentBalance FROM AgentLogin where UserID=@Parentid   set @AgentNo=@Parentid  end  else  begin  SELECT @Amt= Ag
  
    
      
        
          
            
              
                
                  
                    
                      
--Balance FROM AgentLogin                           
-- where UserID=@UserId   end   IF (@TransactionType='Debit')  BEGIN   UPDATE tblAgentBalance SET IsActive=0 WHERE AgentNo=@AgentNo AND IsActive=1    INSERT INTO tblAgentBalance(AgentNo,OpenBalance,TranscationAmount,CloseBalance,IsActive,TransactionType,B
  
    
      
        
          
            
              
                
                  
                    
                      
--kingRef)    VALUES (@AgentNo,@Amt,@Balance,(@Amt-@Balance),1,@TransactionType,@BookingRef)    UPDATE AgentLogin SET AgentBalance=(@Amt-@Balance) WHERE UserID=@AgentNo   SELECT AgentBalance FROM AgentLogin where UserID=@UserId   END   END 