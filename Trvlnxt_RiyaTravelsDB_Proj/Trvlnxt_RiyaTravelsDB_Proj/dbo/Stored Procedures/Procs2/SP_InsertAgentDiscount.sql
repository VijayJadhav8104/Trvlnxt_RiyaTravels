



CREATE proc [dbo].[SP_InsertAgentDiscount]

@MarketPoint varchar(30),
@ServiceType varchar(50),
@PaxType varchar(50),
@AgencyName varchar(20),
@AgencyID varchar(50),
@AirLineType varchar(50),
@AirLineCode varchar(30),
@Cabin varchar(50),
@RBD_Include varchar(50),
@RBD_Exclude varchar(50),
@FareBasis_Include varchar(50),
@FareBasis_Exclude varchar(50),
@Origin_Include varchar(50),
@Origin_Exclude varchar(50),
@Destination_Include varchar(50),
@Destination_Exclude varchar(50),
@FlightSeries varchar(50),
@FlightSeries_From varchar(50),
@FlightSeries_To varchar(50),
@SOTO varchar(50),
@TravelValidity_From datetime,
@TravelValidity_To datetime,
@SalesValidity_From datetime,
@SalesValidity_To datetime,
@Remark varchar(max)

as
begin

insert into MstDiscount 
(
MarketPoint,
SerivceType,
PaxType,
AgencyName,
AgencyID,
AirlineType,
AirlineCode,
Cabin,
RBD_Include,
RBD_Exclude,
FareBasis_Include,
FareBasis_Exclude,
FlightSeries,
FlightSeries_From,
FlightSeries_To,
Origin_Include,
Origin_exclude,
Destination_Include,
Destination_Exclude,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
SOTO,
Remark,
InsertedDate
)
values
(
@MarketPoint ,
@ServiceType ,
@PaxType ,
@AgencyName ,
@AgencyID ,
@AirLineType ,
@AirLineCode ,
@Cabin ,
@RBD_Include ,
@RBD_Exclude ,


@FareBasis_Include ,
@FareBasis_Exclude ,
@FlightSeries ,
@FlightSeries_From ,
@FlightSeries_To ,


@Origin_Include,
@Origin_Exclude ,
@Destination_Include ,
@Destination_Exclude ,


@TravelValidity_From ,
@TravelValidity_To ,
@SalesValidity_From ,
@SalesValidity_To ,
@SOTO ,
@Remark ,
GETDATE()
)

return @@identity


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertAgentDiscount] TO [rt_read]
    AS [dbo];

