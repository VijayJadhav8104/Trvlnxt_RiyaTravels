
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCancelFlagforFailBooking]
	@RiyaPNR varchar(20) = NULL
AS
BEGIN
	UPDATE tblPassengerBookDetails 
	set FailedFlag=1 
	WHERE fkBookMaster in(SELECT pkId FROM tblBookMaster b WHERE b.GDSPNR=@RiyaPNR) 

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCancelFlagforFailBooking] TO [rt_read]
    AS [dbo];

