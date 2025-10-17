---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE proc [dbo].[Sp_GetDealMapping] --FetchFlightCommission '28/02/2022 00:00:00 AM','28/02/2022 00:00:00 AM','US','I','ALL','B2B','40028','','','','NYC','BOM','','Y'
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



select isnull(Commission,0) as Commission
,ConfigurationType
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
,ISNULL(IATADealPercent,0) as IATADealPercent
,ISNULL(PLBDealPercent,0) as PLBDealPercent
,ISNULL(IATADealType,0) AS IATADealType,
ISNULL(PLBDealType,0) AS PLBDealType
,ISNULL(GST,0) AS GSTOnPLB
,ISNULL(TDS,0) AS TDSOnPLB
,CRSType
--,CASE CRSType when '11' then '4' else CRSType end CRSType
,AvailabilityPCC
,PNRCreationPCC
,TicketingPCC
,ISNULL(IATADiscountType,0) as IATADiscountType
,ISNULL(PLBDiscountType,0) as PLBDiscountType
,CardMapping1
,CardMapping2
,CardMapping3
,CardMapping4
,CardMapping5
,PricingCode
,TourCode
,Endorsementline
,FlightNo
,AirportType
,AirlineType
,FareType
,Cabin
,ISNULL(MarkupType,0) AS MarkupType
,ISNULL(MarkupDealType,0) AS MarkupDealType
,ISNULL(MarkupAmount,0) AS MarkupAmount,Paxtype
,ISNULL(DropnetCommission,0) as DropnetCommission
,LoginId
,ISNULL(GST,0) GST
,ISNULL(TDS,0) TDS
,ISNULL(GDSDiscountType,0) GDSDiscountType
,ISNULL(GDSDealType,0) GDSDealType
,ISNULL(GDSCommission,0) GDSCommission
,NetRemitCode
,ISNULL(TicketingAccess,1) TicketingAccess
,EmailId,OTP
,Queueno
,ISNULL(SOTO,0
) SOTO
, (case when AgencyId='' then '0' else AgencyId end) as AgencyId
,rtrim(ltrim(tcm.CategoryValue)) VendorName,
AgentLogin,Password,IATA,agentidentifier,Id,ViaPointValue
FROM  FlightCommission fc left join tbl_commonmaster tcm on fc.CRSType=tcm.pkid
WHERE 
@TravelFrom >=TravelValidityFrom 
AND @TravelFrom <=TravelValidityTo	
AND @Travelto >=TravelValidityFrom 
AND @Travelto <=TravelValidityTo  
AND SaleValidityFrom <=  CONVERT(DATE,GETDATE()) 
AND SaleValidityTo  >= CONVERT(DATE,GETDATE())  
AND MarketPoint = @Marketpoint 
--AND (AirportType = @AirportType or AirportType='B')
--AND (AirlineType in (select  _CODE from AirlinesName where _NAME LIKE '%' +  @AirlineType +'%') OR AirlineType='ALL')
--AND ((UserType=@UserType AND ( (agencyid IN ((SELECT Data FROM sample_split((@AgencyNames), ',')))) OR AgencyId='0') ))
AND ((UserType=@UserType AND ( (agencyid like   '%' +  @AgencyNames +'%' ) OR AgencyId='0') ))
--AND ((Cabin='All') or (Cabin=@Cabin))
AND Flag=1 
ORDER BY InsertedDate DESC



end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetDealMapping] TO [rt_read]
    AS [dbo];

