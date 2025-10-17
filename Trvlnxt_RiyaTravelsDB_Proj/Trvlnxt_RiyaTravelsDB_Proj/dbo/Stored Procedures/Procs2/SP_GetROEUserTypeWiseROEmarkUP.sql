CREATE PROCEDURE [dbo].[SP_GetROEUserTypeWiseROEmarkUP] 
	@userType VARChar(50)=null,
	@fromCurrency Varchar(10)=null,
	@toCurrency Varchar(10)=null
AS
BEGIN
	if(@userType='RBT')
	BEGIN
		SELECT TOP 1 NewROE AS ROE FROM mROEHistoryAir
		WHERE fromCountry=@FromCurrency AND ToCountry=@ToCurrency ORDER BY InsertedDate DESC
	END
	ELSE
	BEGIN
		SELECT ROE FROM ROE WHERE IsActive=1 AND FromCur=@FromCurrency AND ToCur=@ToCurrency
	END
END
