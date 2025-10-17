
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <01/06/2018>
-- Description:	< Show Country Name>
-- =============================================
CREATE PROCEDURE [dbo].[DisplayCountry] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select * from CountryMaster

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisplayCountry] TO [rt_read]
    AS [dbo];

