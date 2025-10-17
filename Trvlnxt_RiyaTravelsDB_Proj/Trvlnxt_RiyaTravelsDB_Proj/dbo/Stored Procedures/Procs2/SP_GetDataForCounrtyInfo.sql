-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[SP_GetDataForCounrtyInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Select * from Conti_Country
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetDataForCounrtyInfo] TO [rt_read]
    AS [dbo];

