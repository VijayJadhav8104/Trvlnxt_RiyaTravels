-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2020
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
create PROCEDURE [dbo].[GetAirPortCode]-- 'Quatation'
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT * FROM tblAirportCity
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirPortCode] TO [rt_read]
    AS [dbo];

