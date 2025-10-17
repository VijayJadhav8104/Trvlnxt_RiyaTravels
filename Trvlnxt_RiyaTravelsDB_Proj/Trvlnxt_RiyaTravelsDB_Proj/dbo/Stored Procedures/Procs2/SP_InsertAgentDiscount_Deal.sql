CREATE proc [dbo].[SP_InsertAgentDiscount_Deal]

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
@IATA_DealValue numeric(18,2)
--@ERROR VARCHAR(100) OUT 

as
begin

if not exists(select *  from Flight_Deal where MarketPoint=@MarketPoint and AirportType=@AirportType and AirlineType=@AirLineCode and GroupType=@GroupType and @TravelValidity_From between TravelValidityFrom and TravelValidityTo 
and @TravelValidity_To between TravelValidityFrom and TravelValidityTo AND @SalesValidity_From between SaleValidityFrom and SaleValidityTo AND @SalesValidity_To between SaleValidityFrom and SaleValidityTo )

begin

insert into Flight_Deal 
(
MarketPoint,
AirportType,
AirlineType,
PaxType,
DealType,
DealValue,
SOTO,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
RBD,
RBDValue,
FareBasis,
FareBasisValue,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeriesValue,
InsertedDate,
GroupType,
Name,
Remark,
Flag,
IATA_DealType,
IATA_DealValue,OriginCountry,DestinationCountry
)
values
(
@MarketPoint ,
@AirportType ,
@AirLineCode ,
@PaxType ,
@DealType ,
@DealValue ,
@SOTO ,
@TravelValidity_From ,
DATEADD(s,86399,@TravelValidity_To),
@SalesValidity_From ,
DATEADD(s,86399,@SalesValidity_To),
@RBD  ,
@RBDValue ,
@FareBasis ,
@FareBasisValue ,
@Origin  ,
@OriginValue ,
@Destination ,
@DestinationValue ,
@FlightSeries ,
@FlightSeriesValue ,
getdate(),
@GroupType,
@Name,
@Remark,
1,
@IATA_DealType,
@IATA_DealValue,@OriginCountry,@DestinationCountry
)


end
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertAgentDiscount_Deal] TO [rt_read]
    AS [dbo];

