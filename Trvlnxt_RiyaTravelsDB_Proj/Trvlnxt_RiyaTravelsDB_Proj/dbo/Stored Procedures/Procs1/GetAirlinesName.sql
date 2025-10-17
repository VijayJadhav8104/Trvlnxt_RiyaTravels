-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 23/April/2020
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
create PROCEDURE [dbo].[GetAirlinesName]-- 'Quatation'
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT _CODE,_NAME FROM AirlinesName
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirlinesName] TO [rt_read]
    AS [dbo];

