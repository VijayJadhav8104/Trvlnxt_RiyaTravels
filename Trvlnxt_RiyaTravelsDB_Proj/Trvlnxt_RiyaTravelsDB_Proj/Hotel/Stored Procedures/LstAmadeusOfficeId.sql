
--Created Date : 20/09/2023 --------------------- 
--Author By: Akash Singh ------------------------
--Description : Get all Amadeus Office id -------
Create Proc [Hotel].LstAmadeusOfficeId
As
BEGIN

 select VendorName,vc.OfficeId from mVendorCredential vc with (nolock) 
inner join mvendor v with (nolock) on v.ID=vc.VendorId 
where vc.IsActive=1 and v.IsActive=1 and v.IsDeleted=0 
and v.VendorName='Amadeus' and FieldName='OfficeID' 

END