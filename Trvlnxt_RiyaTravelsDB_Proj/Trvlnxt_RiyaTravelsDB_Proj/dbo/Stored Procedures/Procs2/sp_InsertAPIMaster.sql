CREATE PROC sp_InsertAPIMaster  
 @APIKey VARCHAR(MAX)  
 ,@IPAddress VARCHAR(MAX)  
 ,@AgentID INT=0  
 ,@IsInternal BIT  
 ,@CreatedBy INT=0   
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 IF(@IsInternal=1)  
 BEGIN  
  INSERT INTO APIAuthenticationMaster_Internal    
  (APIKey,IPAddress,AgentID,InsertedDate,Status,Availability,Sell,Booking,AllBlock,CreatedBy)    
  VALUES    
  (@APIKey,@IPAddress,@AgentID,GETDATE(),1,1,1,1,1,@CreatedBy)  
 END  
 ELSE  
 BEGIN  
  INSERT INTO APIAuthenticationMaster    
  (APIKey,IPAddress,AgentID,InsertedDate,Status,Availability,Sell,Booking,AllBlock,CreatedBy)    
  VALUES    
  (@APIKey,@IPAddress,@AgentID,GETDATE(),1,1,1,1,1,@CreatedBy) 
 END  
END  