CREATE PROC sp_ChangeAPIMasterAllBlock        
 @AllBlock INT          
 ,@UpdatedBy INT       
AS        
BEGIN    
if (@AllBlock=1)
Begin   
  INSERT INTO APIAuthenticationMasterHistory          
  (AllBlock,Inserteddate,CreatedBy) values (0,getdate(),@UpdatedBy)   
           
   UPDATE APIAuthenticationMaster SET        
  AllBlock=@AllBlock,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()        
      
 END    
 if (@AllBlock=0)  
 Begin  
  
  INSERT INTO APIAuthenticationMasterHistory          
  (AllBlock,Inserteddate,CreatedBy) values (1,getdate(),@UpdatedBy)   
           
   UPDATE APIAuthenticationMaster SET        
  AllBlock=@AllBlock,UpdatedBy=@UpdatedBy,UpdatedOn=GETDATE()   
  
 End  
 END

 