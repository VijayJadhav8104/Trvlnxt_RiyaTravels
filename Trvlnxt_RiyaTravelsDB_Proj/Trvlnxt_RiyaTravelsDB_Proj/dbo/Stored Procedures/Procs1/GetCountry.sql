-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2021
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
CREATE PROCEDURE [dbo].[GetCountry]-- 'Quatation'
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT country FROM Country
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCountry] TO [rt_read]
    AS [dbo];

