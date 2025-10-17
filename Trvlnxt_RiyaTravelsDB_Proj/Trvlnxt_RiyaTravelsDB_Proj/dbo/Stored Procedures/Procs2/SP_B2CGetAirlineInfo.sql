CREATE PROCEDURE [dbo].[SP_B2CGetAirlineInfo] 
	@AirlineId int=null,
	@Action varchar(100) = null,
	@Url varchar(100)=null,
	@PageSize int = null,
	@PageIndex int = 0
	
AS
BEGIN
	SET NOCOUNT ON;
	IF(@Action='getById')
	BEGIN
			SELECT 
			A.[AirlineImage],
			A.[AirlineName],
			A.[BannerImage],
			A.[CheckInLuggage],
			A.[ContinentAdjective],
			A.[DelayedFlights],
			A.[Description],
			A.[FlightsCancelled],
			A.[GoogleAnalytics],
			A.[HandLuggage],
			A.[Keywords],
			A.[MetaDescription],
			A.[MetaTitle],
			A.[Punctuality],
			A.[Urlstructure]
			 FROM TblAirline A WHERE a.[Id]=@AirlineId AND A.[IsActive] = 0;

			 -- Altamash chnage.
		--with cte
		--as(
		--	SELECT 
		--	ci.[CityName],
		--	ci.[UrlStructure] as CityUrlStructure,
		--	ci.[Currency],
		--	ci.[Price],
		--	ci.[CityImage],
		--	ci.[Rate] CityRate,
		--	ci.[IsTrendingCity],
		--	ci.[ID] CityId 
		--	FROM TblCity ci
		--	JOIN PopularDestination p ON P.PopularDestinations_Id = CI.ID
		--	WHERE P.Airline_Id= @AirlineId and IsActive !=1 --order by ci.[IsTrendingCity] desc
		--)

		--SELECT * INTO #Result1 FROM cte 
		--ORDER BY cte.CityName

		--SELECT * FROM 
		--	(SELECT * , ROW_NUMBER() OVER (ORDER BY CityName DESC) AS RowRank 
		--	 FROM  #Result1)R
		--	 WHERE RowRank > (@PageIndex * @PageSize) AND RowRank <= ((@PageIndex * @PageSize) + @PageSize)

		

			SELECT 
			ci.[CityName],
			ci.[UrlStructure] as CityUrlStructure,
			ci.[Currency],
			ci.[Price],
			ci.[CityImage],
			ci.[Rate] CityRate,
			ci.[IsTrendingCity],
			ci.[ID] CityId 
			FROM TblCity ci
			JOIN PopularDestination p ON P.PopularDestinations_Id = CI.ID
			WHERE P.Airline_Id= @AirlineId and IsActive !=1 order by ci.[IsTrendingCity] desc;

			SELECT 
			A.[AirlineImage],
			A.[AirlineName],
			A.[Urlstructure] as AirUrlstructure,
			A.[Id] AirlineId
			FROM TblAirline A 
			JOIN SimilarAirline SA ON SA.SimilarAirline_Id = A.Id
			WHERE SA.Airline_Id=@AirlineId;
			END
	ELSE IF (@Action='getByUrl')
	SELECT 
	A.Id,
	A.UrlStructure
	FROM TblAirline A
	Where A.UrlStructure = @Url and A.IsActive = 0 
    
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_B2CGetAirlineInfo] TO [rt_read]
    AS [dbo];

