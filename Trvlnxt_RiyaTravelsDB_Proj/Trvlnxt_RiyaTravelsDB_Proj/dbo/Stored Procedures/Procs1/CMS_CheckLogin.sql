
CREATE PROCEDURE [dbo].[CMS_CheckLogin] --'Admin','riya@123'
	-- Add the parameters for the stored procedure here
	@userID varchar(100),
	@passwd varchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   declare @pkId int
   declare @defaultPage varchar(100)
   declare @name varchar(100)

   if(@userID = 'Admin')
   begin
	select @pkId=[PKID_int] ,@name=[UserName]  from [dbo].[CMS_AdmiMaster] where UserID = @userID and [Password]=@passwd
	set @defaultPage='AddUser.aspx';
	end
    else
	begin
	     SELECT @pkId=PKID_int,@name=[UserName] From [dbo].[CMS_UserMaster] where UserID=@userID and [Passward]=@passwd and Status='ac'
		 set @defaultPage=(select top 1 path_vc from CMS_UserPermission a
		   inner join CMS_PermissionMaster b
		   on a.FKmenuID_int=b.PKID_int 
		   where a.FKUserID_int=@pkId)
	end

	select @pkId as PKID_int,@defaultPage as LoginPageName,@name as UserName
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_CheckLogin] TO [rt_read]
    AS [dbo];

