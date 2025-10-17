CREATE proc [dbo].[SP_InsertAgentDiscount_PromoCode]

@MarketPoint varchar(30),
@AirportType varchar(50),
@AirLineCode varchar(30),
@PaxType varchar(50),
@User varchar(50),
@RestrictedUser varchar(50),
@IncludeFlat varchar(10),
@MinFareAmt numeric(18,2),
@Discount numeric(18,2),
@PromoCode varchar(50),
@TravelValidity_From datetime,
@TravelValidity_To datetime,
@SalesValidity_From datetime,
@SalesValidity_To datetime,
@Remark varchar(max),
@DiscountType varchar(20),
@DiscountOn int,
@Cabin varchar(20),
@Origin bit,
@Originvalue varchar(max),
@Destination bit,
@Destinationvalue varchar(max),
@FlightSeries bit,
@FlightSeriesValue varchar(max),
@MaxAmt numeric(18,2)=0,
@AirlineExclude VARCHAR(MAX)=NULL,
@TC_Hyperlink NVARCHAR(200)=NULL,
@BookingType smallint=null,
@UserType varchar(50)=null,
@AgencyId varchar(MAX)=null,
@AgentCategory varchar(MAX)=null,
@AgencyNames varchar(MAX)=null,
@UserID int,
@AircodeList varchar(max),
@OriginCountry VARCHAR(MAX)=NULL,
@DestinationCountry VARCHAR(MAX)=NULL,
@ERROR VARCHAR(50) OUT 

as
begin

if  exists(select id from Flight_PromoCode where AgentCategory=@AgentCategory and MarketPoint=@MarketPoint and userType=@userType) and (@AgentCategory !='')
begin
	set @ERROR=  'Category already exist'
end
ELSE if  exists(select id from Flight_PromoCode where MarketPoint=@MarketPoint and userType=@userType and PromoCode
=@PromoCode
				and @AirportType =@AirportType)
begin
	set @ERROR=  'PromoCode already exist'
end
else
begin
	insert into Flight_PromoCode
(
MarketPoint,
AirportType,
AirlineType,
PaxType,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
Remark,
Flag,
discounttype,
DiscountOn,
cabin,
Origin,
OriginValue,
Destination,
DestinationValue,
FlightSeries,
FlightSeiresValue,
MaxAmt,
AirlineExclude,
TC_Hyperlink,
BookingType,
UserType,
AgencyId ,
AgentCategory,
AgencyNames,
UserID,OriginCountry,DestinationCountry
)
values(
@MarketPoint ,
@AirportType ,
@AircodeList,
@PaxType ,
@User ,
@RestrictedUser ,
@IncludeFlat ,
@MinFareAmt ,
@Discount ,
@PromoCode ,
@TravelValidity_From ,
DATEADD(s, 86399,@TravelValidity_To) ,
@SalesValidity_From ,
DATEADD(s, 86399,@SalesValidity_To) ,
GETDATE(),
@Remark,
1,
@DiscountType,
@DiscountOn,
@Cabin,
@Origin,
@Originvalue,
@Destination,
@Destinationvalue,
@FlightSeries,
@FlightSeriesValue,
@MaxAmt,
@AirlineExclude,
@TC_Hyperlink,
@BookingType,
@UserType,
@AgencyId ,
@AgentCategory,
@AgencyNames,
@UserID,@OriginCountry,@DestinationCountry
)
end
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertAgentDiscount_PromoCode] TO [rt_read]
    AS [dbo];

