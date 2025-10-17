-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[LastZatcaPushLog]
	
AS
BEGIN
	
	select top 1 [Hash],[Sequence] from [Invoice].[ZatcaPushLog] where IsPushed = 1 order by ModifiedDate desc

END
