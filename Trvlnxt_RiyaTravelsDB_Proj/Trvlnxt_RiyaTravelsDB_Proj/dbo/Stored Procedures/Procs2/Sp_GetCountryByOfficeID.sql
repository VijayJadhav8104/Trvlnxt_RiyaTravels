-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <10.03.2023>
-- Description:	<Create New Stored Procedure to get Country code by Office ID>
-- =============================================
--exec [dbo].[Sp_GetCountryByOfficeID] 'DFW1S212A'
CREATE PROCEDURE [dbo].[Sp_GetCountryByOfficeID]
	@OfficeID Varchar(50)=null
AS                          
BEGIN
	SELECT TOP 1 ltrim(rtrim(VC.Value)) AS 'CountryCode'
	FROM mVendorCredential AS VC
	INNER JOIN mVendor AS V on VC.VendorId=V.ID
	WHERE VC.OfficeId=@OfficeID
	AND VC.IsActive=1
	AND V.IsActive=1
	AND V.IsDeleted=0
	AND (VC.FieldName='CountryCode')-- OR VC.FieldName='ERP Country')
	AND VC.Value IS NOT NULL
END