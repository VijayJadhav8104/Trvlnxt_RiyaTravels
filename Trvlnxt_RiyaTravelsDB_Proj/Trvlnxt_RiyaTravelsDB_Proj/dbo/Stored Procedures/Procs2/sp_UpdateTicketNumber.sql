-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2021
-- Description:	To get Pkid using pnr
-- =============================================
create PROCEDURE [dbo].[sp_UpdateTicketNumber] -- 'Quatation'
	-- Add the parameters for the stored procedure here
@pkid varchar(100),
@ticketnumber varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update tblPassengerBookDetails
	set ticketNum=@ticketnumber,TicketNumber=@ticketnumber
	where pid=@pkid
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdateTicketNumber] TO [rt_read]
    AS [dbo];

