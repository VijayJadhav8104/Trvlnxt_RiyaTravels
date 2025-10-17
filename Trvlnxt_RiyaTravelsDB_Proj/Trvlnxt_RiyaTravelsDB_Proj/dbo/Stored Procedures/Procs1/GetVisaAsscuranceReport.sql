-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetVisaAsscuranceReport] 
	-- Add the parameters for the stored procedure here
	@Name varchar(200)=''
	, @Email nvarchar(500)=''
	, @Mobile varchar(200)=''
	, @State int= ''
	, @Branch int = ''
AS
BEGIN
	select
	va.Id
	, va.Name
	, va.Email
	, va.Mobile
	--va.[State],
	--va.Branch,
	, tb.BranchLocation
	, ts.[State]
	, va.CreatedOn
	--va.Status 
	--va.[Status],
	, (CASE WHEN [Status]  = 0 THEN 'Pending' WHEN [Status] = 1 THEN 'Success' END) AS Status
	, CONCAT('''',InvoiceNo,'''') AS 'InvoiceNo'
	FROM tblVisaAssurance va WITH(NOLOCK)
	JOIN tblBranchDimension tb WITH(NOLOCK) ON va.Branch=tb.Id
	JOIN tblStateCode ts WITH(NOLOCK) ON va.State=ts.Id
	WHERE (va.Name = @Name OR @Name='')
	AND (va.Email = @Email OR @Email='')
	AND (va.Mobile = @Mobile OR @Mobile='') 
	AND (ts.Id = @State OR @State = '')
	AND (tb.Id = @Branch OR @Branch = '')
	ORDER BY CreatedOn DESC
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetVisaAsscuranceReport] TO [rt_read]
    AS [dbo];

