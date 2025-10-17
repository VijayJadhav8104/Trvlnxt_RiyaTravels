-- =============================================
-- Author:		Afifa
-- Create date: 13/March/2021
-- Description:	To get Data For DropDown
-- [dbo].[GetCurrency] 'Currency'
-- =============================================
CREATE PROCEDURE [dbo].[GetCurrency]-- 'Quatation'
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     SELECT distinct  Id,CurrencyCode
	 from mCountryCurrency
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCurrency] TO [rt_read]
    AS [dbo];

