-- =============================================
-- Author:		Bhavika kawa
-- Description:	TO get User Type based on  User rights
-- =============================================
create PROCEDURE [dbo].[Sp_GetUserType]
@UserId int
AS
BEGIN
	select   c.ID,C.Value AS UserType from mUserTypeMapping UT
			INNER JOIN mCommon C ON C.ID=UT.UserTypeId where UT.UserID=@Userid  AND IsActive=1 
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetUserType] TO [rt_read]
    AS [dbo];

