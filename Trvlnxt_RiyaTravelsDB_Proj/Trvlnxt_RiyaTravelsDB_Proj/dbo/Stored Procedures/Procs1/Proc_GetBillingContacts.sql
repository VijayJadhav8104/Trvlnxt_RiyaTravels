  
  
CREATE Procedure Proc_GetBillingContacts        
@SupplierId int    
    
As        
Begin        
 select * from [hotel].BillingContact  where Id=1      
End