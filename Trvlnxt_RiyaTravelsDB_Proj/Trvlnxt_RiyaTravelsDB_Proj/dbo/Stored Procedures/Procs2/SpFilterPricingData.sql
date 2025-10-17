CREATE proc [dbo].[SpFilterPricingData]
as
begin

select * from	[dbo].[tblVendor]		-- [dbo].[Hotel_Profile_Matser]
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpFilterPricingData] TO [rt_read]
    AS [dbo];

