-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_StarCategory]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT id,StarCategory FROM Tbl_StarCategory
	
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_StarCategory] TO [rt_read]
    AS [dbo];

