CREATE PROC sp_ChangeAPIMasterAvailability        
 @Id INT     
 ,@APIKey varchar(200)    
 ,@Availability INT        
 ,@IsInternal BIT        
 ,@UpdatedBy INT=0        
AS        
BEGIN        
 SET NOCOUNT ON;        
        
 IF(@IsInternal=1) and (@Availability = 0)   
   
 BEGIN        
        
  INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Availability,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Availability,InsertedDate,@UpdatedBy,GETDATE(),1 from APIAuthenticationMaster_Internal        
  WHERE ID=@Id        
          
  UPDATE APIAuthenticationMaster_Internal SET        
  Availability=@Availability,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey      
    
  UPDATE APIAuthenticationMaster SET        
  Availability=@Availability,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey    
          
 END        
IF (@IsInternal=1) and (@Availability = 1)         
 BEGIN        
          
  INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Availability,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Availability,InsertedDate,@UpdatedBy,GETDATE(),0 from APIAuthenticationMaster        
  WHERE ID=@Id   
    
    UPDATE APIAuthenticationMaster_Internal SET        
  Availability=@Availability,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey      
        
     
 END     
 IF (@IsInternal=0)  
 BEGIN  
   INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Availability,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Availability,InsertedDate,@UpdatedBy,GETDATE(),0 from APIAuthenticationMaster        
  WHERE ID=@Id   
   
  UPDATE APIAuthenticationMaster SET        
  Availability=@Availability,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey     
END  
End

