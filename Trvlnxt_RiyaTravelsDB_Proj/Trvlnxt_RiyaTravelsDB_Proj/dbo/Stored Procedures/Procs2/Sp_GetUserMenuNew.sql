CREATE PROCEDURE [dbo].[Sp_GetUserMenuNew]         
 @UserId int        
AS        
BEGIN        
    DECLARE @RoleId int        
        
    SELECT @RoleId=RoleID FROM mUser WHERE ID = @UserId AND isActive = 1        
        
SELECT  ID AS MenuID,MenuName,NewPath as [Path],ParentMenuID,Module,ItemOrder FROM  mMenu         
    where ID in(select distinct MenuID from mRoleMapping where RoleID=@RoleId and isActive=1
	and menuid in (select id from mmenu where module='ConsoleNew' and isActive=1)) and Module='ConsoleNew'        
    and isActive=1         
    order by ItemOrder       
        
    --SELECT M.ID AS MenuID,M.MenuName, M.Path,M.ParentMenuID,Module,ItemOrder FROM  mMenu M        
    --JOIN mRoleMapping R ON R.MenuID = M.ID        
    --WHERE R.RoleID = @RoleId AND M.isActive = 1 and R.IsActive =1 and Module='Console'        
    --ORDER BY ItemOrder        
           
          
END