

CREATE proc [dbo].[getROEForExtension]
@fromCurrency varchar(20),
@toCurrency varchar(20)

as


SELECT ROE,FromCur,ToCur FROM ROE 
WHERE ToCur =@toCurrency
AND IsActive = 1
ORDER BY InserDate DESC
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getROEForExtension] TO [rt_read]
    AS [dbo];

