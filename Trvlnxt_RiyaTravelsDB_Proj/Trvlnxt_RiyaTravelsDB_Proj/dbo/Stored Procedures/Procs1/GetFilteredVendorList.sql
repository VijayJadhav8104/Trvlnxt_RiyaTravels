--exec [GetFilteredVendorList] '',-1,'-Select-'
CREATE PROCEDURE [dbo].[GetFilteredVendorList]
	@VendorName varchar(500),
	@Status int,
	@ProductType varchar(10)
	
AS
BEGIN
	SELECT 
	Ven.ID,
	Ven.Product,
	Ven.VendorName,
	Ven.PersonName,
	Ven.ContactNo,
	Ven.EmailId,
	Ven.Fields,
	Ven.AirlineCode,
	Ven.OfficeId,
	Ven.IsMultipleAirline,
	Ven.Username,
	Ven.Password,
	Ven.Commission_Net,
	Ven.CreatedOn,
	--Ven.CreatedBy,
	CUsr.UserName AS CreatedBy,
	Ven.ModifiedOn,
	--Ven.ModifiedBy,
	mUsr.UserName AS ModifiedBy,
	Ven.IsActive,
	Ven.IsDeleted
	FROM [dbo].[mVendor] AS Ven
	LEFT JOIN mUser AS CUsr on CUsr.ID=Ven.CreatedBy
	LEFT JOIN mUser AS MUsr on MUsr.ID=Ven.ModifiedBy
	WHERE 
	((@VendorName ='') or (Ven.ID IN (select Data from sample_split(@VendorName,','))) )
	AND (@Status=-1 OR Ven.IsActive=@Status)
	AND (@ProductType='-Select-' OR Ven.Product=@ProductType)
	AND IsDeleted=0
END