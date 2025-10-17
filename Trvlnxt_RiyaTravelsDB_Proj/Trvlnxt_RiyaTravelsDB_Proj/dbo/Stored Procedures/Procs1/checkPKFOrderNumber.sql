
Create PROCEDURE [dbo].[checkPKFOrderNumber] 
	@OrderNum varchar (50)

AS
BEGIN
	
	select pkid from tblBookMaster where PKForderNum=@OrderNum
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[checkPKFOrderNumber] TO [rt_read]
    AS [dbo];

