
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCountry]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	delete from CountryMaster
	where C_Id=@id

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteCountry] TO [rt_read]
    AS [dbo];

