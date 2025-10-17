--=================================================
--Created By : Shivkumar Prajapati
--Creation Date : 01/10/2019
--Description :
-- [dbo].[HotelSearch] '',''
--=================================================
CREATE PROCEDURE [dbo].[HotelSearch]
@CountryCode nvarchar(50)=null,
@PreferredFlag Char(1)
AS
BEGIN

	IF(@CountryCode='' and @PreferredFlag='')
	BEGIN
		SELECT isnull(Id,'') as 'Id',isnull(NAME,'') as 'NAME',isnull(city_code,'') as 'city_code',isnull(city_name,'') as 'city_name',
		cast(isnull(country_code,'') as nvarchar(50)) as 'country_code'		,cast(isnull(latitude,'') as nvarchar(50)) as 'latitude',
		cast(isnull(longitude,'') as nvarchar(50)) as 'longitude',cast(isnull(rating,'') as nvarchar(50)) as 'rating',isnull(long_desc,'') as 'long_desc'
		,cast(isnull([address],'') as nvarchar(max)) as 'address',isnull(main_image,'') as 'main_image',isnull(PreferdFlag,'') as 'PreferdFlag' FROM static_data_hotels
	END
	ELSE IF(@CountryCode!='' AND @PreferredFlag!='')
	BEGIN
		SELECT isnull(Id,'') as 'Id',isnull(NAME,'') as 'NAME',isnull(city_code,'') as 'city_code',isnull(city_name,'') as 'city_name',
		cast(isnull(country_code,'') as nvarchar(50)) as 'country_code'		,cast(isnull(latitude,'') as nvarchar(50)) as 'latitude',
		cast(isnull(longitude,'') as nvarchar(50)) as 'longitude',cast(isnull(rating,'') as nvarchar(50)) as 'rating',isnull(long_desc,'') as 'long_desc'
		,cast(isnull([address],'') as nvarchar(max)) as 'address',isnull(main_image,'') as 'main_image',isnull(PreferdFlag,'') as 'PreferdFlag' FROM static_data_hotels
		WHERE country_code=@CountryCode AND PreferdFlag=@PreferredFlag
	END
	ELSE IF(@CountryCode!='')
	BEGIN
		SELECT isnull(Id,'') as 'Id',isnull(NAME,'') as 'NAME',isnull(city_code,'') as 'city_code',isnull(city_name,'') as 'city_name',
		cast(isnull(country_code,'') as nvarchar(50)) as 'country_code'		,cast(isnull(latitude,'') as nvarchar(50)) as 'latitude',
		cast(isnull(longitude,'') as nvarchar(50)) as 'longitude',cast(isnull(rating,'') as nvarchar(50)) as 'rating',isnull(long_desc,'') as 'long_desc'
		,cast(isnull([address],'') as nvarchar(max)) as 'address',isnull(main_image,'') as 'main_image',isnull(PreferdFlag,'') as 'PreferdFlag' FROM static_data_hotels
		 WHERE country_code=@CountryCode 
	END
	ELSE
	BEGIN
		SELECT isnull(Id,'') as 'Id',isnull(NAME,'') as 'NAME',isnull(city_code,'') as 'city_code',isnull(city_name,'') as 'city_name',
		cast(isnull(country_code,'') as nvarchar(50)) as 'country_code'		,cast(isnull(latitude,'') as nvarchar(50)) as 'latitude',
		cast(isnull(longitude,'') as nvarchar(50)) as 'longitude',cast(isnull(rating,'') as nvarchar(50)) as 'rating',isnull(long_desc,'') as 'long_desc'
		,cast(isnull([address],'') as nvarchar(max)) as 'address',isnull(main_image,'') as 'main_image',isnull(PreferdFlag,'') as 'PreferdFlag' FROM static_data_hotels
		WHERE PreferdFlag=@PreferredFlag
	END


END

--select * from static_data_hotels

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelSearch] TO [rt_read]
    AS [dbo];

