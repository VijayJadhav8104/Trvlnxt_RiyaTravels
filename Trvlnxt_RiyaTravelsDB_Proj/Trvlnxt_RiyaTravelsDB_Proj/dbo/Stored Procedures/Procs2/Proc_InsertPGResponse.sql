CREATE Procedure Proc_InsertPGResponse
@orderid varchar(100)=null,
@status varchar(50)=null,
@EncriptDecripCode varchar(500)=null,
@txnID Varchar(200)=null,
@failureMsg varchar(500)=null
As
Begin
	Insert into HotelMakePaymentResponse(Orderid,Status,EncriptDecripCode,TxnID,FailureMsg)
	values(@orderid,@status,@EncriptDecripCode,@txnID,@failureMsg)
End