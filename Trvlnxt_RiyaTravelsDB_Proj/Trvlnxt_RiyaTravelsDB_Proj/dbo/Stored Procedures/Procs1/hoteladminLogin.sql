
-- [hoteladminLogin] 'hotel','admin@123'
CREATE PROCEDURE [dbo].[hoteladminLogin] 	--'hotel'	,'admin@123'
	-- Add the parameters for the stored procedure here
	@userID varchar(20),
	@passwd varchar(128),
	--@IP		varchar(20),
	--@Device	varchar(20),
	@SessionID VARCHAR(50)=null
AS
BEGIN
	----B2C@123--- 77BF29190F16FBB259E87E6A9E1510EBC6EB2C40

	declare @uid nvarchar(500);

	IF(EXISTS(SELECT 1 FROM [Hotel_admin_Master] where  UserName=@userID and  [Password]=@passwd))
		BEGIN
			SELECT TOP 1 Id, FullName, M.Path,
			CASE WHEN Password = 'admin@123' THEN 1 ELSE 0 END AS IsResetPassword
			From [dbo].[Hotel_admin_Master] A
			left JOIN  Hotel_RoleAccess R ON R.UserID = A.UserName
			left JOIN Hotel_Menu M ON R.MenuID = M.MenuID
			where  UserName=@userID and  [Password]=@passwd --AND R.IsActive = 1 
			ORDER BY M.OrderID

			select @uid=id FROM [Hotel_admin_Master] where  UserName=@userID and  [Password]=@passwd
		    select * from Hotel_MenuNew where UserId=@uid --and Id!=4


			--Check to restrict multiple session for same user
			UPDATE [Hotel_admin_Master]
			SET SessionID=@SessionID WHERE   UserName=@userID and  [Password]=@passwd
		END
	
	else
begin
			SELECT TOP 1 A.PkId as Id,UserName as FullName, M.Path
			--CASE WHEN A.Passward = 'admin@123' THEN 1 ELSE 0 END AS IsResetPassword
			From [dbo].Hotel_UserMaster A
			JOIN  Hotel_userPermission R ON R.UserID = A.UserID
			JOIN Hotel_Menu M ON R.MenuID = M.MenuID
			where A. UserID=@userID and  a.[Passward]=@passwd AND A.Status = 1 
			ORDER BY M.OrderID

			select @uid=UserID FROM Hotel_UserMaster where  UserID=@userID and  Passward=@passwd
		   select HP.Id,Action,Controller,Title from Hotel_MenuNew HM inner join Hotel_userPermission HP on HP.MenuId=HM.Id where HP.UserId= @uid
--SELECT * FROM [Hotel_admin_Master] where  UserName=@userID and  [Password]=@passwd
end

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[hoteladminLogin] TO [rt_read]
    AS [dbo];

