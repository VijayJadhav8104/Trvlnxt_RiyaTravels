CREATE proc [dbo].[GetRecord_ServiceFEE_GST_Quatation] -- [dbo].[GetRecord_FM] 1014

@ID int

as
begin
	SET NOCOUNT ON;

	DECLARE @OriginValue NVARCHAR(MAX),@DestinationValue NVARCHAR(MAX)
	Select @OriginValue=OriginValue,@DestinationValue=DestinationValue from tbl_ServiceFee_GST_QuatationDetails Where Id=@ID

	Select Distinct Country INTO #mtOrigin from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@OriginValue,','))	

	Select Distinct Country INTO #mtDestination from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@DestinationValue,','))

	select Id,MarketPoint,AirportType,AirlineType,UserType,GroupType,AgencyId,AgentCategory,
	AgencyNames,Remark,TravelValidityFrom,TravelValidityTo,SaleValidityFrom,SaleValidityTo,RBD,RBDValue,
	FareBasis,FareBasisValue,FlightSeries,FlightSeriesValue,Origin,OriginValue,Destination,DestinationValue,
	InsertedDate,Flag,FlightNo,FlightNoValue,Cabin,ServiceFee,GST,Quatation,UserID,UpdatedDate,BookingType,Currency,
	TransactionType,CRSType,AvailabilityPCC
	,(CASE WHEN OriginCountry IS NULL OR OriginCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtOrigin			
            FOR XML PATH('')) ,1,1,''),'') ELSE OriginCountry END) AS OriginCountry
	,(CASE WHEN DestinationCountry IS NULL OR DestinationCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtDestination			
            FOR XML PATH('')) ,1,1,''),'') ELSE DestinationCountry END) AS DestinationCountry
	--ISNULL(OriginCountry,
	--ISNULL(STUFF((SELECT ',' + Country
 --           FROM #mtOrigin			
 --           FOR XML PATH('')) ,1,1,''),'')) AS OriginCountry 
	--,ISNULL(DestinationCountry,
	--ISNULL(STUFF((SELECT ',' + Country
 --           FROM #mtDestination
 --           FOR XML PATH('')) ,1,1,''),'')) AS DestinationCountry 
	from  tbl_ServiceFee_GST_QuatationDetails Where ID=@ID

	DROP TABLE  #mtOrigin,#mtDestination

 end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_ServiceFEE_GST_Quatation] TO [rt_read]
    AS [dbo];

