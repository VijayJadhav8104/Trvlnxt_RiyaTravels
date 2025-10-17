 CREATE procedure [dbo].[GetRecordServiceFeeGSTQuatation]    
    
@ID int   
    
as    
begin      
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
GETDATE()    
    
from tbl_ServiceFee_GST_QuatationDetails    
    
where ID= @ID 

end