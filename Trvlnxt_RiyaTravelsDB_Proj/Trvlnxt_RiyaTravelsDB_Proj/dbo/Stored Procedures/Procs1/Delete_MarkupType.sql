      
CREATE PROCEDURE [dbo].[Delete_MarkupType]      
@ID int,      
@DeletedBy varchar(50)      
      
as      
begin      
      
if (@ID >0)    
      
    
 begin      
INSERT INTO [dbo].[Flight_MarkupTypeHistory]       ([Action],MarketPoint,AirportType,AirlineType,PaxType,Remark, TravelValidityFrom,TravelValidityTo,SaleValidityFrom,SaleValidityTo,GroupType,Name, FareTypeRU,CalculationTypeRU,ValPerRU,
FareTypeRP,CalculationTypeRP,ValPerRP, RUMaxAmt,RPMaxAmt,DisplayTypeRP,DisplayTypeRU,BookingTypeRP,BookingTypeRU, UserType,AgencyId,AgentCategory,AgencyNames,UserID,UpdatedDate, RBD,RBDValue,FareBasis,FareBasisValue,Origin,OriginValue, Destination,
DestinationValue,FlightSeries,FlightSeriesValue,FlightNo,FlightNoValue,
Cabin,FareTypeM,CalculationTypeM,ValPerM,MmaxAmt,DisplayTypeM,
BookingTypeM,TransactionType,CRSType,AvailabilityPCC,OriginCountry,
DestinationCountry)       
        
select 'Delete',MarketPoint,AirportType,AirlineType,PaxType, Remark,TravelValidityFrom,TravelValidityTo,SaleValidityFrom,SaleValidityTo, GroupType,Name,FareTypeRU,CalculationTypeRU,ValPerRU, FareTypeRP,CalculationTypeRP,
ValPerRP,RUMaxAmt,RPMaxAmt, DisplayTypeRP,
DisplayTypeRU,BookingTypeRP,BookingTypeRU,UserType, 
AgencyId,AgentCategory,AgencyNames,@DeletedBy,getdate(), 
RBD,RBDValue,FareBasis,FareBasisValue,Origin, OriginValue,
Destination,DestinationValue,FlightSeries,FlightSeriesValue, 
FlightNo,FlightNoValue,Cabin,FareTypeM,CalculationTypeM, 
ValPerM,MmaxAmt,DisplayTypeM,BookingTypeM,TransactionType, 
CRSType,AvailabilityPCC,OriginCountry,DestinationCountry 
from Flight_MarkupType where id=@ID  
    
    
  delete from Flight_MarkupType where ID= @ID      
  and MarketPoint in (select C.CountryCode  from mUserCountryMapping UM      
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@DeletedBy  AND IsActive=1)      
 end      
 else      
 begin      
 delete from Flight_MarkupType where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM      
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@DeletedBy  AND IsActive=1)      
 end      
      
end    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Delete_MarkupType] TO [rt_read]
    AS [dbo];

