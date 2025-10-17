CREATE proc [dbo].[spGetAPIUserDetails]
as
begin
 select * from [dbo].[HotelAPIUser] 
 select * from HotelAPIUser_Markup
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetAPIUserDetails] TO [rt_read]
    AS [dbo];

