-- =============================================
-- Author:		Hardik Deshani
-- Create date: 10.07.2023
-- Description:	Get RPGConvenienceFee By ID
-- =============================================
CREATE PROCEDURE RPGConvenienceFee_GetByID
	@PaymentGateWayMode Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 ConvenienceFee FROM RPGConvenienceFee
	WHERE PaymentGateWayMode = @PaymentGateWayMode

END