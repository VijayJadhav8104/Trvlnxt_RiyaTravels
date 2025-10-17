
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCancelFlag]
	@RiyaPNR varchar(20) = NULL
AS
BEGIN
	UPDATE tblPassengerBookDetails 
	set Iscancelled=1 , CancelledDate = GETDATE() 
	WHERE fkBookMaster in(SELECT pkId FROM tblBookMaster b WHERE b.GDSPNR=@RiyaPNR) 

	UPDATE tblBookMaster 
	set canceledDate=GETDATE() 
	WHERE GDSPNR=@RiyaPNR
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateCancelFlag] TO [rt_read]
    AS [dbo];

