

CREATE proc [dbo].[GetRecordSpGetProfileList]
@VendorID int=0,
@countryID int=0
as
begin
select * from	[dbo].[HotelContryCurrency]	 where CountryId=@countryID
select * from	[dbo].[tblVendor] where Id=@VendorID		-- [dbo].[Hotel_Profile_Matser]
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecordSpGetProfileList] TO [rt_read]
    AS [dbo];

