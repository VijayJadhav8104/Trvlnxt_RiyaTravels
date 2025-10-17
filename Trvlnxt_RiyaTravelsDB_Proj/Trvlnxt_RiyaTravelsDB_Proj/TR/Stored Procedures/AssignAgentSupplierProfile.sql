    
 CREATE PROCEDURE TR.AssignAgentSupplierProfile                                                
   @Id INT                                                
  ,@AgentId INT                                                
  ,@ProfileId INT                                                
  ,@SupplierId INT                                                
  ,@CancellationHours INT                                         
  ,@PriceOpti nvarchar(200)=null                                              
  ,@IsActive BIT                                                
  ,@CorporateCode varchar(100)=null                        
  ,@ServicePercent float=null                      
  ,@ServiceCharge float=null   
  ,@ServiceChargeAmt float=null  
  ,@GSTOnServiceCharge float=null                                  
  ,@RateCode varchar(max)=null                                
  ,@OfficeID varchar(100)=null                    
                            
 AS                                                
 BEGIN                                                
  IF (@IsActive=1)                                                
  BEGIN                                                
  IF NOT EXISTS(SELECT * FROM [TR].[Transfer_AgentSupplierProfileMapper] WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                                
   BEGIN                                                
    INSERT INTO [TR].[Transfer_AgentSupplierProfileMapper] (AgentId ,SupplierId,ProfileId ,CancellationHours,PriceOptimizationOn,CorporateCode,ServicePercent,ServiceCharge,ServiceChargeAmt,GSTOnServiceCharge,CreateDate,RateCode,PCC,Isactive)                         
                   
    
      
    VALUES (@AgentId,@SupplierId,@ProfileId ,@CancellationHours,@PriceOpti,@CorporateCode,@ServicePercent,@ServiceCharge,@ServiceChargeAmt,@GSTOnServiceCharge,getdate(),@RateCode,@OfficeID,1)                                                
                                                
    SELECT SCOPE_IDENTITY();                                                
   END                                                
  ELSE IF EXISTS(SELECT * FROM [TR].[Transfer_AgentSupplierProfileMapper] WHERE Id=@Id)                                                
   BEGIN                                                
    UPDATE [TR].[Transfer_AgentSupplierProfileMapper] SET ProfileId=@ProfileId, CancellationHours=@CancellationHours,                                        
  IsActive=@IsActive,PriceOptimizationOn=@PriceOpti,CorporateCode=@CorporateCode,ServicePercent=cast(@ServicePercent as decimal(10,2)),                                 
  ServiceCharge=cast(@ServiceCharge as decimal(10,2)),ServiceChargeAmt=cast(@ServiceChargeAmt as decimal(10,2)),GSTOnServiceCharge=cast(@GSTOnServiceCharge as decimal(18,2)),RateCode=@RateCode ,ModifiedDate=GetDate(), PCC=@OfficeID                        
         
    WHERE Id=@Id                                                
    SELECT @Id                                                
   END                                                
  END                                                
  ELSE IF (@IsActive=0)                                                
  BEGIN                                                
   IF EXISTS(SELECT * FROM [TR].[Transfer_AgentSupplierProfileMapper] WHERE Id=@Id)                                                
   BEGIN                                                
    UPDATE [TR].[Transfer_AgentSupplierProfileMapper] SET IsActive=@IsActive ,ProfileId=0,CancellationHours=null,ServicePercent=null, ServiceCharge=null,ServiceChargeAmt=null,GSTOnServiceCharge=null WHERE Id=@Id                                            
    
    SELECT @Id                                                
   END                                                
  END                                           
  END 