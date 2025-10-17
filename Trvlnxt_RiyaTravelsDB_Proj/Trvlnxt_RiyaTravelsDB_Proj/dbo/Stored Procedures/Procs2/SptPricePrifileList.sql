CREATE proc [dbo].[SptPricePrifileList]
as
begin
select h.ProfileId PROFILEID,  h1.ProfileName PROFILE ,FromRange FROMRANGE,ToRange TORANGE,Amount AMOUNT,Percentage PERCENTAGE,Currency CURRENCY from HotelDiscountDetails h
left join Hotel_Profile_Matser h1 on h.ProfileId=h1.ProfileId
	-- [dbo].[Hotel_Profile_Matser]
end

 




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SptPricePrifileList] TO [rt_read]
    AS [dbo];

