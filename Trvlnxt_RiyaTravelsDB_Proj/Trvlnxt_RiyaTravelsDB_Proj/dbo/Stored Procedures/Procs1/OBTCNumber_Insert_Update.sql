
-- =============================================
-- Author:		<JD>
-- Create date: <22.08.2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OBTCNumber_Insert_Update]
	-- Add the parameters for the stored procedure here
	@FileNo NVarchar(50) = NULL
	, @OBTNo NVarchar(50)
	, @InquiryNo NVarchar(50)=NULL
	, @OPSRemark NVarchar(50)=NULL
	, @AcctsRemark NVarchar(50)=NULL
	, @BookingID NVarchar(50)=NULL

	, @OUTVAL Int OUTPUT
	, @OUTMSG NVarchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CreatedBy NVarchar(15), @GDSPNR NVarchar(15), @OrderIDForOBTC Nvarchar(50)

	SELECT TOP 1 @CreatedBy = AgentID
				, @GDSPNR = GDSPNR
				, @OrderIDForOBTC = orderId
	FROM tblBookMaster with (nolock)
	WHERE riyaPNR = @BookingID
	ORDER BY pkId ASC

    IF EXISTS(SELECT TOP 1 * FROM mAttrributesDetails with (nolock) WHERE mAttrributesDetails.OrderID = @OrderIDForOBTC)
	BEGIN
		UPDATE mAttrributesDetails 
			SET FileNo = @FileNo
				, OBTCno = @OBTNo
				, InquiryNo = @InquiryNo
				, OPSRemark = @OPSRemark
				, AcctsRemark = @AcctsRemark
		WHERE OrderID = @OrderIDForOBTC

		SET @OUTVAL = 1
		SET @OUTMSG = 'Record Update Successfully.'
	END
	ELSE
	BEGIN

		INSERT INTO mAttrributesDetails(OrderID, GDSPNR, FileNo, OBTCno, InquiryNo, OPSRemark, AcctsRemark, CreatedOn, CreatedBy)
								VALUES (@OrderIDForOBTC, @GDSPNR, @FileNo, @OBTno, @InquiryNo, @OPSRemark, @AcctsRemark, GETDATE(), @CreatedBy)

		SET @OUTVAL = 1
		SET @OUTMSG = 'Record Save Successfully.'
	END
END
