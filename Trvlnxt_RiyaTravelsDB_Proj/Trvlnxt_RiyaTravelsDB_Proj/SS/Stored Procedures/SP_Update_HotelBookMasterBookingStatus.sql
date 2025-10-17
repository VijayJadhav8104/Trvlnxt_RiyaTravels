CREATE PROCEDURE [SS].[SP_Update_HotelBookMasterBookingStatus]
@BookingId INT ,
@BookingStatus VARCHAR(50),
@ActivityBookingStatus VARCHAR(50)=null,
@ProviderConfirmationNumber VARCHAR(50),
@providerCancellationNumber VARCHAR(50),
@ClientBookingId INT,
@VoucherUrl varchar(max) = NULL

AS
BEGIN
	UPDATE BM 
	SET BookingStatus = @BookingStatus, modifiedDate = GETDATE(),
		ProviderConfirmationNumber = @ProviderConfirmationNumber,
		ProviderCancellationNumber = @providerCancellationNumber,
		ClientBookingId = @ClientBookingId,
		VoucherUrl = CASE WHEN isnull(@VoucherUrl,'') = '' THEN BM.VoucherUrl ELSE @VoucherUrl END
	FROM [SS].[SS_BookingMaster] BM
	WHERE BookingId = @BookingId	

	UPDATE [SS].SS_BookedActivities
	SET ActivityStatus = @ActivityBookingStatus
	WHERE BookingId = @BookingId	

	SELECT @BookingId
END

