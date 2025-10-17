-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_UpdatePNRPassengerLCCTF]
	@PNR varchar(200),
	@PaxId	int
AS
BEGIN
	UPDATE tblPassengerBookDetails SET ticketNum = @PNR,ticketnumber= @PNR
	WHERE pid = @PaxId

	declare @BookingId int

	Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId

	Update tblBookMaster set IsBooked = 1 where pkId = @BookingId
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePNRPassengerLCCTF] TO [rt_read]
    AS [dbo];

