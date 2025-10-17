-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateCancellationCharge
	@id int=0,
	@CancellationCharge nvarchar(200)='',
	@ModifiedBy int=0
AS
BEGIN

	update Hotel_BookMaster
	set CancellationCharge=@CancellationCharge
	where pkId=@id

	----- set Cancel status on status history table
	update hotel_status_history 
	set IsActive=0 
		,ModifiedBy=@ModifiedBy
		,ModifiedDate = getdate()
	where FkHotelBookingId=@id
	insert into hotel_status_history(FKHotelBookingId,FkStatusId,CreatedBy)values(@id,7,@ModifiedBy)

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCancellationCharge] TO [rt_read]
    AS [dbo];

