-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EditUserDetails_Hotel]
	 @UserId varchar(20)
AS
BEGIN
	 select * from Hotel_UserMaster where UserID=@UserId
	 select Action,m.Id from Hotel_MenuNew m inner join Hotel_userPermission u on u.MenuId=m.Id
	  where u.UserId=@UserId
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[EditUserDetails_Hotel] TO [rt_read]
    AS [dbo];

