CREATE proc [dbo].[GetRecord_FM] -- [dbo].[GetRecord_FM] 1014   
	@ID int  
 AS 
 BEGIN  
	SET NOCOUNT ON;

	DECLARE @OriginValue NVARCHAR(MAX),@DestinationValue NVARCHAR(MAX)
	Select @OriginValue=OriginValue,@DestinationValue=DestinationValue from Flight_Commission Where Id=@ID

	Select Distinct Country INTO #mtOrigin from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@OriginValue,','))	

	Select Distinct Country INTO #mtDestination from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@DestinationValue,','))

	 select ID, MarketPoint, AirportType, AirlineType, UserType, RBD, RBDValue, FareBasis, FareBasisValue, Remark, TravelValidityFrom, 
	 TravelValidityTo, SaleValidityFrom, SaleValidityTo, InsertedDate, FlightNo, FlightNoValue, Flag, cabin, Origin, OriginValue, Destination, DestinationValue, 
	 FlightSeries, FlightSeriesValue, AgencyNames, AgentCategory, AgencyId, Cabin, PricingCode, TourCode, Commission, ISNULL(IATADealType,0) AS  
	 IATADealType,  IATADealPercent,  ISNULL(PLBDealType,0) AS PLBDealType,  PLBDealPercent, CRSType, AvailabilityPCC, PNRCreationPCC, TicketingPCC,
	 IATADiscountType, PLBDiscountType, CardMapping1, CardMapping2, CardMapping3, CardMapping4, CardMapping5, 
	 Endorsementline, FareType, MarkupType, MarkupAmount, MarkupDealType, PaxType, DropnetCommission, LoginId,GST,TDS,
	 ISNULL(GDSDiscountType,0) as GDSDiscountType ,ISNULL(GDSDealType,0) AS GDSDealType,ISNULL(GDSCommission,0) as GDSCommission,NetRemitCode 
	 ,Queueno,EmailId,[TicketingAccess],OTP
	 ,(CASE WHEN OriginCountry IS NULL OR OriginCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtOrigin			
            FOR XML PATH('')) ,1,1,''),'') ELSE OriginCountry END) AS OriginCountry
	,(CASE WHEN DestinationCountry IS NULL OR DestinationCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtDestination			
            FOR XML PATH('')) ,1,1,''),'') ELSE DestinationCountry END) AS DestinationCountry
	-- ISNULL(OriginCountry,ISNULL(STUFF((SELECT ',' + Country
 --           FROM #mtOrigin			
 --           FOR XML PATH('')) ,1,1,''),'')) AS OriginCountry 
	--,ISNULL(DestinationCountry,ISNULL(STUFF((SELECT ',' + Country
 --       FROM #mtDestination
 --       FOR XML PATH('')) ,1,1,''),'')) AS DestinationCountry

	 from  Flight_Commission  
	 Where ID=@ID   

	 DROP TABLE  #mtOrigin,#mtDestination
end 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_FM] TO [rt_read]
    AS [dbo];

