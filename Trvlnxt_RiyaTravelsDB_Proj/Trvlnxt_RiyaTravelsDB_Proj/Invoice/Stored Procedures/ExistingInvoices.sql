-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[ExistingInvoices]
	@Invoices VARCHAR(MAX)
AS
BEGIN
	
	exec ('select * from Invoice.ZatcaPushCompareLog where InvoiceNo in ('+ @Invoices+')')

END
