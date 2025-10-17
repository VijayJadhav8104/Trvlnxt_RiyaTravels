
-- =============================================      
-- Author:     
-- Create date: 20/12/2022      
-- Description: <Description,,>      
-- Cruise.SP_SelfBalReversal_CruiseAction 'C-2211241789' ,'','','','','','','','','GetData'      
-- =============================================      
CREATE PROCEDURE [Cruise].[SP_SelfBalReversal_CruiseAction] @Id VARCHAR(20) = NULL
	,@AgentInvoiceNumber VARCHAR(50) = NULL
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
		SELECT DISTINCT BookingReferenceid AS 'BookingId'
			,CB.CreatedOn
			,CB.AgentCharge AS 'AgentMarkup'
			,CB.TotalPrice AS 'TotalAmount'
			--,CB.orderId      
			,CASE 
				WHEN CB.PaymentMode = 1
					THEN 'Hold'
				WHEN CB.PaymentMode = 2
					THEN 'Credit Limit'
				WHEN CB.PaymentMode = 3
					THEN 'Make Payment'
				WHEN CB.PaymentMode = 4
					THEN 'Self Balance'
				END AS 'PaymentMode'
			,CB.SB_ReversalStatus
			,AL.AgentBalance
			,CB.RiyaUserId
			,al.BookingCountry
			,CB.AgentInvoiceNumber
			,CB.InquiryNo
			,CB.FileNo
			,CB.PaymentRefNo
			,CB.OBTCNo
			,CB.RTTRefNo
			,CB.OpsRemark
			,CB.AcctsRemark
		FROM Cruise.Bookings CB
		LEFT JOIN AgentLogin AL ON CB.AgentId = AL.UserID
		WHERE BookingReferenceid = @Id
			AND CB.IsActive = 1
	END

	IF (@Flag = 'Insert')
	BEGIN
		IF EXISTS (
				SELECT id
				FROM Cruise.Bookings
				WHERE SB_ReversalStatus = 0
					AND BookingReferenceid = @Id
				)
		BEGIN
			UPDATE Cruise.Bookings
			SET AgentInvoiceNumber = @AgentInvoiceNumber
				,OBTCNo = @OBTCNo
				,InquiryNo = @InquiryNo
				,FileNo = @FileNo
				,PaymentRefNo = @PaymentRefNo
				,RTTRefNo = @RTTRefNo
				,OpsRemark = @OpsRemark
				,AcctsRemark = @AcctsRemark
				,SB_ReversalStatus = 1
			WHERE BookingReferenceid = @Id
		END
	END      
END