-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--exec Get_VendorCredentialCountry 'DFW1S212A'
-- =============================================
CREATE PROCEDURE [dbo].[Get_VendorCredentialCountry]
	@OfficeId varchar(100)
AS
BEGIN
	
	SELECT TOP 1 Value From mVendorCredential where OfficeId=@OfficeId AND FieldName='CountryCode' AND IsActive=1

END
