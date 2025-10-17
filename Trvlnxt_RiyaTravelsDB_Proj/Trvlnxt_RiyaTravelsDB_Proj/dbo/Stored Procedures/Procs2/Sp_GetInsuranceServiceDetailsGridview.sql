CREATE PROCEDURE Sp_GetInsuranceServiceDetailsGridview
    @UserType VARCHAR(50),    
    @MarketPoint VARCHAR(50),    
    @ServiceType VARCHAR(50)    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    SELECT     
        CD.Id,    
        MarketPoint,    
  Currency,    
        ServiceType,    
        CD.AgencyName AS AgentName,    
  AgentId,    
        TravelValidityFrom,    
        TravelValidityTo,    
        SaleValidityFrom,    
        SaleValidityTo,    
  CASE     
            WHEN ServiceType = 'Service Fee/GST' THEN ServiceFee    
            ELSE NULL    
        END AS ServiceFee,    
        CASE     
            WHEN ServiceType = 'Service Fee/GST' THEN GST    
            ELSE NULL    
        END AS GST,    
        CASE     
            WHEN ServiceType = 'Hidden Markup' THEN MarkupCalculationTyp    
            ELSE NULL    
        END AS MarkupCalculationTyp,    
        CASE     
            WHEN ServiceType = 'Hidden Markup' THEN MarkupVal    
            ELSE NULL    
        END AS MarkupVal,    
        CASE     
            WHEN ServiceType = 'Discount' THEN DiscountTyp    
            ELSE NULL    
        END AS DiscountTyp,    
        CASE     
            WHEN ServiceType = 'Discount' THEN DiscountVal    
            ELSE NULL    
        END AS DiscountVal,    
        CreatedDate,    
        CD.isActive,    
  ModifiedDate,    
  MU.UserName AS 'CreatedBy',    
        MU.FullName,    
  CASE                           
            WHEN UserType = 1 THEN 'B2C'                           
            WHEN UserType = 2 THEN 'B2B'                           
            WHEN UserType = 3 THEN 'Marine'                           
            WHEN UserType = 192 THEN 'Holiday'                          
            WHEN UserType = 5 THEN 'RBT'                           
            WHEN UserType = 1245 THEN 'External Client'                           
            ELSE 'NA'                          
        END AS 'UserType'    
    FROM insurance.tbl_Insurance_Discount2 CD    
   LEFT JOIN mUser MU ON MU.ID = CD.CreatedBy    
    WHERE     
 (CD.UserType = @UserType OR @UserType = '' OR @UserType IS NULL) AND                             
    (CD.MarketPoint = @MarketPoint OR @MarketPoint = '' OR @MarketPoint IS NULL) AND             
    (CD.ServiceType = @ServiceType OR @ServiceType = '' OR @ServiceType IS NULL) AND     
 CD.isActive = 1  
 ORDER BY CD.Id DESC;    
END; 