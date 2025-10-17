CREATE proc [dbo].[GetRecord_Promocode]

@ID int

as
begin
	SET NOCOUNT ON;

	DECLARE @OriginValue NVARCHAR(MAX),@DestinationValue NVARCHAR(MAX)
	Select @OriginValue=OriginValue,@DestinationValue=DestinationValue from Flight_PromoCode Where Id=@ID

	Select Distinct Country INTO #mtOrigin from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@OriginValue,','))	

	Select Distinct Country INTO #mtDestination from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@DestinationValue,','))


	select ID,MarketPoint,AirportType,AirlineType,PaxType,Remark,[User],RestrictedUser,IncludeFlat,MinFareAmt,Discount,PromoCode,TravelValidityFrom,
	TravelValidityTo,SaleValidityFrom,SaleValidityTo,InsertedDate,Flag,discounttype,DiscountOn,cabin,Origin,OriginValue,Destination,
	DestinationValue,FlightSeries,FlightSeiresValue,MaxAmt,AirlineExclude,TC_Hyperlink,BookingType,AgencyId,AgentCategory,
	AgencyNames,UserType
	,(CASE WHEN OriginCountry IS NULL OR OriginCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtOrigin			
            FOR XML PATH('')) ,1,1,''),'') ELSE OriginCountry END) AS OriginCountry
	,(CASE WHEN DestinationCountry IS NULL OR DestinationCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtDestination			
            FOR XML PATH('')) ,1,1,''),'') ELSE DestinationCountry END) AS DestinationCountry
	--ISNULL(OriginCountry,ISNULL(STUFF((SELECT ',' + Country
 --           FROM #mtOrigin			
 --           FOR XML PATH('')) ,1,1,''),'')) AS OriginCountry 
	--,ISNULL(DestinationCountry,ISNULL(STUFF((SELECT ',' + Country
 --       FROM #mtDestination
 --       FOR XML PATH('')) ,1,1,''),'')) AS DestinationCountry

	from  Flight_PromoCode

	Where ID=@ID

	DROP TABLE  #mtOrigin,#mtDestination

 end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_Promocode] TO [rt_read]
    AS [dbo];

