-- =============================================
-- Author:		Jishaan.
-- Create date: 23/01/2023
-- Description:	Get Id from table PNRRetrivalFromAudit
-- =============================================
Create FUNCTION [dbo].[GetPNRRetrivalId]
(
	@GDSPNR varchar(50),
	@ticketNumber varchar(50),
	@officeId varchar(50)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Id int

	-- Add the T-SQL statements to compute the return value here
	SET @Id = (select top 1 Id from PNRRetrivalFromAudit where OfficeID = @officeId and GDSPNR = @GDSPNR and TicketNumber like '%'+@ticketNumber+'%')

	-- Return the result of the function
	RETURN @Id;

END

