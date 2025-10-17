
CREATE PROCEDURE [Insurance].[sp_InsertInsuranceServiceFeeGstDetails]                                
    @Id INT = NULL,            
    @MarketPoint VARCHAR(30) = NULL,@UserType VARCHAR(30) = NULL,@ServiceType VARCHAR(50) = NULL,@AgencyName VARCHAR(1000) = NULL,            
    @AgentId NVARCHAR(300) = NULL,            
    @SupplierType NVARCHAR(50) = NULL,            
    @TravelValidityFrom DATETIME = NULL,@TravelValidityTo DATETIME = NULL,@SaleValidityFrom DATETIME =NULL,@SaleValidityTo DATETIME = NULL,            
    @InsuranceType VARCHAR(100) = NULL,  -- Added parameter  
    @ServiceFee VARCHAR(50) = NULL,   
    @GST VARCHAR(50) = NULL,      
	@MarkupCalculationTyp VARCHAR(20) = NULL,
	@MarkupVal VARCHAR(10) = NULL,
	@DiscountTyp VARCHAR(20) = NULL,
	@DiscountVal VARCHAR(10) = NULL, 
    @Currency VARCHAR(10) = NULL,
	@CreatedBy nvarchar(50) = NULL,
	@ModifiedDate varchar(50)=NULL,
    @isActive BIT = NULL,            
    @AuthId INT OUTPUT            
AS            
BEGIN          
    -- Adding the condition starts          
    IF (@Id = 0)          
    BEGIN          
        -- Adding the condition ends          
        INSERT INTO [Insurance].[tbl_Insurance_Discount2]            
        (            
            MarketPoint,UserType,ServiceType,AgencyName,AgentId,SupplierType,            
            TravelValidityFrom,TravelValidityTo,SaleValidityFrom,SaleValidityTo,            
            InsuranceType,     -- Added column              
			ServiceFee,GST,            
			MarkupCalculationTyp,MarkupVal,
			DiscountTyp,DiscountVal,           
            Currency,
			CreatedBy,
			CreatedDate,
            isActive
        )            
        VALUES            
        (            
            @MarketPoint,@UserType,@ServiceType,@AgencyName,@AgentId,@SupplierType,            
            @TravelValidityFrom,@TravelValidityTo,@SaleValidityFrom,@SaleValidityTo,            
            @InsuranceType,   -- Added parameter    
			@ServiceFee,@GST, 
			@MarkupCalculationTyp,@MarkupVal,
			@DiscountTyp,@DiscountVal,          
            @Currency,            
            --@isActive
			@CreatedBy,
			GETDATE(),
			1
        )            
           
        SELECT @AuthId = SCOPE_IDENTITY();               
                    
        SET @AuthId = SCOPE_IDENTITY();               
        SELECT @AuthId;
                  
        DECLARE @ServiceID INT;                        
        SELECT TOP 1 @ServiceID = Id FROM [Insurance].[tbl_Insurance_Discount2] ORDER BY Id DESC;           
        DECLARE @Agentstr VARCHAR(300);                         
                              
        SET @Agentstr = (SELECT AgentId FROM [Insurance].[tbl_Insurance_Discount2] WHERE Id = @ServiceID);                         
        IF (@Agentstr != 'All')                        
        BEGIN                        
            DECLARE @SEPARATOR CHAR(1);                         
            SET @SEPARATOR = ',';
            INSERT INTO [Insurance].[Insurance_Service_AgentMapping] (AgentId, ServiceId)
            SELECT Item, @ServiceID AS ServiceId FROM dbo.splitstring(@Agentstr, @SEPARATOR);
        END;                        
    END;
                                
    IF (@Id > 0)                             
    BEGIN      
        UPDATE Insurance.tbl_Insurance_Discount2 SET isActive = 0 WHERE Id = @Id;      
        INSERT INTO [Insurance].[tbl_Insurance_Discount2]            
        (            
            MarketPoint,UserType,ServiceType,AgencyName,AgentId,SupplierType,            
            TravelValidityFrom,TravelValidityTo,SaleValidityFrom,SaleValidityTo,            
            InsuranceType,   -- Added column   
			ServiceFee,GST,         
			MarkupCalculationTyp,MarkupVal,
			DiscountTyp,DiscountVal,   
            Currency,
			CreatedBy,
			CreatedDate,
            isActive,
			ModifyBy,
			ModifiedDate
        )            
        VALUES            
        (            
            @MarketPoint,@UserType,@ServiceType,@AgencyName,@AgentId,@SupplierType,            
            @TravelValidityFrom,@TravelValidityTo,@SaleValidityFrom,@SaleValidityTo,            
            @InsuranceType, -- Added parameter   
			@ServiceFee,@GST,           
			@MarkupCalculationTyp,@MarkupVal,
			@DiscountTyp,@DiscountVal,
            @Currency,            
            --@isActive
			@CreatedBy,
			GETDATE(),
			1,
			@CreatedBy,
			GETDATE()
        );
        SELECT @AuthId = SCOPE_IDENTITY();               
                    
        SET @AuthId = SCOPE_IDENTITY();               
        SELECT @AuthId;
                  
        DECLARE @ServiceID1 INT;                        
        SELECT TOP 1 @ServiceID1 = Id FROM [Insurance].[tbl_Insurance_Discount2] ORDER BY Id DESC;                        
        DECLARE @Agentstr1 VARCHAR(300);                         
                              
        SET @Agentstr1 = (SELECT AgentId FROM [Insurance].[tbl_Insurance_Discount2] WHERE Id = @ServiceID1);                         
        IF (@Agentstr1 != 'All')                        
        BEGIN                        
            DECLARE @SEPARATOR1 CHAR(1);                         
            SET @SEPARATOR1 = ',';
            INSERT INTO [Insurance].[Insurance_Service_AgentMapping] (AgentId, ServiceId)
            SELECT Item, @ServiceID1 AS ServiceId FROM dbo.splitstring(@Agentstr1, @SEPARATOR1);
        END;
    END;                            
END;
