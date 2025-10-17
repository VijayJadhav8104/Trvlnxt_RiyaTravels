
CREATE PROCEDURE [Rail].[sp_Insert_ServiceFeeNew]             
 @Id INT = NULL            
 ,@Fk_SupplierMasterId VARCHAR(20) = NULL            
 ,@MarketPoint VARCHAR(20) = NULL            
 ,@ServiceType VARCHAR(50) = NULL            
 ,@UserType VARCHAR(200) = NULL            
 ,@IssuanceFrom DATETIME = NULL            
 ,@IssuanceTo DATETIME = NULL                 
 ,@CreadtedBy VARCHAR(30) = NULL            
 ,@AgentId VARCHAR(50) = NULL            
 ,@BookingFee DECIMAL(8, 2)
 ,@GSTServiceFees Varchar(50)=NULL
 ,@BookingType VARCHAR(100) = NULL    
 ,@AgencyName VARCHAR(100) = NULL            
 ,@authId INT OUTPUT            
AS            
BEGIN      
  
SET NOCOUNT ON;
  
    DECLARE @ExistingId INT;  
  
    -- Check if a record exists with the same MarketPoint, UserType, and AgentId  
    SELECT TOP 1 @ExistingId = Id  
    FROM [Rail].[tbl_ServiceFeeNew]   
    WHERE MarketPoint = @MarketPoint   
      AND UserType = @UserType   
      AND AgentId = @AgentId  
   and isActive=1  
    ORDER BY Id DESC;
  
    -- If a matching record exists, update its isActive status to 0  
    IF (@ExistingId IS NOT NULL)  
    BEGIN  
        UPDATE [Rail].[tbl_ServiceFeeNew]   
        SET isActive = 0  
        WHERE Id = @ExistingId;  
    END  
  
 IF (@Id > 0)            
            
 BEGIN             
            
 UPDATE [Rail].[tbl_ServiceFeeNew]            
  SET isActive = 0            
  WHERE Id = @Id            
 END            
            
  INSERT INTO [Rail].[tbl_ServiceFeeNew] (            
   MarketPoint            
   ,UserType            
   ,IssuanceFrom            
   ,IssuanceTo                 
   ,ServiceType            
   ,CreatedDate            
   ,isActive            
   ,CreatedBy            
   ,Fk_SupplierMasterId      
   ,ServiceFeesType    
   ,FixedServiceFeesAmt
   ,GSTServiceFees
   ,AgencyName            
   ,AgentId            
   )            
  VALUES (            
   @MarketPoint            
   ,@UserType            
   ,@IssuanceFrom            
   ,@IssuanceTo                  
   ,@ServiceType            
   ,getDate()            
   ,1            
   ,@CreadtedBy            
   ,@Fk_SupplierMasterId    
   ,@BookingType    
   ,@BookingFee
   ,@GSTServiceFees
   ,@AgencyName            
   ,@AgentId            
   )            
            
  SET @authId = SCOPE_IDENTITY();            
            
  DECLARE @ServiceID INT            
            
  SELECT TOP 1 @ServiceID = Id            
  FROM [Rail].[tbl_ServiceFeeNew]            
  ORDER BY Id DESC            
            
  DECLARE @Agentstr VARCHAR(300)            
            
  SET @Agentstr = (            
    SELECT AgentId            
    FROM [Rail].[tbl_ServiceFeeNew]            
    WHERE Id = @ServiceID            
    )            
            
  IF (@Agentstr != 'All')            
  BEGIN            
   DECLARE @SEPARATOR CHAR(1)            
            
   SET @SEPARATOR = ','            
            
   INSERT INTO [Rail].[Service_AgentMappingNew] (            
    agentid            
    ,ServiceId            
    ) (            
    SELECT Item            
    ,@ServiceID AS ServiceId FROM dbo.splitstring(@Agentstr, @SEPARATOR)            
    )            
  END            
            
END     
