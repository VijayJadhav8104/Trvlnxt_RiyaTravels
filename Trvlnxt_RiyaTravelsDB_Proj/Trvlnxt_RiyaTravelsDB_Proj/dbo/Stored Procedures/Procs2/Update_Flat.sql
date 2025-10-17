CREATE proc [dbo].[Update_Flat]

@ID INT,
@MarketPoint varchar(30),
@AirportType varchar(50),
@AirLineCode varchar(max),
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
@GroupType  varchar(50),
@Name varchar(50)=NULL,
@AirlineExclude varchar(max)=null,
@UserType varchar(50),
@AgencyId varchar(MAX)=null,
@AgentCategory varchar(MAX)=null,
@AgencyNames varchar(MAX)=null,
@OriginCountry VARCHAR(MAX)=NULL,
@DestinationCountry VARCHAR(MAX)=NULL,
@UserID int
as
begin

UPDATE Flight_Flat
SET
--MarketPoint = @MarketPoint,
--AirportType=@AirportType,
AirlineType=@AirLineCode,
PaxType=@PaxType,
Remark=@Remark,
TravelFrom=@TravelFrom,
TravelTo=DATEADD(s, 86399,@TravelTo),--DATEADD(ns, 8639900, DATEADD(s, 86400, @TravelTo)),
SaleFrom=@Salefrom,
SaleTo=DATEADD(s, 86399,@SaleTo),--DATEADD(ns, 8639900, DATEADD(s, 86400, @SaleTo)),@SaleTo,
InsertedDate= GETDATE(),
Origin=@Origin,
OriginValue= @Originvalue,
Destination= @Destination,
DestinationValue = @Destinationvalue,
Flightseries= @FlightSeries,
FlightseriesValue = @FlightSeriesValue,
cabin= @Cabin,
GroupType=@GroupType,
Name=@Name,
AirlineExclude=@AirlineExclude,
UserType=@UserType,
AgencyId=@AgencyId,
AgentCategory=@AgentCategory,
AgencyNames=@AgencyNames,
 UserID=@UserID,
UpdatedDate=GETDATE(),
OriginCountry=@OriginCountry,
DestinationCountry=@DestinationCountry
WHERE ID = @ID


--delete from FlightFlat_Drec where FKID = @ID



end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_Flat] TO [rt_read]
    AS [dbo];

