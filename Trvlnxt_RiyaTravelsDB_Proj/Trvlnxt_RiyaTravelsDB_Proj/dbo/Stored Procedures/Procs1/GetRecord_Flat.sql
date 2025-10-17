CREATE proc [dbo].[GetRecord_Flat]

@ID int

as
begin
	SET NOCOUNT ON;

	DECLARE @OriginValue NVARCHAR(MAX),@DestinationValue NVARCHAR(MAX)
	Select @OriginValue=OriginValue,@DestinationValue=DestinationValue from Flight_Flat Where Id=@ID

	Select Distinct Country INTO #mtOrigin from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@OriginValue,','))	

	Select Distinct Country INTO #mtDestination from mastCountry Where Code in (Select RTRIM(LTRIM(Item)) from dbo.SplitString(@DestinationValue,','))

	select Flight_Flat.ID,MarketPoint,AirportType,AirlineType,PaxType,Remark,InsertedDate,FKID,FlightFlat_Drec.Min,FlightFlat_Drec.Max,
	FlightFlat_Drec.Discount,TravelFrom,TravelTo,SaleFrom,SaleTo,Origin,OriginValue	,Destination,DestinationValue,Flightseries,
	FlightseriesValue,cabin,GroupType,Name,AirlineExclude,AgencyId,AgentCategory,AgencyNames, UserType
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

	from Flight_Flat  
	left join FlightFlat_Drec on FlightFlat_Drec.FKID = Flight_Flat.ID

	where Flight_Flat.ID = @ID

	DROP TABLE  #mtOrigin,#mtDestination
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_Flat] TO [rt_read]
    AS [dbo];

