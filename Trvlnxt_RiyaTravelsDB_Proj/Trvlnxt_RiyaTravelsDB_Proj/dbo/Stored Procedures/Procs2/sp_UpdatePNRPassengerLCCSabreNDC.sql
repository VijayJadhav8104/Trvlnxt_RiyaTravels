-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


create PROCEDURE [dbo].[sp_UpdatePNRPassengerLCCSabreNDC]
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

