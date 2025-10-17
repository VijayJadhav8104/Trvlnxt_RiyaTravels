
CREATE PROCEDURE [Insurance].[sp_Insert_Insurance_ServiceFee_GST_QuatationDetails]                                
    @Id INT = NULL,            
    @MarketPoint VARCHAR(30) = NULL,            
    @UserType VARCHAR(30) = NULL,            
    @ServiceType VARCHAR(50) = NULL,            
    @AgencyName VARCHAR(1000) = NULL,            
    @AgentId NVARCHAR(300) = NULL,            
    @SupplierType NVARCHAR(50) = NULL,            
    @TravelValidityFrom DATETIME = NULL,            
    @TravelValidityTo DATETIME = NULL,            
    @SaleValidityFrom DATETIME = NULL,            
    @SaleValidityTo DATETIME = NULL,            
    @InsuranceType VARCHAR(100) = NULL,            
    @Plan VARCHAR(30) = NULL,            
    @Country VARCHAR(30) = NULL,            
    @CountryState VARCHAR(30) = NULL,  -- Added parameter        
   -- @ServiceFees VARCHAR(50) = NULL,            
    @ExtraAmtOrPercentage VARCHAR(50) = NULL,            
    @ExtraAmtOrPercentageValue VARCHAR(50) = NULL,            
    @CalculationTypeCommission VARCHAR(50) = NULL,            
    @CommissionType VARCHAR(50) = NULL,            
    @GST VARCHAR(50) = NULL,            
    @CancellationPolicyTime VARCHAR(50) = NULL,            
    @CancellationPolicyTimeValue VARCHAR(50) = NULL,            
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
        INSERT INTO [Insurance].[tbl_Insurance_Discount]            
        (            
            MarketPoint,            
            UserType,            
            ServiceType,            
            AgencyName,            
            AgentId,            
            SupplierType,            
            TravelValidityFrom,            
            TravelValidityTo,            
            SaleValidityFrom,            
            SaleValidityTo,            
            InsuranceType,            
            --[Plan],            
            Country,            
            CountryState,   -- Added column        
            --ServiceFees,            
            ExtraAmtOrPercentage,            
            ExtraAmtOrPercentageValue,            
            CalculationTypeCommission,            
            CommissionType,            
            GST,            
            CancellationPolicyTime,            
            CancellationPolicyTimeValue,            
            Currency,
			CreatedBy,
			CreatedDate,
            isActive
        )            
        VALUES            
        (            
            @MarketPoint,            
            @UserType,            
            @ServiceType,            
            @AgencyName,            
            @AgentId,            
            @SupplierType,            
            @TravelValidityFrom,            
            @TravelValidityTo,            
            @SaleValidityFrom,            
            @SaleValidityTo,            
            @InsuranceType,            
            --@Plan,            
            @Country,            
            @CountryState,  -- Added parameter        
            --@ServiceFees,            
            @ExtraAmtOrPercentage,            
            @ExtraAmtOrPercentageValue,            
            @CalculationTypeCommission,            
            @CommissionType,            
            @GST,            
            @CancellationPolicyTime,            
            @CancellationPolicyTimeValue,            
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
        SELECT TOP 1 @ServiceID = Id FROM [Insurance].[tbl_Insurance_Discount] ORDER BY Id DESC;           
        DECLARE @Agentstr VARCHAR(300);                         
                              
        SET @Agentstr = (SELECT AgentId FROM [Insurance].[tbl_Insurance_Discount] WHERE Id = @ServiceID);                         
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
        UPDATE Insurance.tbl_Insurance_Discount SET isActive = 0 WHERE Id = @Id;      
        INSERT INTO [Insurance].[tbl_Insurance_Discount]            
        (            
            MarketPoint,            
            UserType,            
            ServiceType,            
            AgencyName,            
            AgentId,            
            SupplierType,            
            TravelValidityFrom,            
            TravelValidityTo,            
            SaleValidityFrom,            
            SaleValidityTo,            
            InsuranceType,            
            --[Plan],            
            Country,            
            CountryState,   -- Added column        
            --ServiceFees,            
            ExtraAmtOrPercentage,            
            ExtraAmtOrPercentageValue,            
            CalculationTypeCommission,            
            CommissionType,            
            GST,            
            CancellationPolicyTime,            
            CancellationPolicyTimeValue,            
            Currency,
			CreatedBy,
			CreatedDate,
            isActive,
			ModifyBy,
			ModifiedDate
        )            
        VALUES            
        (            
            @MarketPoint,            
            @UserType,            
            @ServiceType,            
            @AgencyName,            
            @AgentId,            
            @SupplierType,            
            @TravelValidityFrom,            
            @TravelValidityTo,            
            @SaleValidityFrom,            
            @SaleValidityTo,            
            @InsuranceType,            
            --@Plan,            
            @Country,            
            @CountryState,  -- Added parameter        
            --@ServiceFees,            
            @ExtraAmtOrPercentage,            
            @ExtraAmtOrPercentageValue,            
            @CalculationTypeCommission,            
            @CommissionType,            
            @GST,            
            @CancellationPolicyTime,            
            @CancellationPolicyTimeValue,            
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
        SELECT TOP 1 @ServiceID1 = Id FROM [Insurance].[tbl_Insurance_Discount] ORDER BY Id DESC;                        
        DECLARE @Agentstr1 VARCHAR(300);                         
                              
        SET @Agentstr1 = (SELECT AgentId FROM [Insurance].[tbl_Insurance_Discount] WHERE Id = @ServiceID1);                         
        IF (@Agentstr1 != 'All')                        
        BEGIN                        
            DECLARE @SEPARATOR1 CHAR(1);                         
            SET @SEPARATOR1 = ',';
            INSERT INTO [Insurance].[Insurance_Service_AgentMapping] (AgentId, ServiceId)
            SELECT Item, @ServiceID1 AS ServiceId FROM dbo.splitstring(@Agentstr1, @SEPARATOR1);
        END;
    END;                            
END;
