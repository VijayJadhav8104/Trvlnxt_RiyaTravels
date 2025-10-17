




create proc [dbo].[GetRecords_AgentFlightFlat]
@Travelfrom datetime,
@Travelto datetime,
@Marketpoint varchar(5),
@AirportType varchar(5)
--@Airlinecode varchar(10)


AS
BEGIN

--declare
--@Travelfrom datetime = '2018-03-31 00:00:00.000',
--@Travelto datetime='2018-03-31 00:00:00.000',
--@Marketpoint varchar(5)= 'IN',
--@AirportType varchar(5)='D'
----@Airlinecode varchar(10)='GDS'

SELECT
B.ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
A.Min,
A.Max,
A.Discount
FROM
Flight_Flat B

LEFT JOIN FlightFlat_Drec A ON A.FKID = B.ID
WHERE
 ((TravelFrom <= CONVERT(DATE, @Travelfrom) OR TravelTo IS NULL ) AND ( TravelTo >= CONVERT(DATE,@Travelto) OR TravelTo IS NULL)) 
 AND ((SaleFrom <=  CONVERT(DATE,GETDATE()) OR SaleFrom IS NULL) AND (SaleTo  >= CONVERT(DATE,GETDATE()) OR SaleTo IS NULL)) 
 AND B.MarketPoint = @Marketpoint 
 AND B.AirportType = @AirportType
 --AND B.AirlineType = @Airlinecode


END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecords_AgentFlightFlat] TO [rt_read]
    AS [dbo];

