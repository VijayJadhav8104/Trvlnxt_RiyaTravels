-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_Insertlocation]
	-- Add the parameters for the stored procedure here
	 @branch varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	if not exists(select Branch from tblBranch where [Branch] = @branch)
	begin
	insert into tblBranch (Branch) values (@branch)
	end

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_Insertlocation] TO [rt_read]
    AS [dbo];

