CREATE PROCEDURE [SS].[SP_Insert_CancellationFeeDetail]
		@CancellationFeeId INT= null, 
		@BookingPkId INT= null, 
		@valueType varchar(50)= null, 
		@Value float= null,
		@estimatedValue float= null,
		@startDate Datetime= null,
		@endDate Datetime= null
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @CancellationFeeDetailId INT 

	INSERT INTO [SS].[SS_CancellationFeeDetail]
		(CancellationFeeId, BookingPkId, valueType, Value, estimatedValue, startDate, endDate)
	VALUES
		(@CancellationFeeId, @BookingPkId, @valueType, @Value, @estimatedValue, @startDate, @endDate)

	SET @CancellationFeeDetailId  = (select  SCOPE_IDENTITY()) 
	SELECT @CancellationFeeDetailId
END
