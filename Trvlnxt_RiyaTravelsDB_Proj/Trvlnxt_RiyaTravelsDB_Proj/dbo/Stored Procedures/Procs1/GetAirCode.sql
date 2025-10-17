-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2020
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
CREATE PROCEDURE [dbo].[GetAirCode]-- 'Quatation'
	-- Add the parameters for the stored procedure here
@Value varchar(50) 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT DISTINCT _NAME FROM AirlinesName where _CODE=@Value
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirCode] TO [rt_read]
    AS [dbo];

