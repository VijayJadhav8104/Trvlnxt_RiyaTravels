
	CREATE PROCEDURE [dbo].[Sp_GetUserMenu_New]   
	 @UserId int=1195  
	AS  
	BEGIN  
		DECLARE @RoleId int  
  
		SELECT @RoleId=RoleID FROM mUser WHERE ID = 1195 AND isActive = 1  
  
		 SELECT  ID AS MenuID,MenuName, Path,ParentMenuID,Module,ItemOrder,MenuUrl,MenuIcon FROM  mMenu   
		where ID in(select distinct MenuID from mRoleMapping where RoleID=@RoleId and isActive=1) and Module='ConsoleMigration'  
		and isActive=1   
		order by ItemOrder  
  
		--SELECT M.ID AS MenuID,M.MenuName, M.Path,M.ParentMenuID,Module,ItemOrder FROM  mMenu M  
		--JOIN mRoleMapping R ON R.MenuID = M.ID  
		--WHERE R.RoleID = @RoleId AND M.isActive = 1 and R.IsActive =1 and Module='Console'  
		--ORDER BY ItemOrder  
     
    
	END




--	alter table mMenu add MenuUrl varchar(200),MenuIcon varchar(50)

--/BookingSearch/Index	bi bi-map


select *from mMenu where MenuName like '%hotel console%'
select * from mUser where FullName like '%Aman%'

--Update mMenu set MenuUrl='/BookingSearch/Index',MenuIcon='bi bi-map' where ID=1082

