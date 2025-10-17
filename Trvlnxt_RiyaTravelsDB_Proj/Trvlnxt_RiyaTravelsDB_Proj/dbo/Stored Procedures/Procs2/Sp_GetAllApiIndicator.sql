-- ================================================        
-- Template generated from Template Explorer using:        
-- Create Procedure (New Menu).SQL        
-- =============================================        
-- Author:  Javed Bloch        
-- Description: to get api indicator list    
-- =============================================        
CREATE PROCEDURE [dbo].[Sp_GetAllApiIndicator]      
AS        
BEGIN      
 select v.VendorName,vc.Value,vc.OfficeId  from mVendor v inner join    
 mVendorCredential vc on v.ID=vc.VendorId    
 where vc.FieldName='ApiIndicator'    AND v.IsDeleted=0 AND VC.IsActive=1 
END 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAllApiIndicator] TO [rt_read]
    AS [dbo];

