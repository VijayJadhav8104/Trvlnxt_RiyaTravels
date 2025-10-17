CREATE PROCEDURE [dbo].[sp_UpdateIsBookedStatus]
	@RiyaPNR varchar(20),
	@OrderID varchar(200),
	@IsBooked int
AS
BEGIN
	Update tblBookMaster set IsBooked = @IsBooked where riyaPNR = @RiyaPNR and orderId =@OrderID
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdateIsBookedStatus] TO [rt_read]
    AS [dbo];

