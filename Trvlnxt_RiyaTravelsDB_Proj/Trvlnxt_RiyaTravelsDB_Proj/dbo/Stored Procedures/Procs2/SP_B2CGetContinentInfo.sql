CREATE PROCEDURE [dbo].[SP_B2CGetContinentInfo]
	-- Add the parameters for the stored procedure here
	@Continent_Id int=null,
	@Url nvarchar(max)=null,
	@Action nvarchar(150)=null
AS
BEGIN
	
	SET NOCOUNT ON;
IF(@Action='getById')
--begin
--   select c.ContinentName,
--   c.Description,
--   c.Adjective,
--   c.Url,
--   c.MetaTitle,
--   c.MetaDescription,
--   c.Keywords,
--   c.GoogleAnalytics,
--   co.Id CountryId,
--   co.CountryName,
--   co.Banner_Image,
--   co.[Image],
--   co.Rate countryRate,
--   co.Url as countryUrl
--	FROM Continent c 
--	JOIN Conti_Country co ON c.Id=co.Continent_Id
--	Where c.Id = @Continent_Id and c.IsActive = 0 and co.IsActive=0 
--	end

if exists(select Continent_Id from Conti_Country where Continent_Id=@Continent_Id)
		begin
			select c.ContinentName,
			   c.Description,
			   c.Adjective,
			   c.Url,
			   c.MetaTitle,
			   c.MetaDescription,
			   c.Keywords,
			   c.GoogleAnalytics,
			   c.BannerImage,
			   co.Id CountryId,
			   co.CountryName,
			   co.Banner_Image,
			   co.[Image],
			   co.Rate countryRate,
			   co.Url as countryUrl,
			   co.DisplayOrder,
			   co.Date,
			   ROW_NUMBER() over(order by co.DisplayOrder asc)as Ranks 
				FROM Continent c 
				JOIN Conti_Country co ON c.Id=co.Continent_Id
				Where c.Id = @Continent_Id and c.IsActive = 0 and co.IsActive=0 and co.DisplayOrder is not null --order by DisplayOrder asc 

				UNION ALL

			select c.ContinentName,
			   c.Description,
			   c.Adjective,
			   c.Url,
			   c.MetaTitle,
			   c.MetaDescription,
			   c.Keywords,
			   c.GoogleAnalytics,
			   c.BannerImage,
			   co.Id CountryId,
			   co.CountryName,
			   co.Banner_Image,
			   co.[Image],
			   co.Rate countryRate,
			   co.Url as countryUrl,
			   co.DisplayOrder,
			   co.Date,
			   ROW_NUMBER() over(order by co.DisplayOrder asc)as Ranks 
				FROM Continent c 
				JOIN Conti_Country co ON c.Id=co.Continent_Id
				Where c.Id = @Continent_Id and c.IsActive = 0 and co.IsActive=0 and co.DisplayOrder is null

		end
		else
		select 
			   c.ContinentName,
			   c.Description,
			   c.Adjective,
			   c.Url,
			   c.MetaTitle,
			   c.MetaDescription,
			   c.Keywords,
			   c.GoogleAnalytics,
			   c.BannerImage,
			   0 AS CountryId,
			   NULL AS CountryName,
			   NULL AS Banner_Image,
			   NULL AS [Image],
			   '0' AS  countryRate,
			   NULL AS countryUrl from Continent c 
			   where c.Id=@Continent_Id and c.IsActive=0

else IF(@Action='getByUrl')
	select 
	c.Id,
	c.Url
	FROM Continent c 
	Where c.Url = @Url and c.IsActive = 0 


END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_B2CGetContinentInfo] TO [rt_read]
    AS [dbo];

