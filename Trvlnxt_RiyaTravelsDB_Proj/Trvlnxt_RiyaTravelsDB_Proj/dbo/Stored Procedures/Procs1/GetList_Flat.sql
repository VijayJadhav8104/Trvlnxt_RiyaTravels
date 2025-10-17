CREATE PROCEDURE[dbo].[GetList_Flat]
@UserId INT

as
begin

select 

f.ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
InsertedDate,
Flag,
Origin,
OriginValue,
Destination,
DestinationValue,
Flightseries,
FlightseriesValue,
cabin,
GroupType,
Name,
(CONVERT(varchar, TravelFrom, 105) + ' - ' + CONVERT(varchar, TravelTo, 105)) as [TravelValidity],
(CONVERT(varchar, SaleFrom, 105) + ' - ' + CONVERT(varchar, SaleTo, 105)) as [SaleValidity],
f.UpdatedDate, U.Username,f.UserType,AgentCategory

from Flight_Flat f
left join mUser u ON U.ID=f.USERID 
where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
ORDER BY f.ID DESC
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Flat] TO [rt_read]
    AS [dbo];

