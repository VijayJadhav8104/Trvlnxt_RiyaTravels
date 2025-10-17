

CREATE proc [dbo].[getROERate]-- 'USD','INR'
@fromCurrency varchar(20),
@toCurrency varchar(20)

as


SELECT TOP 1 (ROE + (ROE*2)/100) AS ROE FROM ROE 
WHERE FromCur LIKE '%'+ @fromCurrency +'%' AND ToCur LIKE '%'+ @toCurrency +'%'
AND IsActive = 1
ORDER BY InserDate DESC


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getROERate] TO [rt_read]
    AS [dbo];

