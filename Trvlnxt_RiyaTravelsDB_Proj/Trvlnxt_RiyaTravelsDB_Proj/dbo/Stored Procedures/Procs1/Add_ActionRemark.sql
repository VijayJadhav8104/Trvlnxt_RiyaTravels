
CREATE PROCEDURE [dbo].[Add_ActionRemark]

@OrderId			varchar(30) = NULL,
@GDSPNR				varchar(10) = NULL,
@UserId				int,
@ActionRemark		varchar(1000),
@IP					varchar(20)


AS BEGIN

  


		INSERT INTO AgentHistory (OrderId,GDSPNR,UserId, Remark, IP, InsertDate)
		VALUES(@OrderId,@GDSPNR,@UserId,@ActionRemark,@IP,GETDATE())

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Add_ActionRemark] TO [rt_read]
    AS [dbo];

