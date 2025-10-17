






CREATE proc [dbo].[GetRecord_FlightDeal]

@ID int

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
IATA_DealType,
IATA_DealValue

from Flight_Deal


where ID = @ID



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_FlightDeal] TO [rt_read]
    AS [dbo];

