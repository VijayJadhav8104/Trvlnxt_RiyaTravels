


CREATE proc [dbo].[Calculation_AgentDiscount_Deal]

@MarketPoint varchar(10),
@AirlineType varchar(10),
@TravelFrom datetime,
@TravelTo datetime
--@GroupType varchar(50),
--@Name varchar(100)= null

as
begin

------declare
------@TravelFrom datetime = '2018-04-03 00:00:00.000',
------@TravelTo datetime='2018-04-03 00:00:00.000',
------@MarketPoint varchar(5)= 'IN',
------@AirlineType varchar(5)='D'
--------@Airlinecode varchar(10)='GDS'

SELECT
ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
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
FlightSeries,
FlightSeriesValue,
Origin,
OriginValue,
Destination,
DestinationValue,
InsertedDate,
GroupType,
Name,
Flag

FROM Flight_Deal

WHERE
 --((TravelValidityFrom <= CONVERT(DATE, @Travelfrom) OR TravelValidityTo IS NULL ) AND ( TravelValidityTo >= CONVERT(DATE,@Travelto) OR TravelValidityTo IS NULL)) 

 (((@TravelFrom between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND ((@TravelTo between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
 AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
 AND MarketPoint = @Marketpoint 
 AND AirportType = @AirlineType
 --AND GroupType = @GroupType
 --AND (Name= @Name or @Name is null)


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Calculation_AgentDiscount_Deal] TO [rt_read]
    AS [dbo];

