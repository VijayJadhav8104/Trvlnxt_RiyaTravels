-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [SS].[UpdateMakePaymentReversalStatus]
	
	@PkId int=0,
	@Book_Id varchar(500)=null,
	@status varchar(200)=null,
	@StatusFlag varchar(200)=null,
	@msg varchar(max)=null

	
AS
BEGIN
	

	update SS.SS_BookingMaster set MakePaymentReversalFlag=@status , 
								MakePaymentReversalStatus=@StatusFlag,
								MakePaymentReversalMessage=@msg

	where BookingId = @PkId

END
