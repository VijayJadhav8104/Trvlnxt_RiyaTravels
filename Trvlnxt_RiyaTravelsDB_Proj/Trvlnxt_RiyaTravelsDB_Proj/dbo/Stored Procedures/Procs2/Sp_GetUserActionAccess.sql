
CREATE PROCEDURE [dbo].[Sp_GetUserActionAccess]
	@MenuId int,
	@RoleId int
AS
BEGIN
	
	SELECT A.ID,A.ActionName,A.ActionControlID,A.MenuID,A.isActive,A.IsColumn FROM mActionAccess A 
	join mRoleMapping R ON A.ID=R.ActionID
	WHERE R.isActive = 1 AND R.RoleID = @RoleId AND R.MenuID = @MenuId and A.isActive = 1

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetUserActionAccess] TO [rt_read]
    AS [dbo];

