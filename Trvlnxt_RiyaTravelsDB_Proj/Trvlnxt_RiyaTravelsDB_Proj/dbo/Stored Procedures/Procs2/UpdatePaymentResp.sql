
--==========================================
--Created by : Shivkumar Prajapati
--Creation Date : 13/10/2020
--Desc : Created due to insert the data of payment gateway responce

--==========================================
CREATE procedure UpdatePaymentResp
@APIOrderID nvarchar(50),
@EncryptResPayment nvarchar(max),
@DecryptResPay  nvarchar(max)
as
begin

if exists(select * from APIDataStoreHotel where APIOrderID=@APIOrderID)
begin
update APIDataStoreHotel set EncryptResPayment =@EncryptResPayment,DecryptResPay=@DecryptResPay where APIOrderID=@APIOrderID
end

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePaymentResp] TO [rt_read]
    AS [dbo];

