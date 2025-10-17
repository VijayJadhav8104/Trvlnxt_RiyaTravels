

CREATE  proc [dbo].[SpInsertHotelDiscount] --1,2,100,1,1,5,'CAD',4
@FromRange bigint,
@ToRange bigint,
@Amount bigint=0,
@Percentage decimal(18, 0)=0.0,
@ProfileId int,
@VendorId bigint,
@txtCurrency varchar(10),
@CountryId bigint
as
begin
IF not exists(select * from HotelDiscountDetails where (@FromRange between FromRange and ToRange or @ToRange between FromRange and ToRange) and VendorId=@VendorId and txtCurrency=@txtCurrency and IsActive is null)
begin
insert into HotelDiscountDetails(FromRange,ToRange,Amount,Percentage,ProfileId,VendorId,txtCurrency,CountryId) values(@FromRange,@ToRange,@Amount,@Percentage,@ProfileId,@VendorId,@txtCurrency,@CountryId)
select 1;
end
else 
begin
select 0;
end
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpInsertHotelDiscount] TO [rt_read]
    AS [dbo];

