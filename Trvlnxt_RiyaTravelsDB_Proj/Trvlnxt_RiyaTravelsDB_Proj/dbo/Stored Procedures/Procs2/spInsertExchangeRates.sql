
CREATE PROCEDURE [dbo].[spInsertExchangeRates]
	-- Add the parameters for the stored procedure here
	@currname varchar(50),
	@sale float,
	@buy float,
	@code varchar(30)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if not exists(select PKID_int from [dbo].[CMS_ExchangeRates] where inserteddt_dt = CAST(GETDATE() as date) and currencycode_vc=@code)
	begin
	insert into [CMS_ExchangeRates](currencyname_vc,salerate_ft,buyrate_ft,currencycode_vc) values(@currname,@sale,@buy,@code)
	end
	else
	begin
	update [CMS_ExchangeRates] set currencyname_vc=@currname,salerate_ft=@sale,buyrate_ft=@buy,updateddt_dt=GETDATE() where currencycode_vc=@code and inserteddt_dt = CAST(GETDATE() as date)
	end
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertExchangeRates] TO [rt_read]
    AS [dbo];

