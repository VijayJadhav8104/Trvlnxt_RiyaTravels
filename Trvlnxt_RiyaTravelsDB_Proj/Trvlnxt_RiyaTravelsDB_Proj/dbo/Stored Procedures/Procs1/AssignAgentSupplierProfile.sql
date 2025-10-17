          
          --exec  AssignAgentSupplierProfile  '3256','2342',null,'11','1',null,'true',null,'1','1','1','Test,HCL,ZRM,ZRM ,ds,asa,sasaa,sS,WSW,SSD,AASD,DAD,DSD,DSA,TTD,FDS,HJDVSS,GSAASADA',null       
                  
                  
 CREATE prOCEDURE [dbo].[AssignAgentSupplierProfile]                                        
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
  ,@IsHold bit=0            
 AS                                        
 BEGIN      
     
 Declare @IsInternationalApplicable bit = 0    
 if(@ServiceChargeAmt > 0)    
 begin    
   set @IsInternationalApplicable=1    
 end    
    
    
  IF (@IsActive=1)                                          
  BEGIN                                          
  IF NOT EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                          
   BEGIN                                          
    INSERT INTO agentsupplierprofilemapper (AgentId ,SupplierId,ProfileId ,CancellationHours,PriceOptimizationOn,CorporateCode,ServicePercent,ServiceCharge,ServiceChargeAmt,GSTOnServiceCharge,RateCode,PCC,IsInterNationalChargesApplicable,IsHold)          
         
                         
    VALUES (@AgentId,@SupplierId,@ProfileId ,@CancellationHours,@PriceOpti,@CorporateCode,@ServicePercent,@ServiceCharge,@ServiceChargeAmt,@GSTOnServiceCharge,@RateCode,@OfficeID,@IsInternationalApplicable,@IsHold)                                         
 
                                          
    SELECT SCOPE_IDENTITY();                                          
   END                                          
  ELSE IF EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE Id=@Id)                                          
   BEGIN                                          
    UPDATE agentsupplierprofilemapper SET ProfileId=@ProfileId, CancellationHours=@CancellationHours,                                  
  IsActive=@IsActive,PriceOptimizationOn=@PriceOpti,CorporateCode=@CorporateCode,ServicePercent=cast(@ServicePercent as decimal(10,2)),                           
  ServiceCharge=cast(@ServiceCharge as decimal(10,2)),ServiceChargeAmt=cast(@ServiceChargeAmt as decimal(10,2)),GSTOnServiceCharge=cast(@GSTOnServiceCharge as decimal(18,2)),RateCode=@RateCode ,CreateDate=GetDate(), PCC=@OfficeID                        
  
   
   ,IsInterNationalChargesApplicable=@IsInternationalApplicable ,IsHold=@IsHold   
   WHERE Id=@Id                                          
    SELECT @Id                                          
   END                                          
  END                                          
  ELSE IF (@IsActive=0)                                          
  BEGIN                                          
   IF EXISTS(SELECT * FROM agentsupplierprofilemapper WHERE Id=@Id)                                          
   BEGIN                                          
    UPDATE agentsupplierprofilemapper SET IsActive=@IsActive ,ProfileId=0,CancellationHours=null,ServicePercent=null, ServiceCharge=null,ServiceChargeAmt=null,GSTOnServiceCharge=null,IsHold=0 WHERE Id=@Id                                          
    SELECT @Id                                          
END                                          
  END                                     
  END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AssignAgentSupplierProfile] TO [rt_read]
    AS [dbo];

