-- =============================================
-- Author:		<Ketan Hiranandani>
-- Create date: <12-Aug-2020>
-- Description:	<Delete record>
-- =============================================
CREATE PROCEDURE DeletePromotions	
	@Promotion VARCHAR(200)

AS
BEGIN
	
	UPDATE B2B_Promotion SET IsActive=0 WHERE PromotionName=@Promotion

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeletePromotions] TO [rt_read]
    AS [dbo];

