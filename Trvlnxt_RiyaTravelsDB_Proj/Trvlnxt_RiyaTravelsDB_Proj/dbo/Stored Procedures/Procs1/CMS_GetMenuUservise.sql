
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_GetMenuUservise]
	-- Add the parameters for the stored procedure here
	@uid bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF(@uid!=0)
    BEGIN
	select menuname_vc,parentid_int,PM.PKID_int,path_vc from CMS_PermissionMaster PM 
	inner join CMS_UserPermission UP on UP.FKmenuID_int=PM.PKID_int where UP.FKUserID_int=@uid
	END
	else
	begin
	SELECT menuname_vc,parentid_int,PKID_int,orderby_int,path_vc from CMS_PermissionMaster where status_ch<>'de' order by orderby_int asc 
	end
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetMenuUservise] TO [rt_read]
    AS [dbo];

