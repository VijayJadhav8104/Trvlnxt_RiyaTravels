-- =============================================
-- Author:		Hardik Deshani
-- Create date: 10.07.2023
-- Description:	Get RPGConvenienceFee
-- =============================================
CREATE PROCEDURE RPGConvenienceFee_Get
	@PaymentGateway Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT RPGConvenienceFeeIDP
	, PaymentGateway
	, PaymentGatewayMode 
	, ConvenienceFee
	FROM RPGConvenienceFee
	WHERE PaymentGateway = @PaymentGateway
	AND IsActive = 1

END