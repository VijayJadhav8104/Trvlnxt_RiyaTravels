CREATE PROCEDURE Sp_CheckPageRightsNew     
 @UserId   int,    
 @Url   varchar(64)    
AS BEGIN    
    
 DECLARE @Result int,@MenuID int,@RoleID int    
     
 SELECT @MenuID = ID FROM mMenu WHERE NewPath ='~/'+ @Url and Module='ConsoleNew'    
 SELECT @RoleID=RoleID FROM mUser WHERE ID=@UserId    
    
 IF(EXISTS(SELECT 1 FROM mRoleMapping WHERE RoleID=@RoleID and MenuID=@MenuID and isActive=1))    
 BEGIN    
  SET @Result = 1    
 END    
 ELSE    
  BEGIN    
   SET @Result = 0    
  END    
 SELECT @Result    
    
END 