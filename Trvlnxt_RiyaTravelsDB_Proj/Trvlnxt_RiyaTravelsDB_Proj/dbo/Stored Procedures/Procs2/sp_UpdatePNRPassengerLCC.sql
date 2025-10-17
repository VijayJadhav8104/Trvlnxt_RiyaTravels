
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdatePNRPassengerLCC]
	@PNR varchar(200),
	@IsHold bit=0,
	@PaxId	int
AS
BEGIN
	

	declare @BookingId int

	Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId

	if(@IsHold =1)
	BEGIN
	    UPDATE tblBookMaster SET BookingStatus = '2',IsBooked = 0 WHERE pkId = @BookingId --and VendorName='Fly Dubai'
	END
	ELSE
	BEGIN
	UPDATE tblPassengerBookDetails SET ticketNum = @PNR,ticketnumber= @PNR
	WHERE pid = @PaxId
		--Update tblBookMaster set IsBooked = 1 where pkId = @BookingId

		Update tblBookMaster set IsBooked = 1,BookingStatus=1 where pkId = @BookingId

		if exists(select top 1 airlinePNR from tblBookItenary where fkBookMaster=@BookingId and airlinePNR is null)
		begin 
		update tblBookItenary
		set airlinePNR=SUBSTRING(@PNR,1,6)
		where fkBookMaster=@BookingId and airlinePNR is null
		end

	END
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePNRPassengerLCC] TO [rt_read]
    AS [dbo];

