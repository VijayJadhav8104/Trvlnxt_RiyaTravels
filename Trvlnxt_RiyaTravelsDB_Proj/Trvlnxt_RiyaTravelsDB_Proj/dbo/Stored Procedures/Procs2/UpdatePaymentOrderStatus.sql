CREATE PROCEDURE [dbo].[UpdatePaymentOrderStatus]
    @OrderId NVARCHAR(50),
    @Status NVARCHAR(50)
AS
BEGIN
    UPDATE paymentmaster
    SET Order_Status = @Status
    WHERE Order_ID = @OrderId
END
