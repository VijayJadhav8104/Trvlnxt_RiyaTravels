-- =============================================
-- Author:		<Dhanraj Bendale>
-- Create date: <11-06-2018>
-- Description:	<Delete user permission hotel>
-- =============================================
CREATE PROCEDURE [dbo].[Delete_HotelPermission]
	 @UserId varchar(50)
	 
AS
BEGIN
	 delete from Hotel_userPermission where UserId=@UserId
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_HotelPermission] TO [rt_read]
    AS [dbo];

