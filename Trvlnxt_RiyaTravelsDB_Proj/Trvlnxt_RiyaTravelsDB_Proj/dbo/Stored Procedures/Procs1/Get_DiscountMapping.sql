CREATE proc [dbo].[Get_DiscountMapping] 
 @Travelfrom datetime,
 @Travelto datetime,
 @Marketpoint varchar(5),
 @AirportType varchar(5),
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



select  ConfigurationType
,RBD
,RBDValue
,FlightSeries
,FlightSeriesValue
,FareBasis
,FareBasisValue
,Origin
,OriginValue
,Destination
,DestinationValue
,FlightNo
,FlightNoValue
,AirCodeList as AirlineType
,ISNULL(IATADiscount,0) as IATADealPercent
,ISNULL(PLBDiscount,0) as PLBDealPercent
,ISNULL(IATADealType,0) AS IATADealType,
ISNULL(PLBDealType,0) AS PLBDealType
,CRSType
,AvailabilityPCC
,ISNULL(IATADiscountType,0) as IATADiscountType
,ISNULL(PLBDiscountType,0) as PLBDiscountType
,AirportType
,FareType
,Cabin
,Paxtype
,ISNULL(DropnetCommission,0) as DropnetCommission
,LoginId
,ISNULL(GST,0) GST
,ISNULL(TDS,0) TDS
,ISNULL(SOTO,0) SOTO
, (case when AgencyId='' then '0' else AgencyId end) as AgencyId
FROM  DiscountMapping
WHERE 
@TravelFrom >=TravelValidityFrom 
AND @TravelFrom <=TravelValidityTo	
AND @Travelto >=TravelValidityFrom 
AND @Travelto <=TravelValidityTo  
AND SaleValidityFrom <=  CONVERT(DATE,GETDATE()) 
AND SaleValidityTo  >= CONVERT(DATE,GETDATE())  
AND MarketPoint = @Marketpoint 
AND ((UserType=@UserType AND ( (agencyid like   '%' +  @AgencyNames +'%' ) OR AgencyId='0') ))
AND IsActive=1 
ORDER BY CreatedDate DESC



end
