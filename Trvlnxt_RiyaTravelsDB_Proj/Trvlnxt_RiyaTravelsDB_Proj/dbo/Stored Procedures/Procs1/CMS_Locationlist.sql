-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_Locationlist] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	select * from tblBranch
	 Order By LTRIM(Branch)	
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_Locationlist] TO [rt_read]
    AS [dbo];

