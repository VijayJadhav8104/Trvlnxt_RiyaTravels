-- =============================================
-- Author:		<Ketan Hiranandani>
-- Create date: <10-Aug-2020>
-- Description:	<Insert Update promotion record>
-- =============================================
CREATE PROCEDURE Addb2bPromotion  
  @MarketPoint VARCHAR(30),
  @UserType VARCHAR(50),
  @Supplier INT,
  @PromotionName VARCHAR(100),
  @GroupType VARCHAR(50),
  @TravelValidity_From DATETIME=NULL,
  @TravelValidity_To DATETIME=NULL,
  @BookingValidity_From DATETIME=NULL,
  @BookingValidity_To DATETIME=NULL,
  @Amount  NUMERIC(18,2)=NULL,
  @Percentage NUMERIC(18,2)=NULL,
  @InsertedBy INT,
  @UpdatedBy INT=NULL,	
  @IsActive BIT=NULL,
  @IsSupplier BIT=NULL
AS	
BEGIN
		
	IF NOT EXISTS(SELECT Id FROM B2B_Promotion WHERE PromotionName=@PromotionName AND Supplier=@Supplier)
	BEGIN
		--IF (@IsActive=1)
		--BEGIN
		INSERT INTO B2B_Promotion (
								 MarketPoint,
								 UserType,
								 Supplier,
								 PromotionName,
								 GroupType,
								 TravelValidityFrom,
								 TravelValidityTo,
								 BookingValidityFrom,
								 BookingValidityTo,
								 Amount,
								 Percentage,
								 InsertedBy,
								 IsSupplier

								) 
					VALUES(      @MarketPoint,
								 @UserType,
								 @Supplier,
								 @PromotionName,
								 @GroupType,
								 @TravelValidity_From,
								 @TravelValidity_To,
								 @BookingValidity_From,
								 @BookingValidity_To,
								 @Amount,
								 @Percentage,
								 @InsertedBy,
								 @IsSupplier						)	
		--END
		SELECT 1	
	END    
	ELSE IF EXISTS(SELECT Id FROM B2B_Promotion WHERE PromotionName=@PromotionName AND Supplier=@Supplier AND IsActive=1)
	BEGIN
		
		UPDATE B2B_Promotion 
		SET MarketPoint=@MarketPoint,
		UserType=@UserType,
		TravelValidityFrom=@TravelValidity_From,
		TravelValidityTo=@TravelValidity_To,
		BookingValidityFrom=@BookingValidity_From,
		BookingValidityTo=@BookingValidity_To,
		Amount=@Amount,
		Percentage=@Percentage,
		UpdatedBy=@UpdatedBy,
		UpdatedDate=GETDATE(),
		IsSupplier=@IsSupplier,
		Supplier=@Supplier
		WHERE PromotionName=@PromotionName AND Supplier=@Supplier
			
		SELECT 1
	END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Addb2bPromotion] TO [rt_read]
    AS [dbo];

