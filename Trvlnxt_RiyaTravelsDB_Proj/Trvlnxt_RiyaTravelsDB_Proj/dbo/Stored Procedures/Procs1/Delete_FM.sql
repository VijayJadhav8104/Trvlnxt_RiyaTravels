CREATE procedure [dbo].[Delete_FM]

@ID int,
@UserID int

as
begin


insert into Flight_CommissionHistory 
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
  [Queueno]
      ,[EmailId]
      ,[TicketingAccess]
      ,[OTP]
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
  [Queueno]
      ,[EmailId]
      ,[TicketingAccess]
      ,[OTP]
from Flight_Commission where id=@ID

delete from Flight_Commission where ID= @ID

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_FM] TO [rt_read]
    AS [dbo];

