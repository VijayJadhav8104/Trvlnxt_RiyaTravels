-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2021
-- Description:	To get Pkid using pnr
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateTicketNumber1] -- 'Quatation'
	-- Add the parameters for the stored procedure here
@pkid varchar(100),
@ticketnum varchar(100),
@ticketnumber varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update tblPassengerBookDetails
	set ticketNum=@ticketnum,TicketNumber=@ticketnumber
	where pid=@pkid
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdateTicketNumber1] TO [rt_read]
    AS [dbo];

