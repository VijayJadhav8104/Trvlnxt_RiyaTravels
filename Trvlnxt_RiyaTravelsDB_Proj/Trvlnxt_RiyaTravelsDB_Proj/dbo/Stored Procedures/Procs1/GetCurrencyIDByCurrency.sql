CREATE PROC [dbo].[GetCurrencyIDByCurrency]
	@Currency VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 ID  from mCommon Where Value=@Currency and Category='Currency'
END