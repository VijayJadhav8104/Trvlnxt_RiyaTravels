-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetCityWithCountryId
	-- Add the parameters for the stored procedure here
	@Id int=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select ID,CityName from Hotel_City_Master where CountryID=@Id

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCityWithCountryId] TO [rt_read]
    AS [dbo];

