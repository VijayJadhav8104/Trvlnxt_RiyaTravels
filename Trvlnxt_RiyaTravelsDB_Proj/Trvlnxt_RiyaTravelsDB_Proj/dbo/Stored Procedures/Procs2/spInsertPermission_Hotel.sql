-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spInsertPermission_Hotel]
	 @userId varchar(50),
	 @Id int
AS
BEGIN
	 insert Into Hotel_userPermission(UserId,MenuId,updateon)
	 values(@userId,@Id,getdate())
	 --select 1
	 END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertPermission_Hotel] TO [rt_read]
    AS [dbo];

