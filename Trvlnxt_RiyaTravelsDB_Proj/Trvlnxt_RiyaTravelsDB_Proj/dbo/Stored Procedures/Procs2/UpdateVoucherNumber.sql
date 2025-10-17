-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateVoucherNumber 
	-- Add the parameters for the stored procedure here
	@id int=0,
	@VoucherNumber nvarchar(200)='',
	@ModifiedBy int=0
AS
BEGIN
	
	update Hotel_BookMaster
	set VoucherNumber=@VoucherNumber,VoucherDate=GETDATE()
	where pkId=@id

	----- set voucherd status on status history table
	update hotel_status_history 
	set IsActive=0 
		,ModifiedBy=@ModifiedBy
		,ModifiedDate = GETDATE()
		
	where FkHotelBookingId=@id
	insert into hotel_status_history(FKHotelBookingId,FkStatusId,CreatedBy)values(@id,4,@ModifiedBy)
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateVoucherNumber] TO [rt_read]
    AS [dbo];

