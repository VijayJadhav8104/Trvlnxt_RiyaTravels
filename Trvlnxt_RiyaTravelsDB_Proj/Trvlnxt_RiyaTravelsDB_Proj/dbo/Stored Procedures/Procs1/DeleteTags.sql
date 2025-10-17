
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <01/06/2018>
-- Description:	<Dlete Tag,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteTags]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	delete from TagsMaster 
	where Id=@id

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteTags] TO [rt_read]
    AS [dbo];

