-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_SelectAirline] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id,AirlineName FROM TblAirline where IsActive=0;
	SELECT Id,CityName FROM TblCity where IsActive=0;
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_SelectAirline] TO [rt_read]
    AS [dbo];

