        
                    
                
                
CREATE PROCEDURE AssignAgentSupplierProfilebkp_24_06_25                                      
  @Id INT                                      
 ,@AgentId INT                                      
 ,@ProfileId INT                                      
 ,@SupplierId INT                                      
 ,@CancellationHours INT                               
 ,@PriceOpti nvarchar(200)=null                                    
 ,@IsActive BIT                                      
 ,@CorporateCode varchar(100)=null              
 ,@ServicePercent float=null            
 ,@ServiceCharge float=null       ----new changes  
   ,@ServiceChargeAmt float=null   ---add amol c  
 ,@GSTOnServiceCharge float=null   ---new changes                        
 ,@RateCode varchar(max)=null       --new changes                
 ,@OfficeID varchar(100)=null          
                  
AS                                      
BEGIN                                      
 IF (@IsActive=1)                                      
 BEGIN                                      
 IF NOT EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                      
  BEGIN                                      
   INSERT INTO agentsupplierprofilemapper (AgentId ,SupplierId,ProfileId ,CancellationHours,PriceOptimizationOn,CorporateCode,ServicePercent,ServiceCharge,ServiceChargeAmt,GSTOnServiceCharge,RateCode,PCC)                                      
   VALUES (@AgentId,@SupplierId,@ProfileId ,@CancellationHours,@PriceOpti,@CorporateCode,@ServicePercent,@ServiceCharge,@ServiceChargeAmt,@GSTOnServiceCharge,@RateCode,@OfficeID)                                      
                                      
   SELECT SCOPE_IDENTITY();                                      
  END                                      
 ELSE IF EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE Id=@Id)                                      
  BEGIN                                      
   UPDATE agentsupplierprofilemapper SET ProfileId=@ProfileId, CancellationHours=@CancellationHours,                              
 IsActive=@IsActive,PriceOptimizationOn=@PriceOpti,CorporateCode=@CorporateCode,ServicePercent=cast(@ServicePercent as decimal(10,2)),                       
 ServiceCharge=cast(@ServiceCharge as decimal(10,2)),ServiceChargeAmt=cast(@ServiceChargeAmt as decimal(10,2)),GSTOnServiceCharge=cast(@GSTOnServiceCharge as decimal(18,2)),RateCode=@RateCode ,PCC=@OfficeID                       
   WHERE Id=@Id                                      
   SELECT @Id                                      
  END                                      
 END                                      
 ELSE IF (@IsActive=0)                                      
 BEGIN                                      
  IF EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE Id=@Id)                                      
  BEGIN                                      
   UPDATE agentsupplierprofilemapper SET IsActive=@IsActive ,ProfileId=0,CancellationHours=null,ServicePercent=null, ServiceCharge=null,ServiceChargeAmt=null,GSTOnServiceCharge=null WHERE Id=@Id                                      
   SELECT @Id                                      
  END                                      
 END                                 
 END