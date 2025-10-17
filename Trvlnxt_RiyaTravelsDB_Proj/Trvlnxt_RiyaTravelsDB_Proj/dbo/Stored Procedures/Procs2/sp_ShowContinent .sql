-- =============================================
-- Author:		Nikhil Badgujar
-- Create date: 23-03-2019
-- Description:	Show continent
-- =============================================
CREATE procEDURE [dbo].[sp_ShowContinent ]
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Select Id,ContinentName,Convert(varchar(10),Date,103) as Date from Continent where IsActive=0
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_ShowContinent ] TO [rt_read]
    AS [dbo];

