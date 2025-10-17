CREATE procedure [dbo].[DeleteFM]

@ID int,
@UserID int

as
begin


insert into FlightCommissionHistory 
(
ParentId,
[Action],
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
RBD,
RBDValue,
FareBasis,
FareBasisValue,
AgencyNames,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeriesValue,
Remark,
Flag,
[FlightNovalue],
[Cabin],
PricingCode,
TourCode,
Commission,
IATADealType, 
IATADealPercent, 
PLBDealType, 
PLBDealPercent,
CRSType,
AvailabilityPCC,
PNRCreationPCC,
TicketingPCC,
IATADiscountType,
PLBDiscountType,
CardMapping1,
CardMapping2,
CardMapping3,
CardMapping4,
CardMapping5,
Endorsementline,
FlightNo,
ModifiedBy,
FareType,
MarkupType,
MarkupAmount,
MarkupDealType,
PaxType,
[UserType]
      ,[AgencyId]
      ,[AgentCategory]
      ,[ConfigurationType]
      ,[SOTO]
      ,[UserID]
      ,[MarketPoint]
      ,[AirportType]
      ,[AirlineType]
)
select 
Id,
'Delete',
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
RBD,
RBDValue,
FareBasis,
FareBasisValue,
AgencyNames,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeriesValue,
Remark,
Flag,
[FlightNovalue],
[Cabin],
PricingCode,
TourCode,
Commission,
IATADealType, 
IATADealPercent, 
PLBDealType, 
PLBDealPercent,
CRSType,
AvailabilityPCC,
PNRCreationPCC,
TicketingPCC,
IATADiscountType,
PLBDiscountType,
CardMapping1,
CardMapping2,
CardMapping3,
CardMapping4,
CardMapping5,
Endorsementline,
FlightNo,
@UserID,
FareType,
MarkupType,
MarkupAmount,
MarkupDealType,
PaxType,
[UserType]
      ,[AgencyId]
      ,[AgentCategory]
      ,[ConfigurationType]
      ,[SOTO]
      ,[UserID]
      ,[MarketPoint]
      ,[AirportType]
      ,[AirlineType]
from FlightCommission where id=@ID

delete from FlightCommission where ID= @ID

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteFM] TO [rt_read]
    AS [dbo];

