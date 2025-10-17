



CREATE proc [dbo].[GetList_FlightDeal]


as
begin


select
ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
DealType,
DealValue,
SOTO,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
RBD,
RBDValue,
FareBasis,
FareBasisValue,
FlightSeries,
FlightSeriesValue,
Origin,
OriginValue,
Destination,
DestinationValue,
InsertedDate,
GroupType,
Name,
Flag,
IATA_DealType,
IATA_DealValue

from Flight_Deal

ORDER BY  ID DESC



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_FlightDeal] TO [rt_read]
    AS [dbo];

