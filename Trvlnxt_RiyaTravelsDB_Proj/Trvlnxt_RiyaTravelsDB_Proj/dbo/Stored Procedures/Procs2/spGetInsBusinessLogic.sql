CREATE PROCEDURE [dbo].[spGetInsBusinessLogic]
 @DepartureDate datetime,
 @ArrivalDate datetime,
 @Marketpoint varchar(5),
 @UserType VARCHAR(10)

 AS 
BEGIN

	SELECT ID, ROW_NUMBER() over(order by CreatedDate desc) RNO,
    ISNULL(ServiceType, '') AS ServiceType,
	UserType,
    ISNULL(AgencyName, '') AS AgencyName,
    ISNULL(AgentId, '') AS AgentId,
    ISNULL(SupplierType, '') AS SupplierType,
    ISNULL(InsuranceType, '') AS InsuranceType,
    ISNULL(ServiceFee, 0) AS ServiceFee,
    ISNULL(GST, 0) AS GST,
    ISNULL(MarkupCalculationTyp, '') AS MarkupCalculationTyp,
    ISNULL(MarkupVal, 0) AS MarkupVal,
    ISNULL(DiscountTyp, '') AS DiscountTyp,
    ISNULL(DiscountVal, 0) AS DiscountVal,
	ISNULL(Currency, '') AS Currency
FROM [Insurance].[tbl_Insurance_Discount2]
WHERE isActive = '1'
and UserType = @UserType
and MarketPoint=@Marketpoint
and CONVERT(VARCHAR,@DepartureDate,112) >= CONVERT(VARCHAR,TravelValidityFrom,112) AND CONVERT(VARCHAR,@DepartureDate,112) <= CONVERT(VARCHAR,TravelValidityTo,112)

and CONVERT(VARCHAR,@ArrivalDate,112) >= CONVERT(VARCHAR,TravelValidityFrom,112) AND CONVERT(VARCHAR,@ArrivalDate,112) <= CONVERT(VARCHAR,TravelValidityTo,112)
and CONVERT(VARCHAR,SaleValidityFrom,112) <= CONVERT(VARCHAR,GETDATE(),112)  and CONVERT(VARCHAR,SaleValidityTo,112) >= CONVERT(VARCHAR,GETDATE(),112)
		
	
END
