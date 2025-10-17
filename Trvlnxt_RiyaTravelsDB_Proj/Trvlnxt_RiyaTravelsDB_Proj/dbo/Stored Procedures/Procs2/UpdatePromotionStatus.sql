-- =============================================
-- Author:		<Ketan Hiranandani>
-- Create date: <13-Aug-2020>
-- Modified on: <23-Oct-2020>
-- Description:	<Update record>
-- =============================================
CREATE PROCEDURE UpdatePromotionStatus
	@Promotion VARCHAR(200),
	@IsActive BIT

AS
BEGIN
	
	UPDATE B2B_Promotion SET ActionStatus=@IsActive WHERE PromotionName=@Promotion

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePromotionStatus] TO [rt_read]
    AS [dbo];

