

CREATE proc [dbo].[SpUpdatetHotelDiscount]
@ID int,
@FromRange bigint,
@ToRange bigint,
@Amount bigint,
@Percentage decimal(18, 0),
--@ProfileId bigint,
@VendorId bigint,
@txtCurrency varchar(10),
@CountryId bigint
as
begin

--declare 
--@ID int=4,
----@FromRange bigint=300,
----@ToRange bigint=500,

--@Amount bigint=55,
--@Percentage decimal(18, 0)= 2,
--@VendorId bigint=13,
--@txtCurrency varchar(10)='INR',
--@CountryId bigint=1

IF not exists(select * from HotelDiscountDetails where  VendorId=@VendorId and Percentage=@Percentage and Amount=@Amount and IsActive is null and Id=@ID)
begin

Update HotelDiscountDetails

set 
--FromRange = @FromRange,
--ToRange=@ToRange,
Amount=@Amount,
Percentage=@Percentage,
--ProfileId=@ProfileId,
VendorId=@VendorId,
txtCurrency=@txtCurrency
,CountryId=@CountryId
where Id= @ID

--select '1'
end



end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpUpdatetHotelDiscount] TO [rt_read]
    AS [dbo];

