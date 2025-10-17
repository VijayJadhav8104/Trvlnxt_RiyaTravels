
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[FetchCancellationHistory] 
	@OrderID varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ch.Panelty,ch.Markup,ch.Remark,ch.UpdatedBy,ch.UpdateDate,am.FullName,ch.RefundAmount,ch.FlagType
	FROM CancellationHistory ch
		JOIN adminMaster am on am.Id=ch.UpdatedBy 
	WHERE OrderId=@OrderID 
	ORDER BY UpdateDate desc
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchCancellationHistory] TO [rt_read]
    AS [dbo];

