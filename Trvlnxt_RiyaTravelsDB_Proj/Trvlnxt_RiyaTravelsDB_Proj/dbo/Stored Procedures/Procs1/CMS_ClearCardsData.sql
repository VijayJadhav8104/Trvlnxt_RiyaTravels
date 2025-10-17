
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_ClearCardsData]
AS
BEGIN

	
	delete from  CMS_CardRates
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_ClearCardsData] TO [rt_read]
    AS [dbo];

