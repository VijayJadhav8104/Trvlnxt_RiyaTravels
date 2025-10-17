--EXEC GetToCurrencyByFromCurrency 'USD'
CREATE PROCEDURE [dbo].[GetToCurrencyByFromCurrency]
	@FromCurrency Varchar(20)
AS
BEGIN
	SELECT DISTINCT ToCur AS Value
	FROM ROE WITH(NOLOCK)
	WHERE FromCur=@FromCurrency 
	AND IsActive=1
END