
CREATE proc [dbo].[spGetExchangeReate]
as
begin

SELECT [PKID_int]
      ,[currencyname_vc]
      ,[currencycode_vc]
      ,[salerate_ft]
	  ,cast(buyrate_ft as decimal(10,2)) as buyrate_ft
      ,[inserteddt_dt]
      ,[updateddt_dt]
      ,[status]
	  ,inserteddt_dt
      ,ISNULL(updateddt_dt,[createdOn]) as [date]
  FROM [dbo].[CMS_ExchangeRates]
  order by [date] desc

end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetExchangeReate] TO [rt_read]
    AS [dbo];

