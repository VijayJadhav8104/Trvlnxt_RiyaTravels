
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertRemarks]
	-- Add the parameters for the stored procedure here
		@GDSPNR varchar(30)=null,
		@RiyaPNR varchar(30),
		@OrderID varchar(30),
		@Remark varchar(1000),
		@UserID varchar(30),
		@Flag int =0 --Flag=1 then TicketRemark && Flag=2 then BookingRemark
AS
BEGIN
			if(@GDSPNR is null)
			begin
				UPDATE tblBookMaster
				SET Remarks=@Remark,
				IsBooked=null,
				userid=@UserID where riyaPNR=@RiyaPNR
			end
			else
			begin
				update tblPassengerBookDetails
				set  cancelclosed=1, cancellationRemark=@Remark
				where fkBookMaster in(select pkid from tblBookMaster where riyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR)
			end
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertRemarks] TO [rt_read]
    AS [dbo];

