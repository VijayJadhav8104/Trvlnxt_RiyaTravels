-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[GetAllContinent]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	select ContinentName, ('flight/' + url) as URL from Continent where IsActive=0

	select AirlineType from TblAirline  where IsActive=0
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllContinent] TO [rt_read]
    AS [dbo];

