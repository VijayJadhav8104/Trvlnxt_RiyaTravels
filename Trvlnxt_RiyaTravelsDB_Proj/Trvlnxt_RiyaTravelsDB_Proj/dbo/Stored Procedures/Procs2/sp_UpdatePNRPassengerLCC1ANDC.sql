CREATE PROCEDURE [dbo].[sp_UpdatePNRPassengerLCC1ANDC]
	@PNR varchar(200),
	@PaxId	int
AS
BEGIN
	declare @newticketno varchar(50)  
	declare @ticketNum varchar(50)  
	declare @spltticketno varchar(50)  
	set @newticketno=SUBSTRING(@PNR,4,13)                     
	set @spltticketno=SUBSTRING(@PNR,1,3)     
	
    set @ticketNum= @spltticketno +'-'+  @newticketno 

	UPDATE tblPassengerBookDetails SET ticketNum = @ticketNum,ticketnumber= @newticketno
	WHERE pid = @PaxId

	declare @BookingId int

	Select @BookingId = [fkBookMaster] from tblPassengerBookDetails where pid = @PaxId

	Update tblBookMaster set IsBooked = 1 where pkId = @BookingId
END