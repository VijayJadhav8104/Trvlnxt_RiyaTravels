
CREATE PROCEDURE [Rail].[sp_Insert_ServiceFee]         
 @Id INT = NULL        
 ,@Fk_SupplierMasterId VARCHAR(20) = NULL        
 ,@MarketPoint VARCHAR(20) = NULL        
 ,@ServiceType VARCHAR(50) = NULL        
 ,@UserType VARCHAR(200) = NULL        
 ,@IssuanceFrom DATETIME = NULL        
 ,@IssuanceTo DATETIME = NULL        
 ,@BookingType VARCHAR(50) = NULL        
 ,@CreadtedBy VARCHAR(30) = NULL        
 ,@AgentId VARCHAR(50) = NULL        
 ,@BookingFee DECIMAL(8, 2)    
 ,@MarginBookingFees DECIMAL(8, 2)     
 ,@TaxonMargin DECIMAL(8, 2)     
 ,@AgencyName VARCHAR(100) = NULL        
 ,@authId INT OUTPUT        
AS        
BEGIN   

SET NOCOUNT ON;

    DECLARE @ExistingId INT;

    -- Check if a record exists with the same MarketPoint, UserType, and AgentId
    SELECT TOP 1 @ExistingId = Id
    FROM [Rail].[tbl_ServiceFee] 
    WHERE MarketPoint = @MarketPoint 
      AND UserType = @UserType 
      AND AgentId = @AgentId
	  and isActive=1
    ORDER BY Id DESC;

    -- If a matching record exists, update its isActive status to 0
    IF (@ExistingId IS NOT NULL)
    BEGIN
        UPDATE [Rail].[tbl_ServiceFee] 
        SET isActive = 0
        WHERE Id = @ExistingId;
    END


 IF (@Id > 0)        
        
 BEGIN         
        
 UPDATE [Rail].[tbl_ServiceFee]        
  SET isActive = 0        
  WHERE Id = @Id        
 END        
        
  INSERT INTO [Rail].[tbl_ServiceFee] (        
   MarketPoint        
   ,UserType        
   ,IssuanceFrom        
   ,IssuanceTo        
   ,BookingType        
   ,ServiceType        
   ,CreatedDate        
   ,isActive        
   ,CreatedBy        
   ,Fk_SupplierMasterId        
   ,BookingFee     
   ,Mark_Up_On_Booking_Fees    
   ,Tax_on_Booking_Fees    
   ,AgencyName        
   ,AgentId        
   )        
  VALUES (        
   @MarketPoint        
   ,@UserType        
   ,@IssuanceFrom        
   ,@IssuanceTo        
   ,@BookingType        
   ,@ServiceType        
   ,getDate()        
   ,1        
   ,@CreadtedBy        
   ,@Fk_SupplierMasterId        
   ,@BookingFee    
   ,@MarginBookingFees    
   ,@TaxonMargin    
   ,@AgencyName        
   ,@AgentId        
   )        
        
  SET @authId = SCOPE_IDENTITY();        
        
  DECLARE @ServiceID INT        
        
  SELECT TOP 1 @ServiceID = Id        
  FROM [Rail].[tbl_ServiceFee]        
  ORDER BY Id DESC        
        
  DECLARE @Agentstr VARCHAR(300)        
        
  SET @Agentstr = (        
    SELECT AgentId        
    FROM [Rail].[tbl_ServiceFee]        
    WHERE Id = @ServiceID        
    )        
        
  IF (@Agentstr != 'All')        
  BEGIN        
   DECLARE @SEPARATOR CHAR(1)        
        
   SET @SEPARATOR = ','        
        
   INSERT INTO [Rail].[Service_AgentMapping] (        
    agentid        
    ,ServiceId        
    ) (        
    SELECT Item        
    ,@ServiceID AS ServiceId FROM dbo.splitstring(@Agentstr, @SEPARATOR)        
    )        
  END        
        
END 
