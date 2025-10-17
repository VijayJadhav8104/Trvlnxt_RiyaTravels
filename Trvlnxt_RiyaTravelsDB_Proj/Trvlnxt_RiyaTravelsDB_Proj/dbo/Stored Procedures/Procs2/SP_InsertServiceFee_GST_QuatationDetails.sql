CREATE proc [dbo].[SP_InsertServiceFee_GST_QuatationDetails]  
  
@MarketPoint varchar(30),  
@AirportType varchar(50),  
@AirLineCode varchar(30),  
@userType varchar(10),  
@TravelValidity_From datetime,  
@TravelValidity_To datetime,  
@SalesValidity_From datetime,  
@SalesValidity_To datetime,  
@RBD  bit,  
@RBDValue varchar(max)=null,  
@FareBasis bit,  
@FareBasisValue varchar(max)=null,  
@AgentCategory varchar(max)=null,  
@AgencyNames varchar(max)=null,  
@AgencyId varchar(max)=null,  
@Origin  bit,  
@OriginValue varchar(max)=null,  
@Destination bit,  
@DestinationValue varchar(max)=null,  
@FlightSeries bit,  
@FlightSeriesValue varchar(max)=null,  
@Remark varchar(max)= null,  
@FlightNo varchar(max),  
@Cabin varchar(max),  
@ServiceFee Decimal(18,2)= NULL,  
@GST int= Null,  
@Quatation int =null,  
@BookingType int=null,  
@FlightNoCheck  bit,  
@GroupType varchar(100)=null,  
@UserID int,  
@AircodeList varchar(max),  
@Currency varchar(10),  
@TransactionType varchar(50), 
@CRSType  varchar(50)=null, 
@AvailabilityPCC varchar(50)=null,
@OriginCountry VARCHAR(MAX)=NULL,
@DestinationCountry VARCHAR(MAX)=NULL,
@ERROR VARCHAR(50) OUT   
as  
begin  
  
--if  exists(select id from tbl_ServiceFee_GST_QuatationDetails where AgentCategory=@AgentCategory and MarketPoint=@MarketPoint and userType=@userType) and (@AgentCategory !='')  
--begin  
-- set @ERROR=  'Category already exist'  
--end  
--ELSE if exists(select id from tbl_ServiceFee_GST_QuatationDetails where  MarketPoint=@MarketPoint and userType=@userType   
--       and @TravelValidity_From between TravelValidityFrom and TravelValidityTo and @TravelValidity_To between TravelValidityFrom and TravelValidityTo   
--    AND @SalesValidity_From between SaleValidityFrom and SaleValidityTo AND @SalesValidity_To between SaleValidityFrom and SaleValidityTo  
--    and airlinetype in( select DATA from sample_split(@AircodeList,',')) )  
--BEGIN  
-- set @ERROR=  'Record already exist'  
--END   
  
insert into tbl_ServiceFee_GST_QuatationDetails   
(  
MarketPoint,  
AirportType,  
AirlineType,  
UserType,  
TravelValidityFrom,  
TravelValidityTo,  
SaleValidityFrom,  
SaleValidityTo,  
RBD,  
RBDValue,  
FareBasis,  
FareBasisValue,  
AgencyId,  
AgencyNames,  
AgentCategory,  
Origin,  
OriginValue,  
Destination,  
DestinationValue,  
FlightSeries,  
FlightSeriesValue,  
InsertedDate,  
Remark,  
Flag,  
[FlightNovalue],  
[Cabin],  
[ServiceFee],  
[GST],  
[Quatation],  
FlightNo,  
GroupType,  
UserID,  
BookingType,  
Currency ,
TransactionType,
CRSType,
AvailabilityPCC,OriginCountry,DestinationCountry
)  
Values  
(  
@MarketPoint ,  
@AirportType ,  
@AircodeList ,  
@userType,  
@TravelValidity_From ,  
DATEADD(s,86399,@TravelValidity_To),  
@SalesValidity_From ,  
DATEADD(s,86399,@SalesValidity_To),  
@RBD  ,  
@RBDValue ,  
@FareBasis ,  
@FareBasisValue ,  
@AgencyId,  
@AgencyNames,  
@AgentCategory,  
@Origin  ,  
@OriginValue ,  
@Destination ,  
@DestinationValue ,  
@FlightSeries ,  
@FlightSeriesValue ,  
getdate(),  
@Remark,  
1,  
@FlightNo,  
@Cabin,  
@ServiceFee,  
@GST,  
@Quatation,  
@FlightNoCheck,  
@GroupType,  
@UserID,  
@BookingType,  
@Currency ,
@TransactionType,
@CRSType, 
@AvailabilityPCC,@OriginCountry,@DestinationCountry
)  
end 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertServiceFee_GST_QuatationDetails] TO [rt_read]
    AS [dbo];

