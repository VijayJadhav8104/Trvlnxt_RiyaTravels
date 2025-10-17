	




CREATE proc [dbo].[spGetCountryCodePrefix]
@Key varchar(50),
@Val varchar(50) ='0'
AS
BEGIN

IF(@Val = '0')
BEGIN
SELECT  country,A1,code FROM [dbo].[Country]  WHERE code LIKE '%'+@Key+'%' OR country LIKE '%'+@Key+'%' OR A1 LIKE '%'+@Key+'%'
END
ELSE
BEGIN
SELECT  country,A1,code FROM [dbo].[Country]  WHERE  A1 LIKE '%'+@Key+'%'
END
END