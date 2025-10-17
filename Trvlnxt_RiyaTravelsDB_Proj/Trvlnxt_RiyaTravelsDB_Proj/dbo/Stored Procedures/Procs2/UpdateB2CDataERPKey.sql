CREATE PROC [dbo].[UpdateB2CDataERPKey]
@id int
,@key Nvarchar(50)
,@order_Id Nvarchar(30)
,@paymentKey Nvarchar(50)=''
AS
BEGIN

update tblPassengerBookDetails set ERPkey=@key  where pid=@id

IF(@paymentKey!='')
	BEGIN
	update Paymentmaster set ERPKey=@paymentKey where order_id=@order_Id
	END

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateB2CDataERPKey] TO [rt_read]
    AS [dbo];

