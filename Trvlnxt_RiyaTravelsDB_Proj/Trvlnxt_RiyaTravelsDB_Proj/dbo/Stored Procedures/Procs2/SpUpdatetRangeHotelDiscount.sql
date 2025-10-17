

CREATE proc [dbo].[SpUpdatetRangeHotelDiscount]
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
--@FromRange bigint=300,
--@ToRange bigint=500,

--@Amount bigint=55,
--@Percentage decimal(18, 0)= 2,
--@VendorId bigint=13,
--@txtCurrency varchar(10)='INR',
--@CountryId bigint=1

IF not exists(select * from HotelDiscountDetails where @FromRange between FromRange and ToRange or @ToRange between FromRange and ToRange and VendorId=@VendorId and txtCurrency=@txtCurrency and IsActive is null)
begin

Update HotelDiscountDetails

set FromRange = @FromRange,
ToRange=@ToRange,
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
    ON OBJECT::[dbo].[SpUpdatetRangeHotelDiscount] TO [rt_read]
    AS [dbo];

