






CREATE procedure [dbo].[Delete_Promocode]

@ID int,
@DeletedBy varchar(50)

as
begin

if Exists (select * from Flight_PromoCode where ID= @ID)
begin

Insert into FlightPromocode_Delete
(

MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
Flag,
DeletedDate,
DeletedBy,
PromoID,
discounttype,
cabin,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeiresValue

)

select 


MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
Flag,
GETDATE(),
@DeletedBy,
ID,
discounttype,
cabin,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeiresValue



from Flight_PromoCode

where ID= @ID


delete from Flight_PromoCode where ID= @ID


end








end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_Promocode] TO [rt_read]
    AS [dbo];

