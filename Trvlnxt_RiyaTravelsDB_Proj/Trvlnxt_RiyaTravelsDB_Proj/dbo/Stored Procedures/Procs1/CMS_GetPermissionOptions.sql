
CREATE PROCEDURE [dbo].[CMS_GetPermissionOptions]
	-- Add the parameters for the stored procedure here
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT menuname_vc,PKID_int from CMS_PermissionMaster where parentid_int is null and status_ch <> 'de' order by orderby_int asc
	
	--declare @count int
	--select @count=COUNT(FKUserID_int) from Permission where FKUserID_int=@userid
	--if(@count=0)
	--begin
	--SELECT menuname_vc,PKID_int from Menu where parentid_int is null order by orderby_int asc
	--end
	--else
	--begin
	--SELECT menuname_vc,Menu.PKID_int from Menu 
	--join Permission on Permission.FKmenuID_int=Menu.PKID_int
	--where parentid_int is null and Permission.FKUserID_int=@userid order by orderby_int asc 
	--end
	
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetPermissionOptions] TO [rt_read]
    AS [dbo];

