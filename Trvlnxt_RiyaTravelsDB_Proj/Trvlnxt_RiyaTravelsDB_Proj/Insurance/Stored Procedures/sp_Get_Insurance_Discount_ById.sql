
CREATE PROCEDURE [Insurance].[sp_Get_Insurance_Discount_ById]        
    @Id int     
AS        
BEGIN        
    SELECT         
        Id,        
        MarketPoint,        
        UserType,        
        ServiceType,        
        SupplierType,        
        AgentId,        
        TravelValidityFrom,        
        TravelValidityTo,        
        SaleValidityFrom,        
        SaleValidityTo,        
        InsuranceType,        
        --[Plan],        
        Country,      
		CountryState,  -- New column added      
        --ServiceFees, 
		ExtraAmtOrPercentage,
		ExtraAmtOrPercentageValue,
        CalculationTypeCommission,
		CommissionType,
        GST,        
        CancellationPolicyTime,
		CancellationPolicyTimeValue,
        AgencyName,        
        Currency,        
        CreatedBy,        
        CreatedDate,        
        isActive        
    FROM         
        [Insurance].[tbl_Insurance_Discount]        
    WHERE         
        Id = @Id;    
      
    
END 
