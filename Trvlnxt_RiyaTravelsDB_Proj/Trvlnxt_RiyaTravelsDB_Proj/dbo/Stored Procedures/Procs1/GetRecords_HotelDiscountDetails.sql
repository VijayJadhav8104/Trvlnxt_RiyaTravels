
CREATE proc [dbo].[GetRecords_HotelDiscountDetails]

@ID int

as
begin


select * from HotelDiscountDetails  where Id=@ID


end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecords_HotelDiscountDetails] TO [rt_read]
    AS [dbo];

