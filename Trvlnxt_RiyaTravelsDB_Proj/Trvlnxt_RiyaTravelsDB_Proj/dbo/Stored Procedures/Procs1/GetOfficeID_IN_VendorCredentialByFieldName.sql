CREATE procedure GetOfficeID_IN_VendorCredentialByFieldName  
@FieldName  varchar(50)  
AS      
BEGIN    
  
select    
OfficeId,    
Value,  
IsActive   
from mVendorCredential where FieldName = @FieldName and  Value = 1 and IsActive=1     
      
  
END