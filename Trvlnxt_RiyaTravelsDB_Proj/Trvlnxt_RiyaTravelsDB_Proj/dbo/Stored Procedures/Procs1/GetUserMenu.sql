


CREATE PROCEDURE [dbo].[GetUserMenu] 
	@UserId int
AS
BEGIN
	   SELECT M.MenuID,M.MenuName, M.Path,M.ParentMenuID FROM  Menu M
	   JOIN RoleAccess R ON R.MenuID = M.MenuID
	   WHERE R.UserID = @UserId AND M.Status = 1 and R.IsActive =1 
	   ORDER BY OrderID
	  
		
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetUserMenu] TO [rt_read]
    AS [dbo];

