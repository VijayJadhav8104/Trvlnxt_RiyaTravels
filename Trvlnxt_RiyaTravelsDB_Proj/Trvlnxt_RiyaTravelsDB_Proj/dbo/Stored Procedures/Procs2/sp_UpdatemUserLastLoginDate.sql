CREATE PROCEDURE [dbo].[sp_UpdatemUserLastLoginDate]        
@UserName varchar(100),  
@UserLevel int,
@IsActive int
AS          
BEGIN

if(@IsActive = 1)
begin
	 if(@UserLevel = 1)  
	 begin  
	  Update mUser set LastLoginDate = GETDATE() WHERE ltrim(rtrim(UserName)) = @UserName  
	 end  
	 else  
	 begin  
	  Update AgentLogin set LastLoginDate = GETDATE() WHERE ltrim(rtrim(UserName)) = @UserName  
	 end  
End
else
begin
	if(@UserLevel = 1)  
	 begin  
	  Update mUser set isActive = @IsActive WHERE ltrim(rtrim(UserName)) = @UserName  
	 end  
	 else  
	 begin  
	  Update AgentLogin set isActive = @IsActive WHERE ltrim(rtrim(UserName)) = @UserName  
	 end
end
end
