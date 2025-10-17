
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_GetUserPermission]
	-- Add the parameters for the stored procedure here
	@userid bigint,
	@nodeid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select * from CMS_UserPermission where FKUserID_int=@userid and FKmenuID_int=@nodeid)
	select 1
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetUserPermission] TO [rt_read]
    AS [dbo];

