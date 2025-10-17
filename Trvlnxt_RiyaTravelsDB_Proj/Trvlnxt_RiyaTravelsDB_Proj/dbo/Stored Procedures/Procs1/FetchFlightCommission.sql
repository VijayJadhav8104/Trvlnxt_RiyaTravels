CREATE proc [dbo].[FetchFlightCommission] --FetchFlightCommission '5/10/2020 12:45:00 AM','5/10/2020 12:45:00 AM','US','D','UA','B2B','6','','','','JFK','AMS','','K - Standard Economy'
 @Travelfrom datetime,
 @Travelto datetime,
 @Marketpoint varchar(5),
 @AirportType varchar(5)=null,
 @AirlineType nvarchar(100),
 @UserType VARCHAR(10)=null,
 @AgencyNames VARCHAR (MAX)=NULL,
 @RBDValue VARCHAR (10)=null,
 @FareBasisValue VARCHAR (10)=null,
 @FlightSeriesValue VARCHAR (10)=null,
 @OriginValue VARCHAR (10)=null,
 @DestinationValue VARCHAR (10)=null,
 @FlightNoValue VARCHAR (10)=null,
 @Cabin VARCHAR (50)
 AS
begin



select isnull(Commission,0) as Commission,RBD,RBDValue,FlightSeries,FlightSeriesValue,FareBasis,FareBasisValue,Origin,OriginValue,Destination,DestinationValue,
FlightNo,FlightNoValue, isnull(IATADealPercent,0) as IATADealPercent,isnull(PLBDealPercent,0) as PLBDealPercent,ISNULL(IATADealType,0) AS IATADealType,
ISNULL(PLBDealType,0) AS PLBDealType,CRSType,AvailabilityPCC, PNRCreationPCC,TicketingPCC, 
isnull(IATADiscountType,0) as IATADiscountType,  isnull(PLBDiscountType,0) as PLBDiscountType,
CardMapping1,CardMapping2,CardMapping3,CardMapping4,CardMapping5,PricingCode,TourCode,Endorsementline,
FlightNo,AirportType,AirlineType,FareType,Cabin,ISNULL(MarkupType,0) AS MarkupType,ISNULL(MarkupDealType,0) AS MarkupDealType,
ISNULL(MarkupAmount,0) AS MarkupAmount,Paxtype,ISNULL(DropnetCommission,0) as DropnetCommission,LoginId
,isnull(GST,0) GST,isnull(TDS,0) TDS

,isnull(GDSDiscountType,0) GDSDiscountType
,isnull(GDSDealType,0) GDSDealType
,isnull(GDSCommission,0) GDSCommission
,NetRemitCode,(case when AgencyId='' then '0' else AgencyId end) as AgencyId
,ISNULL(TicketingAccess,1) TicketingAccess
,EmailId,OTP
,Queueno
FROM  Flight_Commission
WHERE 
@TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and
@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND
SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND
 MarketPoint = @Marketpoint 
--AND (AirportType = @AirportType or AirportType='B')
--AND (AirlineType in (select  _CODE from AirlinesName where _NAME LIKE '%' +  @AirlineType +'%') OR AirlineType='ALL')
AND ((UserType=@UserType AND ( (agencyid LIKE '%' + @AgencyNames + ',%') OR AgencyId='0') ))
--AND ((Cabin='All') or (Cabin=@Cabin))
AND Flag=1 
ORDER BY InsertedDate DESC


end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchFlightCommission] TO [rt_read]
    AS [dbo];

