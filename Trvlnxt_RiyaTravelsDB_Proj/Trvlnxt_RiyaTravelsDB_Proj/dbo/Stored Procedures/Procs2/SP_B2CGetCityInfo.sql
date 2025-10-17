
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_B2CGetCityInfo]
	-- Add the parameters for the stored procedure here
	@CityId int=null,
	@Url nvarchar(max)=null,
	@Action nvarchar(150)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@Action='getById')
	BEGIN
	select 
	c.ID CityId,
	c.CityName,
	c.Description,
	c.BannerImage,
	c.CityImage,
	c.Price,
	c.Rate,	
	c.Currency,
	c.Temperature,
	c.Precipitaion,
	c.GoogleAnalytics,
	c.Keywords,
	c.MetaTitle,
	c.MetaDescription,
	c.CityAdjective,
	ca.AirportName,
	ca.Description AirPortDescription,
	ca.Route_Image as AirPortImg,

	(CASE 
	WHEN CHARINDEX (':', Timezone) > 0 and  CHARINDEX ('+', Timezone) > 0  THEN FORMAT (GETUTCDATE()+ REPLACE(Timezone,'UTC +',''), 'dddd, hh:mm tt')
	WHEN CHARINDEX (':', Timezone) > 0 and  CHARINDEX ('-', Timezone) > 0  THEN FORMAT (GETUTCDATE()- REPLACE(Timezone,'UTC -',''), 'dddd, hh:mm tt')
	WHEN CHARINDEX (':', Timezone) = 0 and  CHARINDEX ('+', Timezone) > 0  THEN FORMAT (GETUTCDATE()+ (REPLACE(Timezone,'UTC +','') + ':00'), 'dddd, hh:mm tt')  
	WHEN CHARINDEX (':', Timezone) = 0 and  CHARINDEX ('-', Timezone) > 0  THEN FORMAT (GETUTCDATE()- (REPLACE(Timezone,'UTC -','') + ':00') , 'dddd, hh:mm tt') 
	END) as Timezone

	--GETUTCDATE()+ CASE WHEN CHARINDEX (':', Timezone) > 0 THEN REPLACE(Timezone,'UTC +','') ELSE REPLACE(Timezone,'UTC +','') + ':00' END as Timezone
	--CONCAT( DATENAME(dw,DATEADD(MINUTE,(select ABS(UTCPlusMinus) from Tbl_Timezone where Id=16),GETUTCDATE() )),', ',
	--CONVERT(varchar,CAST(DATEADD(MINUTE,(select ABS(UTCPlusMinus) from Tbl_Timezone where Id=16),GETUTCDATE() ) as Time),100)	) Timezone 
	FROM TblCity c 
	JOIN City_Airports ca ON ca.City_Id=c.ID
	join City_Popular_Route CR on CR.City_Id=c.ID
	join City_Hotels CH on CH.City_Id=c.ID
	Where c.Id = @CityId and c.IsActive = 0;

	SELECT
			A.[AirlineImage],
			A.[AirlineName],
			A.[Urlstructure] as AirlineUrlStructure,
			A.[Id] AirlineId
			FROM TblAirline A 
			JOIN PopularDestination PD ON PD.Airline_Id= A.Id			
			WHERE PD.PopularDestinations_Id=@CityId and A.IsActive= 0;
	SELECT 
	CA.[AirportName],
	CA.[Description],
	CA.[Route_Image]
	 FROM City_Airports CA 
	 WHERE CA.City_Id = @CityId;

	select 
	CR.[Route_Image],
	CR.[Route_Price],
	CR.[Source_City],
	CR.[Time_Required],
	CR.[Fastest_Flight_Time]	
	from City_Popular_Route CR where CR.City_Id=@CityId;

	select 
	CH.[Hotel_Name],
	CH.[Address],
	CH.[Strike_Price],
	CH.[Price],
	CH.[Star_Category],
	CH.[Inclusive],
	CH.[HotelUrl],
	CH.[HotelMTitle],
	CH.[HotelMDescription],
	CH.[HotelGoogleAnalytics],
	CH.[Keywords],
	CH.[CurrentTimeStamp],
	CH.[City_Id],
	CH.[HotelImage],
--	ca.Route_Image,
	CH.[HotelCity]	
	from City_Hotels CH 
--	JOIN City_Airports ca ON CH.City_Id=ca.City_Id
	where CH.City_Id=@CityId

	END
	IF(@Action='getByUrl')
	SELECT 
	c.Id,
	c.UrlStructure
	FROM TblCity c 
	Where c.UrlStructure like'%'+@Url+'%'  and c.IsActive = 0 
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_B2CGetCityInfo] TO [rt_read]
    AS [dbo];

