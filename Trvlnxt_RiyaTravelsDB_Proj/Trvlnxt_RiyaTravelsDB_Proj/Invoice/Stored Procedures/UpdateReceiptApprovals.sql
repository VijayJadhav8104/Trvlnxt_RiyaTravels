-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdateReceiptApprovals]
	@Action VARCHAR(50),
	@Id BIGINT = 0,
	@ApprovedBy BIGINT = 0,
	@Remarks VARCHAR(MAX) = '',
	@BankCode VARCHAR(100) = '',
	@ChequeNo VARCHAR(100) = NULL
AS
BEGIN
	
	UPDATE Invoice.BankReceipts
	SET [Status] = @Action,
	ApprovedBy = @ApprovedBy,
	BankCode = @BankCode,
	ChequeNo = @ChequeNo,
	Remarks = @Remarks,
	ModifiedDate = GETDATE()
	WHERE Id = @Id

END
