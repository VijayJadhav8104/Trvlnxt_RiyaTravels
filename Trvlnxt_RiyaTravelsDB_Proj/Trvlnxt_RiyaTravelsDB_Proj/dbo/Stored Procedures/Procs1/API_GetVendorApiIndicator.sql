CREATE PROCEDURE [dbo].[API_GetVendorApiIndicator]  
AS
BEGIN
select distinct m.FieldName,m.OfficeId,m.Value,replace(v.VendorName,' ','')as VendorName From mVendorCredential as m inner join mVendor as v on m.VendorId = v.ID  
where FieldName = 'ApiIndicator' and v.Product = 'Airline' and v.IsActive = 1 and v.IsDeleted = 0 AND m.IsActive=1 
End