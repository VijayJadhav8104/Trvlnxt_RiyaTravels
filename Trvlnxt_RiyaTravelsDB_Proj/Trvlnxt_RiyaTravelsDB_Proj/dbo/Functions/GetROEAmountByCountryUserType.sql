--select (dbo.GetROEAmountByCountryUserType ('AE','2'))
CREATE FUNCTION  [dbo].[GetROEAmountByCountryUserType] (
	@country VARCHAR(2),
	@usertype VARCHAR(5)
)
RETURNS Decimal(18,2) AS
BEGIN
	Declare @ROE decimal(18,2)
	select @ROE =
	cast(CASE WHEN 
					(SELECT top 1 Value FROM mVendorCredential WHERE OfficeId=book.OfficeID AND FieldName='Currency'AND IsActive=1) != 
					(SELECT Currency FROM mCountry WHERE CountryCode=@country) 
				THEN 
					(SELECT ROE FROM mROEUpdation R WHERE ISACTIVE=1  AND FLAG=1 AND OfficeID in (SELECT pkid FROM tbl_commonmaster WHERE CategoryValue=book.OfficeID) AND BaseCurrencyId in (SELECT ID FROM mCommon WHERE Value in (SELECT top 1 Value FROM mVendorCredential WHERE OfficeId=book.OfficeID AND FieldName='Currency' AND IsActive=1) ) AND ToCurrencyId in (SELECT ID FROM mCommon WHERE Value in (SELECT Currency FROM mCountry WHERE CountryCode=@country)) AND UserTypeId=@usertype AND CountryId IN (SELECT ID FROM mCountry WHERE CountryCode=@country)) 
				ELSE 
					1 
				END
	 AS decimal(18,2))
	FROM tblPassengerBookDetails pax
	LEFT JOIN tblBookMaster book ON pax.fkBookMaster=book.pkId 
		AND AgentID !='B2C' AND book.totalFare > 0 AND pax.totalFare > 0

	RETURN @ROE
END