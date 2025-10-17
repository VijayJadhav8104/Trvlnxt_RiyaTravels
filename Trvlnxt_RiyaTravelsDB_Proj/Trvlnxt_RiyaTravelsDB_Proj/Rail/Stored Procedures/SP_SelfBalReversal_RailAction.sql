
-- =============================================      
-- Author:Amol c     
-- Create date: 03/04/2023      
-- Description: <Description,,>      
-- SP_SelfBalReversal_RailAction 'C-2211241789' ,'','','','','','','','','GetData'      
-- =============================================      
CREATE PROCEDURE [Rail].[SP_SelfBalReversal_RailAction] 
	@id VARCHAR(100) = NULL
	,@AgentInvoiceNumber VARCHAR(200) = NULL
	,@OBTCNo VARCHAR(50) = NULL
	,@InquiryNo VARCHAR(50) = NULL
	,@FileNo VARCHAR(50) = NULL
	,@PaymentRefNo VARCHAR(50) = NULL
	,@RTTRefNo VARCHAR(50) = NULL
	,@OpsRemark VARCHAR(50) = NULL
	,@AcctsRemark VARCHAR(50) = NULL
	,@Flag VARCHAR(20) = NULL
AS
BEGIN
	IF (@Flag = 'GetData')
	BEGIN
		SELECT  DISTINCT 
			bk.Id,
			bk.BookingId as 'Booking ID'
			,bk.creationDate as'Booking Date'
			,bk.MarkUpOnBookingFee as 'Agent Markup'
			,bk.AmountPaidbyAgent as 'Total Amount'
			--,CB.orderId      
			--,CASE 
			--	WHEN bk.PaymentMode = 1
			--		THEN 'Hold'
			--	WHEN bk.PaymentMode = 2
			--		THEN 'Credit Limit'
			--	WHEN bk.PaymentMode = 3
			--		THEN 'Make Payment'
			--	WHEN bk.PaymentMode = 4
			--		THEN 'Self Balance'
			--	END AS 'PaymentMode'
			,bk.SB_ReversalStatus
			,AL.AgentBalance
			,bk.RiyaUserId
			,al.BookingCountry
			,bk.AgentInvoiceNumber
			,bk.InquiryNo
			,bk.FileNo
			,bk.PaymentRefNo
			,bk.OBTCNo
			,bk.RTTRefNo
			,bk.OpsRemark
			,bk.AcctsRemark
			
		FROM rail.Bookings bk
		LEFT JOIN AgentLogin AL ON bk.AgentId = AL.UserID
		WHERE BookingId = @id
			
	END

	IF (@Flag = 'Insert')
	BEGIN
		IF EXISTS (
				SELECT id
				FROM rail.Bookings
				WHERE  BookingId = @Id
				)
		BEGIN
			UPDATE rail.Bookings
			SET AgentInvoiceNumber = @AgentInvoiceNumber
				,OBTCNo = @OBTCNo
				,InquiryNo = @InquiryNo
				,FileNo = @FileNo
				,PaymentRefNo = @PaymentRefNo
				,RTTRefNo = @RTTRefNo
				,OpsRemark = @OpsRemark
				,AcctsRemark = @AcctsRemark
			WHERE BookingId = @Id
		END
	END      
	END
