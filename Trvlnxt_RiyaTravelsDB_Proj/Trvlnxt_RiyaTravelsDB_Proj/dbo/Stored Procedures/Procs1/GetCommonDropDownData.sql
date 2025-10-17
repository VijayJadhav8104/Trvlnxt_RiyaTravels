
-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 23/April/2020
-- Description:	To get Common Data For DropDown
-- [dbo].[GetCommonDropDownData] 'UserType'
-- =============================================
CREATE PROCEDURE [dbo].[GetCommonDropDownData]
	-- Add the parameters for the stored procedure here
	@Type varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
     if(@Type='UserType')
	 begin
	 select Value from mCommon where Category=@Type
	 end
	 else if(@Type='Quatation')
	 begin
	 select ID as Value,Value as [Text] from mCommon where Category=@Type
	 end
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCommonDropDownData] TO [rt_read]
    AS [dbo];

