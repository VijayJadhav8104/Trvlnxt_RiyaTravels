
CREATE proc [dbo].[spUpdateExchangeRateStatus]
as
begin
   update [CMS_ExchangeRates] set status=0;
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateExchangeRateStatus] TO [rt_read]
    AS [dbo];

