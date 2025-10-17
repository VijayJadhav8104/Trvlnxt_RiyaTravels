CREATE PROC GetDiscountedPrice
@AgentId INT,
@PriceMRP DECIMAL(18,0)
AS
BEGIN
	DECLARE @PricePercent DECIMAL(18,0),@Amount DECIMAL(18,0),@PriceFromPercent DECIMAL(18,0),@PriceFromAmount DECIMAL(18,0),@FromRange DECIMAL(18,0),
	@ToRange DECIMAL(18,0)
	SELECT @FromRange=cast(FromRange as DECIMAL(10,2)) 
	 FROM PricingProfileDetails PPD INNER JOIN PricingProfile PP ON PP.Id=PPD.FKPricingProfile
	INNER JOIN AgentProfileMapper APM ON APM.ProfileId=PP.Id WHERE PPD.IsActive=1 AND APM.IsActive=1 AND PP.IsActive=1 AND APM.AgentId=@AgentId;
	SELECT @ToRange=cast(ToRange as DECIMAL(10,2)) 
	 FROM PricingProfileDetails PPD INNER JOIN PricingProfile PP ON PP.Id=PPD.FKPricingProfile
	INNER JOIN AgentProfileMapper APM ON APM.ProfileId=PP.Id WHERE PPD.IsActive=1 AND APM.IsActive=1 AND PP.IsActive=1 AND APM.AgentId=@AgentId;
	IF @PriceMRP>=@FromRange AND @PriceMRP<=@ToRange
		BEGIN
			SELECT @PricePercent=PPD.PricePercent,@PriceFromAmount=PPD.Amount FROM AgentProfileMapper APM INNER JOIN PricingProfile PP ON APM.ProfileId=PP.Id
			INNER JOIN PricingProfileDetails PPD ON PP.Id=PPD.FKPricingProfile WHERE PPD.IsActive=1 AND APM.IsActive=1 AND PP.IsActive=1 AND APM.AgentId=@AgentId;
			SET @PriceFromPercent=@PriceMRP*@PricePercent/100;
			DECLARE @ActualPriceFromPrecent DECIMAL(18,0),@FinalPrice DECIMAL(18,0)
			SET @ActualPriceFromPrecent=@PriceMRP-@PriceFromPercent;
			SELECT @ActualPriceFromPrecent AS 'ActualPriceFromPrecent';
			SELECT @PriceFromPercent AS 'PriceFromPercent';
			IF @ActualPriceFromPrecent>@PriceFromAmount
				BEGIN
					SET @FinalPrice=@ActualPriceFromPrecent;
				END
			ELSE
				BEGIN
					SET @FinalPrice=@PriceFromAmount;
				END
		END
	ELSE
		BEGIN
			SET @FinalPrice=@PriceMRP;
		END
	
	SELECT @FinalPrice;
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetDiscountedPrice] TO [rt_read]
    AS [dbo];

