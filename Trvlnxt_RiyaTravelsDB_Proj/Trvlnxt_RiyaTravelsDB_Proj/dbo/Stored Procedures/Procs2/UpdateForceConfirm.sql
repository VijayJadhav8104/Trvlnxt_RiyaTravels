
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE UpdateForceConfirm
	-- Add the parameters for the stored procedure here
	@id int=0,
	@ForceConfirmNumber nvarchar(200)='',
	@ModifiedBy int=0

AS
BEGIN
	
	update Hotel_BookMaster
	set ConfirmationNumber=@ForceConfirmNumber
	where pkId=@id

	----- set Force Confirmed status on status history table
	update hotel_status_history 
	set IsActive=0
		,ModifiedBy=@ModifiedBy
		,ModifiedDate = getdate()
	where FkHotelBookingId=@id
	insert into hotel_status_history(FKHotelBookingId,FkStatusId,CreatedBy)values(@id,3,@ModifiedBy)

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateForceConfirm] TO [rt_read]
    AS [dbo];

