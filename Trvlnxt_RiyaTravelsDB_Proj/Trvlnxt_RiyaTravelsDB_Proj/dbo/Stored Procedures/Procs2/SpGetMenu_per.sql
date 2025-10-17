CREATE proc [dbo].[SpGetMenu_per]-- 1,'Administrator'
@userId int
,@UserName varchar(50)
AS
Begin
declare @uid nvarchar(20)
set @uid= (select UserId from Hotel_UserMaster where  PkId=@userId)
if exists (select * from [Hotel_admin_Master] where FullName=@UserName and Id=@userId)
begin
select * from [dbo].[Hotel_MenuNew] where [UserId]=@userId
end
else
begin 
select HP.Id,Action,Controller,Title from Hotel_MenuNew HM inner join Hotel_userPermission HP on HP.MenuId=HM.Id where HP.UserId= @uid
end
End





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpGetMenu_per] TO [rt_read]
    AS [dbo];

