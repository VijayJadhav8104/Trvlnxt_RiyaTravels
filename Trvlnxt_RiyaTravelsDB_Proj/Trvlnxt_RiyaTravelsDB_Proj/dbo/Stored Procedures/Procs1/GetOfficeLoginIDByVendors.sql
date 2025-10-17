-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <11.05.2023>
-- Description:	<This procedure is used to get all Office/Login Id by Vendor IDS>
-- =============================================
--exec [dbo].[GetOfficeLoginIDByVendors] '7,38'
CREATE PROCEDURE [dbo].[GetOfficeLoginIDByVendors]
	@VendorIds Varchar(MAX)
AS
BEGIN
	Declare @OfficeID Varchar(Max)
	SELECT @OfficeID =
	(select STUFF((SELECT ','+ ven.OfficeId --+' / '+ ven.vendorname +' / '+ CONVERT(varchar(max),ven.ID)  
		FROM mVendor ven  WITH (NOLOCK)
		WHERE ven.IsActive=1 AND IsDeleted=0 
		AND ven.ID in (select DATA from sample_split(@VendorIds,',')
		--ORDER BY VendorName
		) FOR XML PATH('')  
		), 1, 1, ''))
		
		--(select STUFF((SELECT ','+ ven.OfficeId   
		--FROM mVendor ven  WITH (NOLOCK)
		--WHERE ven.IsActive=1 AND IsDeleted=0 
		--AND ven.ID in (select DATA from sample_split(@VendorIds,',')
		----ORDER BY VendorName
		--) FOR XML PATH('')  
		--), 1, 1, '')) 
	

	--(select a.value AS OfficeId FROM dbo.[fn_split](ven.OfficeId,',') as a )OfficeId
	SELECT value AS OfficeId from dbo.[fn_split](@OfficeID,',')  AS OfficeId
END