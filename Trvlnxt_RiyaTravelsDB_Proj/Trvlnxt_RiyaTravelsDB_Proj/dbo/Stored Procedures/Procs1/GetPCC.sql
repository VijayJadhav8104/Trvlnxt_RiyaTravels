-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 23/April/2020
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
CREATE PROCEDURE [dbo].[GetPCC]-- 'Quatation'
	-- Add the parameters for the stored procedure here
@Value int 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT CategoryValue FROM tbl_commonmaster where Mapping=@Value
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPCC] TO [rt_read]
    AS [dbo];

