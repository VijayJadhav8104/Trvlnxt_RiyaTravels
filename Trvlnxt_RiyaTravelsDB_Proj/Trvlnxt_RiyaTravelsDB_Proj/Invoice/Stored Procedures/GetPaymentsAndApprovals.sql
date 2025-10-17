-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetPaymentsAndApprovals] 
	@Module VARCHAR(MAX) = NULL,
	@AgentId bigint = 0,
	@page int = 0,
	@size int = 0
AS
BEGIN

	DECLARE @offset INT = 0
    DECLARE @newsize INT = 10
	DECLARE @totalrow INT = 0
    DECLARE @sql NVARCHAR(MAX);

    IF(@page=0)
      BEGIN
        SET @offset = @page
        SET @newsize = @size
       END
    ELSE
      BEGIN
        SET @offset = @page+1
        SET @newsize = @size-1
      END

	;WITH OrderedSet AS
    (
		SELECT 
		'' AS ReceiptNo,
		'Bank Transfer' AS PaymentMode,
		[Amount] AS Amount,
		[Status] AS [Status],
		[CreatedDate] AS CreatedDate
		FROM Invoice.BankReceipts
		WHERE Module = @Module
		AND [Status] = 'Pending'
		AND [CreatedBy] = @AgentId

		UNION ALL

		SELECT 
		IV_NO AS ReceiptNo,
		(CASE
		WHEN PAYMENT_MODE = 'BANK TRANSFER' THEN 'Bank Transfer'
		ELSE 'Payment Gateway'
		END) AS PaymentMode,
		[TRAN_AMT] AS Amount,
		'Completed' AS [Status],
		[CREATED_DATE] AS CreatedDate
		FROM Invoice.Payment
		WHERE Module = @Module
		AND CREATED_BY = @AgentId
	) 
	SELECT * from (
		SELECT *
		,ROW_NUMBER() OVER (
			ORDER BY [CreatedDate] DESC
			) AS [Index]
	FROM OrderedSet) as a where a.[Index]
	BETWEEN CONVERT(NVARCHAR(12), @offset) AND CONVERT(NVARCHAR(12), (@offset + @newsize))

	--====================================================================================================================

	SET @totalrow = (SELECT COUNT(*)
		FROM Invoice.BankReceipts
		WHERE Module = @Module
		AND [Status] = 'Pending'
		AND [CreatedBy] = @AgentId
	)
	+ 
	(
	SELECT COUNT(*)
		FROM Invoice.Payment
		WHERE Module = @Module
		AND CREATED_BY = @AgentId
	)
	select @totalrow

END
