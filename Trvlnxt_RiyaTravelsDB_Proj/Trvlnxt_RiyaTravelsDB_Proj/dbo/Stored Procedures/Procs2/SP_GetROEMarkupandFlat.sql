-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <09.12.2022>
-- Description:	<This procedure is used to get ROE Data through User Type, Product Type, From Currency, To Currency>
-- =============================================
--exec SP_GetROEMarkupandFlat 
CREATE PROCEDURE [dbo].[SP_GetROEMarkupandFlat] 
	@userTypeId Int,
	@productType varchar(100),
	@fromCurrency Varchar(10),
	@toCurrency Varchar(10),
	@IsAdmin Bit
AS
BEGIN
	IF(@IsAdmin=1)
	BEGIN
		SELECT ROE.ROE AS 'ROE',
		RO.MarkupType,
		RO.MarkupData,
		RO.ToCurrency,
		CASE RO.MarkupType WHEN 'PERCENTAGE' THEN ROE * RO.MarkupData/100 + ROE
		WHEN 'FLAT' THEN ROE +RO.MarkupData END 'FinalROE'
		FROM ROEWithMarkupAndFlat RO 
		FULL JOIN ROE ON RO.FromCurrency=ROE.FromCur and RO.ToCurrency=ROE.ToCur 
		WHERE RO.IsActive=1 AND ROE.IsActive=1 
	END
	ELSE
	BEGIN
		SELECT ROE.ROE AS 'ROE',
		RO.MarkupType,
		RO.MarkupData,
		RO.ToCurrency,
		CASE RO.MarkupType WHEN 'PERCENTAGE' THEN ROE * RO.MarkupData/100 + ROE 
		WHEN 'FLAT' THEN ROE + RO.MarkupData END 'FinalROE'
		FROM ROEWithMarkupAndFlat RO 
		FULL JOIN ROE ON RO.FromCurrency=ROE.FromCur and RO.ToCurrency=ROE.ToCur 
		WHERE RO.IsActive=1 AND ROE.IsActive=1 
		AND RO.UserTypeId=@userTypeId 
		AND RO.Products LIKE '%' + @productType  +'%' 
		AND RO.FromCurrency=@fromCurrency 
		AND RO.ToCurrency=@toCurrency
	END
END