-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AllAirlineWithSector]
	-- Add the parameters for the stored procedure here
	@sector nvarchar(200)= null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select Id,
		   AirlineName,
		   AirlineImage,
		   [Description],
		   Urlstructure,
		   AirlineType

      from TblAirline 
	  -- AirlineType= CONCAT('%' ,@sector , '%')  and IsActive=0
	  where AirlineType like '%' + @sector + '%' and IsActive=0
	  order by AirlineName
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AllAirlineWithSector] TO [rt_read]
    AS [dbo];

