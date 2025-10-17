CREATE PROCEDURE [dbo].[SP_B2CGetCountryInfo]
	@CountryId varchar(50)=null,
	@Url nvarchar(max)=null,
	@Action nvarchar(150)=null
AS
BEGIN
	SET NOCOUNT ON;
	--IF(@Action='getById')
	--SELECT co.[Adjective],
	--co.[Banner_Image],
	--co.[Continent_Id],
	--co.[CountryName],
	--co.[Description],
	--co.[GoogleAnalytics],
	--co.[Image],
	--co.[Keywords],
	--co.[MetaDescription],
	--co.[MetaTitle],
	--co.[Rate] countryRate,
	--co.[Url],
	--co.[UrlStructure],
	--ci.[CityName],
	--ci.[Currency],
	--ci.[Price],
	--ci.[CityImage],
	--ci.[Rate] CityRate,
	--ci.[IsTrendingCity],
	--ci.[ID] CityId,
	--ci.[UrlStructure] as CityUrlStructure
	-- FROM Conti_Country co
	--JOIN TblCity ci ON co.CountryName = ci.CountryName
	--Where Co.Id = @CountryId and co.IsActive = 0 and ci.IsActive=0 ORDER BY ci.IsTrendingCity desc
	--else IF(@Action='getByUrl')
	--select 
	--co.Id,
	--co.Url
	--FROM Conti_Country co 
	--Where co.Url = @Url and co.IsActive = 0 

IF(@Action='getById')
	if exists(select cc.CountryName from Conti_Country cc JOIN TblCity ci ON cc.CountryName = ci.CountryName where cc.Id=@CountryId)
			begin
				
				 SELECT co.[Adjective],
						co.[Banner_Image],
						co.[Continent_Id],
						co.[CountryName],
						co.[Description],
						co.[GoogleAnalytics],
						co.[Image],
						co.[Keywords],
						co.[MetaDescription],
						co.[MetaTitle],
						co.[Rate] countryRate,
						co.[Url],
						co.[UrlStructure],
						ci.[CityName],
						ci.[Currency],
						ci.[Price],
						ci.[CityImage],
						ci.[Rate] CityRate,
						ci.[IsTrendingCity],
						ci.[ID] CityId,
						ci.[UrlStructure] as CityUrlStructure,
						ROW_NUMBER() over(order by ci.DisplayOrder asc)as Ranks
						 FROM Conti_Country co
						JOIN TblCity ci ON co.CountryName = ci.CountryName
						Where Co.Id = @CountryId and co.IsActive = 0 and ci.IsActive=0 and  ci.DisplayOrder is not null --ORDER BY ci.IsTrendingCity desc

					UNION ALL

						SELECT co.[Adjective],
						co.[Banner_Image],
						co.[Continent_Id],
						co.[CountryName],
						co.[Description],
						co.[GoogleAnalytics],
						co.[Image],
						co.[Keywords],
						co.[MetaDescription],
						co.[MetaTitle],
						co.[Rate] countryRate,
						co.[Url],
						co.[UrlStructure],
						ci.[CityName],
						ci.[Currency],
						ci.[Price],
						ci.[CityImage],
						ci.[Rate] CityRate,
						ci.[IsTrendingCity],
						ci.[ID] CityId,
						ci.[UrlStructure] as CityUrlStructure,
						ROW_NUMBER() over(order by ci.CurrentTimeStamp asc)as Ranks
						 FROM Conti_Country co
						JOIN TblCity ci ON co.CountryName = ci.CountryName
						Where Co.Id = @CountryId and co.IsActive = 0 and ci.IsActive=0 and  ci.DisplayOrder is  null --ORDER BY ci.IsTrendingCity desc


			end
			    else
					SELECT co.[Adjective],
						co.[Banner_Image],
						co.[Continent_Id],
						co.[CountryName],
						co.[Description],
						co.[GoogleAnalytics],
						co.[Image],
						co.[Keywords],
						co.[MetaDescription],
						co.[MetaTitle],
						co.[Rate] countryRate,
						co.[Url],
						co.[UrlStructure],
						null as [CityName],
						null as [Currency],
						0 as [Price],
						null as [CityImage],
						null as [CityRate],
						0 as [IsTrendingCity],
						0 as [CityId],
						null as [CityUrlStructure]
						FROM Conti_Country co
						Where Co.Id = @CountryId and co.IsActive = 0



				
	else IF(@Action='getByUrl')
	select 
	co.Id,
	co.Url
	FROM Conti_Country co 
	Where co.Url like '%'+@Url+'%'  and co.IsActive = 0 
		
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_B2CGetCountryInfo] TO [rt_read]
    AS [dbo];

