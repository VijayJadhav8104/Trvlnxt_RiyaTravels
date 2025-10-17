
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ViewUser]
	-- Add the parameters for the stored procedure here
	@uid bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@uid=0)
    begin 
	SELECT * from CMS_UserMaster where Status='ac'
	end
	else
	begin
	select * from CMS_UserMaster where PKID_int=@uid and Status='ac'
	end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ViewUser] TO [rt_read]
    AS [dbo];

