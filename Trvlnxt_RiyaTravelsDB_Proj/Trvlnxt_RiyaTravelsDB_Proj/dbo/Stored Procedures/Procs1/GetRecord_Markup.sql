CREATE proc [dbo].[GetRecord_Markup]

@ID int

as
begin
	SET NOCOUNT ON;

	DECLARE @OriginValue NVARCHAR(MAX),@DestinationValue NVARCHAR(MAX)
	Select @OriginValue=OriginValue,@DestinationValue=DestinationValue from Flight_MarkupType Where Id=@ID

	Select Distinct Country INTO #mtOrigin from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@OriginValue,','))	

	Select Distinct Country INTO #mtDestination from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@DestinationValue,','))

	select
	ID,
	MarketPoint,
	AirportType,
	AirlineType,
	PaxType,
	Remark,
	OnBasic,
	OnTax,
	TravelValidityFrom,
	TravelValidityTo,
	SaleValidityFrom,
	SaleValidityTo,
	InsertedDate,
	GroupType,
	Name,
	FareTypeRU,
	CalculationTypeRU,
	ValPerRU,
	FareTypeRP,
	CalculationTypeRP,
	ValPerRP,
	RUmaxAmt,
	RPmaxAmt,
	DisplayTypeRP,
	DisplayTypeRU,
	BookingTypeRP,
	BookingTypeRU,
	AgencyId,
	AgentCategory,
	AgencyNames, 
	UserType,
	RBD,
	RBDValue,
	FareBasis,
	FareBasisValue,
	Origin,
	OriginValue,
	Destination,
	DestinationValue,
	FlightSeries,
	FlightSeriesValue,
	FlightNo,
	FlightNoValue,
	Cabin,
	FareTypeM,
	CalculationTypeM,
	ValPerM,
	MmaxAmt,
	DisplayTypeM,
	BookingTypeM,
	TransactionType,
	CRSType,AvailabilityPCC
	,(CASE WHEN OriginCountry IS NULL OR OriginCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtOrigin			
            FOR XML PATH('')) ,1,1,''),'') ELSE OriginCountry END) AS OriginCountry
	,(CASE WHEN DestinationCountry IS NULL OR DestinationCountry = '' THEN ISNULL(STUFF((SELECT ',' + Country
            FROM #mtDestination			
            FOR XML PATH('')) ,1,1,''),'') ELSE DestinationCountry END) AS DestinationCountry
	--	ISNULL(OriginCountry,ISNULL(STUFF((SELECT ',' + Country
 --           FROM #mtOrigin			
 --           FOR XML PATH('')) ,1,1,''),'')) AS OriginCountry 
	--,ISNULL(DestinationCountry,ISNULL(STUFF((SELECT ',' + Country
 --       FROM #mtDestination
 --       FOR XML PATH('')) ,1,1,''),'')) AS DestinationCountry
	from Flight_MarkupType

	where ID = @ID

	DROP TABLE  #mtOrigin,#mtDestination
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_Markup] TO [rt_read]
    AS [dbo];

