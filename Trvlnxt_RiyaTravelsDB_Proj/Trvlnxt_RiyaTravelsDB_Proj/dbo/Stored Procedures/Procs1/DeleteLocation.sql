-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteLocation]
	-- Add the parameters for the stored procedure here
		@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

    -- Insert statements for procedure here
	delete from tblBranch
	where Id=@Id;
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteLocation] TO [rt_read]
    AS [dbo];

