CREATE proc [dbo].[Update_Deal]

@ID int,
@MarketPoint varchar(30),
@AirportType varchar(50),
@AirLineCode varchar(30),
@PaxType varchar(50),
@DealType varchar(50),
@DealValue numeric(18,2),
@SOTO bit,
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
@FlightSeriesValue varchar(max)=null,
@GroupType varchar(50)= null,
@Name varchar(100)= null,
@Remark varchar(max)= null,
@IATA_DealType varchar(50)=null,
@OriginCountry VARCHAR(MAX)=NULL,
@DestinationCountry VARCHAR(MAX)=NULL,
@IATA_DealValue numeric(18,2)=0


as
begin

update Flight_Deal
set

MarketPoint= @MarketPoint,
AirportType=@AirportType,
AirlineType= @AirLineCode,
PaxType=@PaxType,
Remark=@Remark,
DealType= @DealType,
DealValue=@DealValue,
SOTO=@SOTO,
TravelValidityFrom=@TravelValidity_From,
TravelValidityTo=DATEADD(s, 43199,@TravelValidity_To),
SaleValidityFrom=@SalesValidity_From,
SaleValidityTo=DATEADD(s, 43199,@SalesValidity_To),--@SalesValidity_To,
RBD=@RBD,
RBDValue=@RBDValue,
FareBasis=@FareBasis,
FareBasisValue=@FareBasisValue,
FlightSeries=@FlightSeries,
FlightSeriesValue= @FlightSeriesValue,
Origin=@Origin,
OriginValue=@OriginValue,
Destination=@Destination,
DestinationValue=@DestinationValue,
InsertedDate=GETDATE(),
GroupType=@GroupType,
Name=@Name,
IATA_DealType=@IATA_DealType,
IATA_DealValue=@IATA_DealValue,
OriginCountry=@OriginCountry,
DestinationCountry=@DestinationCountry


where ID = @ID



end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_Deal] TO [rt_read]
    AS [dbo];

