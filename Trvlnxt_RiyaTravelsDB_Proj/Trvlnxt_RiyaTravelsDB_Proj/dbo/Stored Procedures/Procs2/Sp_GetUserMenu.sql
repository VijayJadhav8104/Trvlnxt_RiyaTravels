  
CREATE PROCEDURE [dbo].[Sp_GetUserMenu]   
 @UserId int  
AS  
BEGIN  
    DECLARE @RoleId int  
  
    SELECT @RoleId=RoleID FROM mUser WHERE ID = @UserId AND isActive = 1  
  
     SELECT  ID AS MenuID,MenuName, Path,ParentMenuID,Module,ItemOrder FROM  mMenu   
    where ID in(select distinct MenuID from mRoleMapping where RoleID=@RoleId and isActive=1 or ParentMenuID=14) and Module='Console'  
    and isActive=1   
    order by ItemOrder  
  
    --SELECT M.ID AS MenuID,M.MenuName, M.Path,M.ParentMenuID FROM  mMenu M  
    --JOIN mRoleMapping R ON R.MenuID = M.ID  
    --WHERE R.RoleID = @RoleId AND M.isActive = 1 and R.IsActive =1   
    --ORDER BY ItemOrder  
     
    
END  
  


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetUserMenu] TO [rt_read]
    AS [dbo];

