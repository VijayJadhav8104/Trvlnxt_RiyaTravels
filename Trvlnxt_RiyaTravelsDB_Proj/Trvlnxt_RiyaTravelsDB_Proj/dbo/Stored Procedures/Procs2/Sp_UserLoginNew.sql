CREATE PROCEDURE [dbo].[Sp_UserLoginNew]             
            
 @userID varchar(20),            
 @passwd varchar(128),            
 @IP  varchar(20),            
 @Device varchar(20),            
 @SessionID VARCHAR(50),          
 @Flag varchar(50)=null          
AS            
BEGIN            
             
 IF(EXISTS(SELECT 1 FROM mUser where  UserName=@userID )) --and  [Password]=@passwd           
  BEGIN            
          
   INSERT INTO LoginHistory(IP, Device, UserId, Status)            
   VALUES(@IP,@Device,@userID,'Success')            
   SELECT TOP 1 U.Id,U.FullName, M.Path,M.NewPath, U.IsResetPassword, U.RoleID,U.UserTypeId            
   From mUser U            
   JOIN  mRoleMapping R ON R.RoleID = U.RoleID            
   JOIN mMenu M ON R.MenuID = M.ID            
   where  U.UserName=@userID  AND R.IsActive = 1       
   AND M.NewPath is not null and M.NewPath <> ''-- need to change once path set      
   and m.Module='ConsoleNew'  AND M.MenuName <> 'Reports'            
   ORDER BY M.ItemOrder            
  --and  U.[Password]=@passwd          
   --Check to restrict multiple session for same user           
    --UPDATE mUser SET  SessionID=@SessionID WHERE   UserName=@userID and  [Password]=@passwd                
             
   if(@Flag='ConsoleNew')          
   begin           
    UPDATE mUser SET ConsoleSessionID=@SessionID WHERE   UserName=@userID           
 --and  [Password]=@passwd            
   end          
   else          
   begin          
    UPDATE mUser SET  SessionID=@SessionID WHERE   UserName=@userID           
 --and  [Password]=@passwd                
   end          
            
            
            
  END            
 ELSE            
 BEGIN            
  INSERT INTO LoginHistory(IP, Device, UserId, Status)            
   VALUES(@IP,@Device,@userID,'Failed')            
 END            
            
END 