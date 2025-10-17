-- =============================================
-- Author:		Afifa
-- Create date: 28/July/2021
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
CREATE PROCEDURE [dbo].[GetCRSType]-- 'Quatation'
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT DISTINCT CategoryValue,pkid FROM tbl_commonmaster where Category='CRS'
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCRSType] TO [rt_read]
    AS [dbo];

