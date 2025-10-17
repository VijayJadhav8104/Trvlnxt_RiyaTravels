
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_DeleteUser]
	-- Add the parameters for the stored procedure here
	@id bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   
	update CMS_UserMaster set Status='de' where PKID_int=@id
	
	
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_DeleteUser] TO [rt_read]
    AS [dbo];

