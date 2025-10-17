CREATE procedure [dbo].[UpdateMCOMerchantFee]
@MCOMerchantfee varchar(250) = '0',
@PaxId int = 0
AS
begin
Update tblpassengerbookdetails set [MCOMerchantfee] = @MCOMerchantfee where [pid] = @PaxId
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateMCOMerchantFee] TO [rt_read]
    AS [dbo];

