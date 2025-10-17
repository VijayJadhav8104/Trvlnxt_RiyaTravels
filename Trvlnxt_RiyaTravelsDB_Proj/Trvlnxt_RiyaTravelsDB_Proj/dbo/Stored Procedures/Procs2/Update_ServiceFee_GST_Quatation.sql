CREATE proc [dbo].[Update_ServiceFee_GST_Quatation]  
  
@ID int,  
@MarketPoint varchar(30),  
@AirportType varchar(50),  
@AirLineCode varchar(max),  
@GroupType varchar(50),  
@FlightNo bit,  
@FlightNoValue varchar(max),  
@TravelValidity_From datetime,  
@TravelValidity_To datetime,  
@SalesValidity_From datetime,  
@SalesValidity_To datetime,  
@RBD  bit,  
@RBDValue varchar(max)=null,  
@FareBasis bit,  
@FareBasisValue varchar(max)=null,  
@Origin  bit,  
@OriginValue varchar(max)=null,  
@Destination bit,  
@DestinationValue varchar(max)=null,  
@FlightSeries bit,  
@AgentCategory varchar(max)=null,  
@AgencyNames varchar(max)=null,  
@AgencyId varchar(max)=null,  
@FlightSeriesValue varchar(max)=null,  
@Remark varchar(max)= null,  
@Cabin varchar(max),  
@ServiceFee Decimal(18,2)= NULL,  
@GST int= Null,  
@Quatation int =null,  
@BookingType int=null,  
@UserID int,  
@Currency varchar(10),
@TransactionType Varchar(50)=null , 
@CRSType  varchar(50)=null, 
@OriginCountry VARCHAR(MAX)=NULL,
@DestinationCountry VARCHAR(MAX)=NULL,
@AvailabilityPCC varchar(50)=null 
as  
begin  
  
update tbl_ServiceFee_GST_QuatationDetails  
set  
  
--MarketPoint= @MarketPoint,  
--AirportType=@AirportType,  
AirlineType= @AirLineCode,  
GroupType=@GroupType,  
Remark=@Remark,  
TravelValidityFrom=@TravelValidity_From,  
TravelValidityTo=DATEADD(s, 43199,@TravelValidity_To),  
SaleValidityFrom=@SalesValidity_From,  
SaleValidityTo=DATEADD(s, 43199,@SalesValidity_To),  
RBD=@RBD,  
RBDValue=@RBDValue,  
FlightNo=@FlightNo,  
FlightNoValue=@FlightNoValue,  
FareBasis=@FareBasis,  
FareBasisValue=@FareBasisValue,  
FlightSeries=@FlightSeries,  
FlightSeriesValue= @FlightSeriesValue,  
Origin=@Origin,  
OriginValue=@OriginValue,  
Destination=@Destination,  
DestinationValue=@DestinationValue,  
InsertedDate=GETDATE(),  
AgencyNames=@AgencyNames,  
AgentCategory=@AgentCategory,  
AgencyId=@AgencyId,  
Cabin=@Cabin,  
ServiceFee=@ServiceFee,  
GST=@GST,  
Quatation=@Quatation,  
UserID=@UserID,  
UpdatedDate=GETDATE() ,  
BookingType=@BookingType,  
Currency=@Currency ,
TransactionType=@TransactionType,
CRSType=@CRSType,
AvailabilityPCC=@AvailabilityPCC,
OriginCountry=@OriginCountry,
DestinationCountry=@DestinationCountry
where ID = @ID  
  
  
  
end 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_ServiceFee_GST_Quatation] TO [rt_read]
    AS [dbo];

