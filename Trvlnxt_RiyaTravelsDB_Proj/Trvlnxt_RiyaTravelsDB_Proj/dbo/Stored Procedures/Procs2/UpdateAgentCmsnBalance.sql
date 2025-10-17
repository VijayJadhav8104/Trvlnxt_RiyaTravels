--Sp_helptext updateagentcmsnbalance

CREATE PROCEDURE [dbo].[UpdateAgentCmsnBalance] -- [UpdateCheckBalance] 51354,100,'Debit',51354                    
                  
@UserId    int,                 
@Balance   decimal(18,2),                 
@TransactionType varchar(10),                 
@AgentNo   int,                 
@BookingRef varchar(50)= null,              
@CreatedBy int=null ,             
@ActualCmsnReceived decimal(18,2)= null,            
@pkid int = null,     
@Remark varchar(200)= null    
            
AS  BEGIN                     
Declare @Amt decimal(18,2)=0                      
declare @Parentid INT;                  
                  
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
          
             
IF (@TransactionType = 'Credit')                  
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
  ,@BookingRef                  
  ,@AgentNo                
  ,'payment recieved'                
  )                  
                  
                
 UPDATE AgentLogin                  
 SET AgentBalance = (@Amt + @Balance)                  
 WHERE UserID = @AgentNo               
             
            
            
 update B2BHotel_Commission set [Actual Commission Received]=@ActualCmsnReceived            
 WHERE Fk_BookId =@pkid      
    
    
  update Hotel_BookMaster set ClosedRemark=@Remark,PayHotelPaymentStatus=1 where pkId=@pkid    
     
 
                  
 SELECT AgentBalance                  
 FROM AgentLogin                  
 WHERE UserID = @UserId                  
END                  
                
 END                  
