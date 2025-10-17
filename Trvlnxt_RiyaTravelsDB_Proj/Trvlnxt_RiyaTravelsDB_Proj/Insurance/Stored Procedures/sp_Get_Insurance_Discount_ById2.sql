
CREATE PROCEDURE [Insurance].[sp_Get_Insurance_Discount_ById2] 
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
		ServiceFee,
        GST,      
		MarkupCalculationTyp,
		MarkupVal,
		DiscountTyp,
		DiscountVal,
        AgencyName,        
        Currency,        
        CreatedBy,        
        CreatedDate,        
        isActive        
    FROM         
        [Insurance].[tbl_Insurance_Discount2]        
    WHERE         
        Id = @Id;
END
