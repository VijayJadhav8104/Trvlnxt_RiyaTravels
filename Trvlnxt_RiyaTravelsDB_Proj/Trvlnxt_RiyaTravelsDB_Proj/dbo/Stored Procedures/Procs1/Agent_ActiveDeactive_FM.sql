CREATE proc [dbo].[Agent_ActiveDeactive_FM]

@ID int,
@Flag bit,
@UserID int

as
begin

declare @Action varchar(10)

if(@Flag=1)
begin
	set @Action='Active'
end
else
begin
	set @Action='DeActive'
end

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
@Action,
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

update Flight_Commission
set Flag = @Flag
where ID = @ID

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactive_FM] TO [rt_read]
    AS [dbo];

