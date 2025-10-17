
        
          --exec  AssignAgentSupplierProfile  '3256','2342',null,'11','1',null,'true',null,'1','1','1','Test,HCL,ZRM,ZRM ,ds,asa,sasaa,sS,WSW,SSD,AASD,DAD,DSD,DSA,TTD,FDS,HJDVSS,GSAASADA',null     
                
                
 CREATE PROCEDURE Visa.AssignAgentSupplierProfile                                      
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
  ,@GSTOnServiceCharge float=null   ---new changes                        
  ,@RateCode varchar(max)=null       --new changes                
  ,@OfficeID varchar(100)=null          
                  
 AS                                      
 BEGIN                                      
  IF (@IsActive=1)                                      
  BEGIN                                      
  IF NOT EXISTS(SELECT * FROM [Visa].[Visa_AgentSupplierProfileMapper] WHERE AgentId=@AgentId AND SupplierId=@SupplierId)                                      
   BEGIN                                      
    INSERT INTO [Visa].[Visa_AgentSupplierProfileMapper] (AgentId ,SupplierId,ProfileId ,CancellationHours,PriceOptimizationOn,CorporateCode,ServicePercent,ServiceCharge,GSTOnServiceCharge,RateCode,PCC,Isactive)                                      
    VALUES (@AgentId,@SupplierId,@ProfileId ,@CancellationHours,@PriceOpti,@CorporateCode,@ServicePercent,@ServiceCharge,@GSTOnServiceCharge,@RateCode,@OfficeID,1)                                      
                                      
    SELECT SCOPE_IDENTITY();                                      
   END                                      
  ELSE IF EXISTS(SELECT * FROM [Visa].[Visa_AgentSupplierProfileMapper] WHERE Id=@Id)                                      
   BEGIN                                      
    UPDATE [Visa].[Visa_AgentSupplierProfileMapper] SET ProfileId=@ProfileId, CancellationHours=@CancellationHours,                              
  IsActive=@IsActive,PriceOptimizationOn=@PriceOpti,CorporateCode=@CorporateCode,ServicePercent=cast(@ServicePercent as decimal(10,2)),                       
  ServiceCharge=cast(@ServiceCharge as decimal(10,2)),GSTOnServiceCharge=cast(@GSTOnServiceCharge as decimal(18,2)),RateCode=@RateCode ,ModifiedDate=GetDate(), PCC=@OfficeID                       
    WHERE Id=@Id                                      
    SELECT @Id                                      
   END                                      
  END                                      
  ELSE IF (@IsActive=0)                                      
  BEGIN                                      
   IF EXISTS(SELECT * FROM [Visa].[Visa_AgentSupplierProfileMapper] WHERE Id=@Id)                                      
   BEGIN                                      
    UPDATE [Visa].[Visa_AgentSupplierProfileMapper] SET IsActive=@IsActive ,ProfileId=0,CancellationHours=null,ServicePercent=null, ServiceCharge=null,GSTOnServiceCharge=null WHERE Id=@Id                                      
    SELECT @Id                                      
   END                                      
  END                                 
  END    
