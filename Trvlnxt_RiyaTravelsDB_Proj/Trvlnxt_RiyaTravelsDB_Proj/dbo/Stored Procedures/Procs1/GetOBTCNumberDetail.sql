
-- =============================================
-- Author:		<JD>
-- Create date: <22.08.2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetOBTCNumberDetail]
	-- Add the parameters for the stored procedure here
	@RiyaPNR NVarchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @OrderID NVarchar(150), @GDSPNR NVarchar(15)

	SELECT @OrderID = orderId FROM tblBookMaster with (nolock) WHERE riyaPNR = @RiyaPNR

	SELECT ISNULL(FileNo, '') AS FileNo
			, ISNULL(OBTCno, '') AS OBTno
			, ISNULL(InquiryNo, '') AS InquiryNo
			, ISNULL(OPSRemark, '') AS OPSRemark
			, ISNULL(AcctsRemark, '') AS AcctsRemark
			, ISNULL(OrderID, '') AS OrderIDForOBTC
	FROM mAttrributesDetails with (nolock)
	WHERE OrderID = @OrderID
END
