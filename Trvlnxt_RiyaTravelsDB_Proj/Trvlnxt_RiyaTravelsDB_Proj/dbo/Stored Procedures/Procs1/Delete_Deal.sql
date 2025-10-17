


CREATE procedure [dbo].[Delete_Deal]

@ID int,
@DeletedBy varchar(50)

as
begin

if Exists (select * from Flight_Deal where ID= @ID)
begin

Insert into FlightDeal_Delete
(
MarketPoint,
AirportType,
AirlineType,
PaxType,
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
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeriesValue,
InsertedDate,
GroupType,
Name,
Remark,
DeletedBy,
DeletedDate
)

select 
MarketPoint,
AirportType,
AirlineType,
PaxType,
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
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeriesValue,
InsertedDate,
GroupType,
Name,
Remark,
@DeletedBy,
GETDATE()

from Flight_Deal

where ID= @ID


delete from Flight_Deal where ID= @ID


end








end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_Deal] TO [rt_read]
    AS [dbo];

