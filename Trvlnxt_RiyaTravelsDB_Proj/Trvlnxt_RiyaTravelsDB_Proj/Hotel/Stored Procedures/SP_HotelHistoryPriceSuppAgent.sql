CREATE PROCEDURE [hotel].SP_HotelHistoryPriceSuppAgent                                    
  @UpdatedBy INT                                    
 ,@AgentId INT                                    
 ,@ProfileId INT                                    
 ,@SupplierId INT                                    
    
AS                                    
BEGIN                                    
                                  
 IF NOT EXISTS(SELECT * FROM HistorySuppAgentProfileMapper WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                    
  BEGIN                                    
   INSERT INTO HistorySuppAgentProfileMapper (SupplierId, AgentId,ProfileId,CreatedBy,CreatedOn)                                    
   VALUES (@SupplierId,@AgentId,@ProfileId,@UpdatedBy,GETDATE())                                    
                                    
   SELECT SCOPE_IDENTITY();                                    
  END                                    
 ELSE IF EXISTS(SELECT * FROM HistorySuppAgentProfileMapper WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                    
  BEGIN                                    
   UPDATE HistorySuppAgentProfileMapper SET SupplierId=@SupplierId,AgentId=@AgentId,ProfileId=@ProfileId,ModifiedBy=@UpdatedBy,ModifiedOn=GETDATE()                   
                       
   WHERE AgentId=@AgentId AND SupplierId=@SupplierId                                
                                      
  END                                    
 END                                       
          