
--sp_helptext sp_GetUserDataForCharter

CREATE PROCEDURE [dbo].[sp_GetUserDataForCharter]

@UserName VARCHAR(50)

AS
BEGIN

declare @MyUserName varchar(50);

SELECT @MyUserName=UserName from mUser where UserName=@UserName and isActive=1

if(@MyUserName IS NOT NULL)

BEGIN

SELECT FullName, UserName, EmailID as EmailId, MobileNo, 'Trvntx User' as UserType, ID as UserId  from mUser where UserName=@UserName and isActive=1
END

ELSE 

BEGIN

SELECT TOP 1 (FirstName+LastName) as FullName, UserName, AddrEmail as EmailId, MobileNumber as MobileNo, 'Trvntx Agent' as UserType, UserID as UserId from AgentLogin 

LEFT JOIN B2BRegistration ON AgentLogin.UserID=B2BRegistration.FKUserID

where UserName=@UserName and isActive=1

END

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetUserDataForCharter] TO [rt_read]
    AS [dbo];

