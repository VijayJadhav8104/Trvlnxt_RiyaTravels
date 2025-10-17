-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetPaymentDetailsByOrderId]
    @OrderId NVARCHAR(50)
AS
BEGIN
    SELECT 
        Order_ID,
        Tracking_ID,
        Order_Status,
        Payment_Mode,
        Card_Name,
        Mer_Amount
    FROM Paymentmaster
    WHERE Order_ID = @OrderId
END
