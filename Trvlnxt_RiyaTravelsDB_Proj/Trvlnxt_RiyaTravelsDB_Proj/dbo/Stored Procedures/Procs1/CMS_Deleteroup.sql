
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_Deleteroup]
	-- Add the parameters for the stored procedure here
	@id bigint,
	@userid bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@userid!=0)
 --   begin
	--delete from PKGGroup where PKID_int=@id
	--end
	--else
	begin
	delete from CMS_UserPermission where FKUserID_int=@userid
	end
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_Deleteroup] TO [rt_read]
    AS [dbo];

