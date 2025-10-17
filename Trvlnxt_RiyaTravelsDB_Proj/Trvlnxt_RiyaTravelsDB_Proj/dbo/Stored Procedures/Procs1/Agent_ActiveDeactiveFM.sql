



CREATE proc [dbo].[Agent_ActiveDeactiveFM]

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

update FlightCommission
set Flag = @Flag,
UpdatedBy=@UserID,
UpdatedDate=GETDATE() 
where ID = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactiveFM] TO [rt_read]
    AS [dbo];

