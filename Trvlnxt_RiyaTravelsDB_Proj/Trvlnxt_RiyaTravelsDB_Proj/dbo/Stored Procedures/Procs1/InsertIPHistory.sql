



CREATE PROCEDURE [dbo].[InsertIPHistory]
@ActionRemark		varchar(1000),
@GDSPNR				varchar(10) = NULL,
@IP					varchar(20),
@OrderId			varchar(30) = NULL,
@Device				varchar(30),
@RiyaPNR			varchar(10) = NULL,
@UserId				int,
@ActionStatus		bit


AS BEGIN
		INSERT INTO IPHistory (ActionRemark,GDSPNR,IP, OrderId, Device,  RiyaPNR, UserId,ActionStatus)
		VALUES(@ActionRemark, @GDSPNR, @IP, @OrderId, @Device,  @RiyaPNR, @UserId, @ActionStatus)

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertIPHistory] TO [rt_read]
    AS [dbo];

