create PROCEDURE [dbo].[UpdateB2CTrackingStatus]
	@PNR varchar(200),
	@status Varchar(50),
	@OrderID Varchar(50)
AS
BEGIN
	Update tblB2CTrackingDetails
	Set
		PNR=@PNR, UpdatedDate=GETDATE(),Status=@status
	WHERE
		OrderId = @OrderID
END
