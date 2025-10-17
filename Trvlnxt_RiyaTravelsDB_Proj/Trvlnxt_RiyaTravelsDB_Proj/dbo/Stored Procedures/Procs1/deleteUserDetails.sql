-- =============================================
-- Author:		<Dhanraj Bendale>
-- Create date: <11-06-2018>
-- Description:	<Delete user permission hotel>
-- =============================================
CREATE PROCEDURE [dbo].[deleteUserDetails]
	 @UserId varchar(50)
	 
AS
BEGIN
if exists(select * from Hotel_UserMaster where UserID=@UserId)
begin
		update Hotel_UserMaster set Status=0 where UserID=@UserId
		delete from Hotel_userPermission where UserId=@UserId
		select 1
	 end
	 else
	  begin 
	  select 0 
	  end
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[deleteUserDetails] TO [rt_read]
    AS [dbo];

