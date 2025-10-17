  
CREATE procedure [dbo].[Delete_ServiceFee_GST_Quatation]  
  
@ID int,  
@DeletedBy varchar(50)  
  
as  
begin  
  
if Exists (select * from tbl_ServiceFee_GST_QuatationDetails where ID= @ID)  
begin  
  
Insert into tbl_ServiceFee_GST_QuatationDetailsDelete  
(  
MarketPoint,  
AirportType,  
AirlineType,  
UserType,  
GroupType,  
AgencyId,  
AgentCategory,  
AgencyNames,  
Remark,  
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
Flag,  
FlightNo,  
FlightNoValue,  
Cabin,  
ServiceFee,  
Currency,  
GST,  
Quatation,  
DeletedBy,  
DeletedOn  
)  
  
select   
MarketPoint,  
AirportType,  
AirlineType,  
UserType,  
GroupType,  
AgencyId,  
AgentCategory,  
AgencyNames,  
Remark,  
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
Flag,  
FlightNo,  
FlightNoValue,  
Cabin,  
ServiceFee,  
Currency,  
GST,  
Quatation,  
@DeletedBy,  
GETDATE()  
  
from tbl_ServiceFee_GST_QuatationDetails  
  
where ID= @ID  
  
  
delete from tbl_ServiceFee_GST_QuatationDetails where ID= @ID  
  
  
end  
  
  
  
  
  
  
  
  
end  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_ServiceFee_GST_Quatation] TO [rt_read]
    AS [dbo];

