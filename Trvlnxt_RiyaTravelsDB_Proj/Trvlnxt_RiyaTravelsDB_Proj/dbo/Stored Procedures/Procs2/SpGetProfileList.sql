CREATE proc [dbo].[SpGetProfileList]
as
begin
select * from	[dbo].[HotelContryCurrency]	
select * from	[dbo].[tblVendor]		-- [dbo].[Hotel_Profile_Matser]
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpGetProfileList] TO [rt_read]
    AS [dbo];

