-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_ForesightData]
	@EMPNO varchar(100)
AS
BEGIN
	
	select
	ForesightId,
	Title,
	FirstName,
	MiddleName,
	LastName,
	FORMAT(DOB, 'dd MMM yyyy') AS DOB,
	Frequentflyer,
	PassportNumber,
	FORMAT(ExpiryDateofPassport, 'dd MMM yyyy') AS ExpiryDateofPassport,
	PassportIssuingCountry,
	Nationality,
	EMPNO
	from tbl_ForesightData where EMPNO =@EMPNO


END
