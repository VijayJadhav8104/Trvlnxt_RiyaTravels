CREATE PROC sp_ChangeAPIMasterBooking        
 @Id INT      
 ,@APIKey varchar(200)    
 ,@Booking INT        
 ,@IsInternal BIT        
 ,@UpdatedBy INT=0        
AS        
BEGIN        
 SET NOCOUNT ON;        
        
 IF(@IsInternal=1 and @Booking=0)        
 BEGIN        
        
  INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Booking,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Booking,InsertedDate,@UpdatedBy,GETDATE(),1 from APIAuthenticationMaster_Internal        
  WHERE ID=@Id        
          
  UPDATE APIAuthenticationMaster_Internal SET        
  Booking=@Booking,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey    
    
          
  UPDATE APIAuthenticationMaster SET        
  Booking=@Booking,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey     
          
 END        
  IF(@IsInternal=1 and @Booking=1)        
 BEGIN        
        
  INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Booking,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Booking,InsertedDate,@UpdatedBy,GETDATE(),1 from APIAuthenticationMaster_Internal        
  WHERE ID=@Id        
          
  UPDATE APIAuthenticationMaster_Internal SET        
  Booking=@Booking,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey    
    
          
 END     
   IF(@IsInternal=0)  
 BEGIN        
          
  INSERT INTO APIAuthenticationMasterHistory        
  (pkid,APIKey,IPAddress,AgentID,Booking,InsertedDate,UpdatedBy,UpdatedOn,IsInternal)        
  Select @Id,APIKey,IPAddress,AgentID,Booking,InsertedDate,@UpdatedBy,GETDATE(),0 from APIAuthenticationMaster        
  WHERE ID=@Id        
        
  UPDATE APIAuthenticationMaster SET        
  Booking=@Booking,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
  WHERE APIKey=@APIKey        
 END        
END      
      