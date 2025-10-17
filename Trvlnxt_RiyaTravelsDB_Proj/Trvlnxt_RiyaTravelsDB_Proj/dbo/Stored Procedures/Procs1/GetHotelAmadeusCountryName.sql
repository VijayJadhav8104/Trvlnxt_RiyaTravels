-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetHotelAmadeusCountryName
	 @citycode varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT country_name from [Hotel_List_Master_Amadeus] where CITY=@citycode
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelAmadeusCountryName] TO [rt_read]
    AS [dbo];

