
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getexchangeratesforcode]
	-- Add the parameters for the stored procedure here
	@code varchar(30)

	--@id bigint,
	--@type varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 --   if(@code='')
 --   begin
	--select salerate_ft from ExchangeRates where PKID_int=@id
	--end
	--else
	--begin
	--select buyrate_ft from ExchangeRates where PKID_int=@id
	--end
	
	--if(@type='Buy')
	--begin
	--select buyrate_ft from ExchangeRates where currencycode_vc=@code
	--end
	--else
	--begin
	--select salerate_ft from ExchangeRates where currencycode_vc=@code
	--end
	
	
	
	--select buyrate_ft,salerate_ft from ExchangeRates where currencycode_vc=@code 
	select ROUND(buyrate_ft,2) AS buyrate_ft,ROUND(salerate_ft,2) AS salerate_ft,ISNULL(updateddt_dt,[createdOn]) as [date] from [CMS_ExchangeRates] where currencycode_vc=@code 
order by  [date] desc
	
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getexchangeratesforcode] TO [rt_read]
    AS [dbo];

