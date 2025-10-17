-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetReceiptApprovalsCurrency] 
	@Module VARCHAR(MAX) = NULL,
	@page int = 0,
	@size int = 0,
	@AgentCountries varchar(100) = null
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
		r.[Id] AS Id,
		[BankRefId] AS BankRefId,
		'Bank Transfer' AS PaymentMode,
		u.FullName as ApprovedBy,
		b2b.AgencyName AS UploadedBy,
		[Amount] AS Amount,
		r.[Status] AS [Status],
		[CreatedDate] AS CreatedDate,
		b2b.Icast AS Icust,
		r.Currency AS Currency,
		r.OrderId AS OrderId,
		r.CreatedBy AS AgentId
		FROM Invoice.BankReceipts r
		LEFT JOIN mUser u on r.ApprovedBy = u.ID
		LEFT JOIN B2BRegistration b2b on r.CreatedBy = b2b.FKUserID
		WHERE Module = @Module
		AND r.Currency IN (SELECT Value FROM dbo.SplitString1(@AgentCountries, ','))
		--AND [Status] = 'Pending'
		--AND [CreatedBy] = @AgentId
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
		AND Currency IN (SELECT Value FROM dbo.SplitString1(@AgentCountries, ','))
		--AND [Status] = 'Pending'
	)
	select @totalrow

END
