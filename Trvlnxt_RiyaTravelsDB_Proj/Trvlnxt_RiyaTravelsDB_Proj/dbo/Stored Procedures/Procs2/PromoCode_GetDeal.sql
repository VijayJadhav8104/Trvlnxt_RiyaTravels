/****** Script for SelectTopNRows command from SSMS  ******/

CREATE PROC [dbo].[PromoCode_GetDeal]
AS BEGIN
	SELECT case when discounttype='Percent' then  MAX(MaxAmt) else MAX(Discount) END AS Discount, AirportType as FareType, PromoCode
	FROM [RiyaTravels].[dbo].[Flight_PromoCode]
	WHERE  CONVERT(date,SaleValidityFrom)   <= CONVERT(date,GETDATE()) and CONVERT(date,SaleValidityTo)   >= CONVERT(date,GETDATE())
	GROUP BY AirportType,PromoCode,discounttype
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PromoCode_GetDeal] TO [rt_read]
    AS [dbo];

