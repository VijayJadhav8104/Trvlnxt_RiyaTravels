CREATE PROCEDURE[dbo].[GetList_Promo]
@UserId INT

as
begin

select 

m.ID,
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
SaleValidityFrom
,
SaleValidityTo,
InsertedDate,
Flag,
discounttype,
cabin,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeiresValue,
MaxAmt,
BookingType,
CASE WHEN BookingType=1 THEN 'Per Pax'  WHEN BookingType=2 THEN 'Per Sector' WHEN BookingType=3

 THEN 'Per Booking' END  AS BT,
 (CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],
M.UpdatedDate, U.Username,M.UserType,m.Remark,AgentCategory

from Flight_PromoCode m
left join mUser u ON U.ID=M.USERID
where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
ORDER BY m.ID desc




end







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Promo] TO [rt_read]
    AS [dbo];

