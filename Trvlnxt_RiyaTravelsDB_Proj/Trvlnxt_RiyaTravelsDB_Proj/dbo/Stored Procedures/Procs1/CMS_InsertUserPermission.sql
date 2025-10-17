
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_InsertUserPermission]
	-- Add the parameters for the stored procedure here
	@uid bigint,
	@menuid bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   if not exists(select * from CMS_UserPermission where FKUserID_int=@uid and FKmenuID_int=@menuid)
   begin
	insert into CMS_UserPermission(FKUserID_int,FKmenuID_int) values(@uid,@menuid)
	select 1
	end
	else
	begin
	
	update CMS_UserPermission set FKmenuID_int=@menuid where FKUserID_int=@uid
	select 2
	end
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertUserPermission] TO [rt_read]
    AS [dbo];

