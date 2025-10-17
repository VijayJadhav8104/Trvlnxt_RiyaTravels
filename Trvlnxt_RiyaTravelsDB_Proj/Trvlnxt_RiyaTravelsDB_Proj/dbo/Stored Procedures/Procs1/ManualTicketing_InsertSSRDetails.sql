CREATE PROCEDURE ManualTicketing_InsertSSRDetails
	@fkBookMaster BigInt
	,@fkPassengerid BigInt
	,@fkItenary BigInt
	,@Meal Varchar(10) = NULL
	,@MealAmount decimal(18,2) = NULL
	,@Baggage Varchar(10) = NULL
	,@BaggageAmount decimal(18,2) = NULL
	,@Seat Varchar(10) = NULL
	,@SeatAmount decimal(18,2) = NULL
	,@createdBy Int
AS
BEGIN
	SET NOCOUNT ON;

	-- Meal
	IF (@Meal IS NOT NULL AND @MealAmount IS NOT NULL)
	BEGIN
		INSERT INTO tblSSRDetails (fkBookMaster,fkPassengerid,fkItenary,SSR_Type,SSR_Name,SSR_Code,SSR_Amount,SSR_Status,createdDate,createdBy)
		VALUES (@fkBookMaster,@fkPassengerid,@fkItenary,'Meals',@Meal,@Meal,@MealAmount,1,GETDATE(),@createdBy)
	END

	-- Baggage
	IF (@Baggage IS NOT NULL AND @BaggageAmount IS NOT NULL)
	BEGIN
		INSERT INTO tblSSRDetails (fkBookMaster,fkPassengerid,fkItenary,SSR_Type,SSR_Name,SSR_Code,SSR_Amount,SSR_Status,createdDate,createdBy)
		VALUES (@fkBookMaster,@fkPassengerid,@fkItenary,'Baggage',@Baggage,@Baggage,@BaggageAmount,1,GETDATE(),@createdBy)
	END

	-- Seat
	IF (@Seat IS NOT NULL AND @SeatAmount IS NOT NULL)
	BEGIN
		INSERT INTO tblSSRDetails (fkBookMaster,fkPassengerid,fkItenary,SSR_Type,SSR_Name,SSR_Code,SSR_Amount,SSR_Status,createdDate,createdBy)
		VALUES (@fkBookMaster,@fkPassengerid,@fkItenary,'Seat',@Seat,@Seat,@SeatAmount,1,GETDATE(),@createdBy)
	END

END