--==========================================
--Created by : Shivkumar Prajapati
--Creation Date : 13/10/2020
--Desc : Created due to insert the data of payment gateway request

--==========================================
CREATE procedure UpdatePaymentReq
@APIOrderID nvarchar(50),
@EncryptReqPayment nvarchar(max),
@DecryptReqPay  nvarchar(max)
as
begin

if exists(select * from APIDataStoreHotel where APIOrderID=@APIOrderID)
begin
update APIDataStoreHotel set EncryptReqPayment =@EncryptReqPayment,DecryptReqPay=@DecryptReqPay where APIOrderID=@APIOrderID
end

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePaymentReq] TO [rt_read]
    AS [dbo];

