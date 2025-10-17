CREATE proc [dbo].[SP_InsertAgentDiscount_Flat]

@MarketPoint varchar(30),
@AirportType varchar(50),
@AirLineCode varchar(30),
@PaxType varchar(50),
@Remark varchar(max),
@TravelFrom datetime,
@TravelTo datetime,
@Salefrom datetime,
@SaleTo datetime,
@Origin bit,
@Originvalue varchar(max),
@Destination bit,
@Destinationvalue varchar(max),
@FlightSeries bit,
@FlightSeriesValue varchar(max),
@Cabin varchar(20),
@GroupType varchar(50),
@Name varchar(100)=NULL,
@AirlineExclude varchar(max),
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


if  exists(select id from Flight_Flat where AgentCategory=@AgentCategory
 and MarketPoint=@MarketPoint and userType=@userType) and (@AgentCategory !='')
begin
	set @ERROR=  'Category already exist'
end
--ELSE if exists(select id from Flight_Flat where  MarketPoint=@MarketPoint and userType=@userType 
--	      and @TravelFrom between TravelFrom and travelto and @TravelTo between TravelFrom and travelto
--		  AND @Salefrom between SaleFrom and SaleTo AND @SaleTo between SaleFrom and SaleTo
--		  and airlinetype in( select DATA from sample_split(@AircodeList,',')) )
--BEGIN
--	set @ERROR=  'Record already exist'
--END 
else
begin
	insert into Flight_Flat
(
MarketPoint,
AirportType,
AirlineType,
PaxType,
InsertedDate,
Remark,
Flag,
TravelFrom,
TravelTo,
SaleFrom,
SaleTo,
Origin,
OriginValue	,
Destination,
DestinationValue,
Flightseries,
FlightseriesValue,
cabin,
GroupType,
Name,
AirlineExclude,
UserType,
AgencyId ,
AgentCategory,
AgencyNames,
UserID,OriginCountry,DestinationCountry
)
Values
(
@MarketPoint ,
@AirportType ,
@AircodeList ,
@PaxType ,
GETDATE(),
@Remark,
1,
@TravelFrom,
DATEADD(s, 86399,@TravelTo),
@Salefrom,
DATEADD(s, 86399,@SaleTo),
@Origin,
@Originvalue,
@Destination,
@Destinationvalue,
@FlightSeries,
@FlightSeriesValue,
@Cabin,
@GroupType,
@Name,
@AirlineExclude,
@UserType,
@AgencyId ,
@AgentCategory,
@AgencyNames,
@UserID,@OriginCountry,@DestinationCountry
)
	set @ERROR=  cast(@@identity as varchar(50))
end

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertAgentDiscount_Flat] TO [rt_read]
    AS [dbo];

