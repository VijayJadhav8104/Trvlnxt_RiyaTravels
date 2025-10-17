CREATE PROCEDURE [SS].[SSUpdateCheckBalance]     
 @UserId    int,           
 @Balance   decimal(18,2),           
 @TransactionType varchar(10),           
 @AgentNo   int,           
 @BookingRef varchar(50)= null   
AS BEGIN  
          
 Declare @Amt decimal(18,2)=0                
 declare @Parentid INT;            
 declare @ModelID varchar(max);  
            
 SELECT @Parentid = ParentAgentID FROM AgentLogin with (nolock) WHERE UserID = @UserId            
            
 IF (@Parentid IS NOT NULL)            
 BEGIN            
  SELECT @Amt = AgentBalance FROM AgentLogin with (nolock) WHERE UserID = @Parentid            
            
  SET @AgentNo = @Parentid  
 END            
 ELSE            
 BEGIN            
  SELECT @Amt = AgentBalance FROM AgentLogin with (nolock) WHERE UserID = @UserId  
 END            
            
 --Below If condition added on 07-01-2022      
 IF(@AgentNo=0 OR @AgentNo IS NULL )      
 BEGIN      
  select @AgentNo = AgentID from SS.SS_BookingMaster with (nolock) where BookingRefId=@BookingRef  
 END      
      
 IF (@TransactionType = 'Debit')            
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
   
  SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'-'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);  
  
  insert into ExceptionLog(ErrorProcedure,ErrorNumber) values(@ModelID,@AgentNo)  
            
  -- BUGFIX: Added ISNULL by hardik for solve DBNULL bug 09.10.2023  
  SELECT ISNULL(AgentBalance,0) AS AgentBalance FROM AgentLogin with (nolock) WHERE UserID = @UserId      
 END            
          
 IF (@TransactionType = 'Credit')            
 BEGIN            
  UPDATE tblAgentBalance SET IsActive = 0 WHERE AgentNo = @AgentNo AND IsActive = 1            
            
  INSERT INTO tblAgentBalance (AgentNo            
  ,OpenBalance            
  ,TranscationAmount            
  ,CloseBalance            
  ,IsActive            
  ,TransactionType            
  ,BookingRef          
  ,CreatedBy          
  ,Remark)            
  VALUES (@AgentNo            
  ,@Amt            
  ,@Balance            
  ,(@Amt + @Balance)            
  ,1            
  ,@TransactionType            
  ,@BookingRef            
  ,@AgentNo          
  ,'payment recieved')            
           
  UPDATE AgentLogin SET AgentBalance = (@Amt + @Balance) WHERE UserID = @AgentNo      
   
  SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'+'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@AgentNo as varchar);  
  
  insert into ExceptionLog(ErrorProcedure,ErrorNumber) values(@ModelID,@AgentNo)  
          
 
  SELECT ISNULL(AgentBalance,0) AS AgentBalance FROM AgentLogin with (nolock) WHERE UserID = @UserId      
 END        
   
END