    
CREATE PROCEDURE [dbo].[Sp_GetUserRoleID]     
 @UserId int    
AS    
BEGIN       
    
    SELECT Roleid FROM mUser WHERE ID = @UserId AND isActive = 1    
      
END 