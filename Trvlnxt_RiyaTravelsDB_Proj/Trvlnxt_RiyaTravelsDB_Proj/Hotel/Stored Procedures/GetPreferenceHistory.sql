      
      
      
CREATE PROCEDURE [Hotel].[GetPreferenceHistory]                   
    
 @HotelId varchar(400) =''                  
as                   
             
 Begin                  
select     
--CreatedDate,
FORMAT(CreatedDate, 'dd-MMM-yyyy HH:mm:ss') as CreatedDate,
Mu.FullName +' - '+Mu.UserName  as CredatedBy,    
BlockedSupplier  as 'SupplierList'   
--case when HP.isActive=1 then BlockedSupplier end as 'InsertedSupplier',
--case when HP.isActive=0 then BlockedSupplier end as 'DeletedSupplier'
    
from Hotel.HotelPrefrence HP    
left join mUser mu on Hp.CredatedBy=mu.ID    
where HotelId=@HotelId    
END 

