-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[SP_GetAllCity]
	-- Add the parameters for the stored procedure here
  @countryId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
select country.Id,city.CityName, CityImage,city.Price from TblCity city inner join Conti_Country country on city.CountryName=country.CountryName 
 where IsTrendingCity=1 and country.Id=@countryId
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetAllCity] TO [rt_read]
    AS [dbo];

