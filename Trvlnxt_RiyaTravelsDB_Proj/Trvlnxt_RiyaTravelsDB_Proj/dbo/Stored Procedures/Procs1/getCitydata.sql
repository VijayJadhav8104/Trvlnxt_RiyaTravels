-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getCitydata] --'dubai'
@city varchar(50)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT city.ID,CityCode+','+CountryCode as CityCountryCode,CityName+','+contr.CountryName as CityCountryName ,CountryID  from Hotel_City_Master city
	inner join [dbo].[Hotel_CountryMaster] contr
	on city.CountryID=contr.CountryCode
	where CityName like ''+@city+'%'  or CityName like '%'+@city+''


END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getCitydata] TO [rt_read]
    AS [dbo];

