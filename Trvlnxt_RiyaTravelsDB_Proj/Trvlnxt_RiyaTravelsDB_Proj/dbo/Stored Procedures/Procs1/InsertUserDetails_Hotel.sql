-- =============================================
-- Author:		<Dhanraj Bendale>
-- Create date: <06-06-2018>
-- Description:	<Add user Details Hotel>
-- =============================================
CREATE PROCEDURE [dbo].[InsertUserDetails_Hotel]
	 @UserId varchar(50),
	 @userName varchar(50),
	 @password varchar(50)
AS
BEGIN
	if not exists(select * from Hotel_UserMaster where UserID=@UserId)
	begin 
	 insert into Hotel_UserMaster(UserName,UserID,Passward,InsertDate,Status) values(@userName,@UserId,@password,getdate(),1)
	 select 1
	 end
	 begin
	 update Hotel_UserMaster set UserName=@userName,Passward=@password,InsertDate=GETDATE(),Status=1 where UserID=@UserId
	 select 2
	 end
END
  



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertUserDetails_Hotel] TO [rt_read]
    AS [dbo];

