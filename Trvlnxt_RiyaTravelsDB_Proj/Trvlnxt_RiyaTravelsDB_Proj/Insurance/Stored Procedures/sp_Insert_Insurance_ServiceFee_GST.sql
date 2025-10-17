
CREATE PROCEDURE [Insurance].[sp_Insert_Insurance_ServiceFee_GST]
    @Id int = null,
    @MarketPoint varchar(30) = NULL,
    @UserType varchar(30) = NULL,
    @ServiceType varchar(50) = NULL,
    @AgentId nvarchar(300) = NULL,
    @SupplierType nvarchar(50) = NULL,
    @TravelValidityFrom datetime = NULL,
    @TravelValidityTo datetime = NULL,
    @SaleValidityFrom datetime = NULL,
    @SaleValidityTo datetime = NULL,
    @InsuranceType varchar(100) = NULL,
    @Plan varchar(30) = NULL,
    @Country varchar(30) = NULL,
    @ServiceFees varchar(50) = NULL,
    @MarkupOnBookingfess varchar(50) = NULL,
    @CalculationTypeCommission varchar(50) = NULL,
    @GST varchar(50) = NULL,
    @CancellationPolicyTime varchar(50) = NULL,
    @AmountParcentage varchar(50) = NULL,
    @DiscountCommissionType varchar(50) = NULL,
	@AgencyName varchar(1000) = NULL,
    @Currency varchar(10) = NULL,
    @CreatedBy nvarchar(50) = NULL,
	@AuthId int OUTPUT
AS
BEGIN
    INSERT INTO [Insurance].[tbl_Insurance_Discount]
    (
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
        [Plan],
        Country,
        ServiceFees,
        MarkupOnBookingfess,
        CalculationTypeCommission,
        GST,
        CancellationPolicyTime,
        AmountParcentage,
        DiscountCommissionType,
		AgencyName,
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
        @SupplierType,
        @AgentId,
        @TravelValidityFrom,
        @TravelValidityTo,
        @SaleValidityFrom,
        @SaleValidityTo,
        @InsuranceType,
        @Plan,
        @Country,
        @ServiceFees,
        @MarkupOnBookingfess,
        @CalculationTypeCommission,
        @GST,
        @CancellationPolicyTime,
        @AmountParcentage,
        @DiscountCommissionType,
		@AgencyName,
        @Currency,
        @CreatedBy,
        GETDATE(),
        1
    )
	SELECT @AuthId=SCOPE_IDENTITY()
END


