    
-- =============================================    
-- Author:  bhavika kawa    
-- Description: Vendor Credential    
-- =============================================    
CREATE PROCEDURE [dbo].[Sp_GetVendorCredential]    
 @VendorName varchar(50)    
AS    
BEGIN    
 --To get vendor Details    
 --select *  from mVendor where UPPER(VendorName)=UPPER(@VendorName) and IsActive=1 and IsDeleted=0    
    
 --To get Vendor Credential Details    
 select id,  
VendorId,  
OfficeId,  
replace(replace(FieldName,CHAR(10),''),CHAR(13),'') FieldName,  
Value,  
CreatedOn,  
CreatedBy,  
ModifiedOn,  
ModifiedBy,  
IsActive from mVendorCredential where 
VendorId=(select ID from mVendor where REPLACE(UPPER(VendorName), ' ', '')
=REPLACE(UPPER(@VendorName), ' ', '') and IsActive=1 and IsDeleted=0)  and IsActive=1  
    
 --to get vendor block details    
 --select v.*,c.Value as 'UserType' from mBlockVendor v     
 --join mCommon c on c.ID=v.UserTypeId    
 --where VendorId=(select ID from mVendor where UPPER(VendorName)=UPPER(@VendorName) and IsActive=1 and IsDeleted=0)    
END    


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorCredential] TO [rt_read]
    AS [dbo];

