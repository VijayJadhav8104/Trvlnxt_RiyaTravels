CREATE proc [dbo].[FetchFlightCommission_NEW_B2C] --FetchFlightCommission '5/10/2020 12:45:00 AM','5/10/2020 12:45:00 AM','US','D','UA','B2B','6','','','','JFK','AMS','','K - Standard Economy'
 @Travelfrom datetime,
 @Travelto datetime,
 @Marketpoint varchar(5),
 @AirportType varchar(5),
 @AirlineType nvarchar(100),
 @UserType VARCHAR(10)
 AS
begin


select isnull(Commission,0) as Commission,RBD,RBDValue,FlightSeries,FlightSeriesValue,FareBasis,FareBasisValue,Origin,OriginValue,Destination,DestinationValue,
FlightNo,FlightNoValue, isnull(IATADealPercent,0) as IATADealPercent,isnull(PLBDealPercent,0) as PLBDealPercent,ISNULL(IATADealType,0) AS IATADealType,
ISNULL(PLBDealType,0) AS PLBDealType,CRSType,AvailabilityPCC, PNRCreationPCC,TicketingPCC, 
isnull(IATADiscountType,0) as IATADiscountType,  isnull(PLBDiscountType,0) as PLBDiscountType,
CardMapping1,CardMapping2,CardMapping3,CardMapping4,CardMapping5,PricingCode,TourCode,Endorsementline,
FlightNo,AirportType,AirlineType,FareType,Cabin,ISNULL(MarkupType,0) AS MarkupType,ISNULL(MarkupDealType,0) AS MarkupDealType,
ISNULL(MarkupAmount,0) AS MarkupAmount,Paxtype,ISNULL(DropnetCommission,0) as DropnetCommission,LoginId,MarketPoint,UserType
FROM  Flight_Commission
WHERE 
@TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and
@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND
SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND
 MarketPoint = @Marketpoint 
 AND UserType=@UserType
 AND AirlineType = @AirlineType
AND Flag=1 
ORDER BY InsertedDate DESC



end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchFlightCommission_NEW_B2C] TO [rt_read]
    AS [dbo];

