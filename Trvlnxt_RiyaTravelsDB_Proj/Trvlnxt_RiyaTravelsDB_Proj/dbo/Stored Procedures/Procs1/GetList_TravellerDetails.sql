




CREATE proc [dbo].[GetList_TravellerDetails] --GetList_TravellerDetails 10049

@userid int

as
begin

select 
UserID as ID,
'You' as name,
Title,
FirstName,
LastName,
UserName as  AlternateEmailID,
MobileNumber,
'' as userID,
DateOfBirth,
'block' as button1,
'none' as button2


 from UserLogin
  where UserID=@userid

  union all

select 
TravellerID as ID,
FirstName as name,
Title,
FirstName,
LastName,
AlternateEmailID,
MobileNumber,
UserID as UserID,
DateOfBirth,
'none' as button1,
'block' as button2
from tblTraveller
where UserID=@userid and DeleteFlag is null



end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_TravellerDetails] TO [rt_read]
    AS [dbo];

