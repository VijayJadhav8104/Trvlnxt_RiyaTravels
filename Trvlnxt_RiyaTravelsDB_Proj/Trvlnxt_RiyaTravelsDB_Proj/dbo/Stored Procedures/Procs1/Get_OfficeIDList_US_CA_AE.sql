CREATE proc [dbo].[Get_OfficeIDList_US_CA_AE]--[dbo].[Get_OfficeIDList_US_CA_AE] 'IN' 
@CountryCode varchar(100)
as                    
begin                            
 select OfficeId from mVendorCredential where IsActive=1  and FieldName='CountryCode' 
 and Value in (select Data from sample_split(@CountryCode,','))  
 AND VendorId IN (SELECT ID FROM mVendor WHERE IsActive=1 AND IsDeleted=0   
 AND VendorName='Amadeus')
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_OfficeIDList_US_CA_AE] TO [rt_read]
    AS [dbo];

