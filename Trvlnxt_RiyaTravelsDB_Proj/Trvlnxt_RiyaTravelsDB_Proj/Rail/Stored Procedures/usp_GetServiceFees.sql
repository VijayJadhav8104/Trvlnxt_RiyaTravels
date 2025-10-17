CREATE PROCEDURE [Rail].[usp_GetServiceFees]
    @Currency NVARCHAR(10)
AS
BEGIN
    SELECT *
    FROM [Rail].[AgentCurrencyBookingFees]
    WHERE AgentCurrency = @Currency
END
