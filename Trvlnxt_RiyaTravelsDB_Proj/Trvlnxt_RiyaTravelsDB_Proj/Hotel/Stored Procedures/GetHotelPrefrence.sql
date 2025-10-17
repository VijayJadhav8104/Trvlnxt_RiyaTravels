---Created Date :  08/05/2024 ---        
---- Created By : Aman W --        
--- Created For : select Date HotelPrefernce/block --        
        
  
  
    
  
  
CREATE Procedure Hotel.GetHotelPrefrence        
As        
Begin        
    
    
        
Select  Channel,Hotelname,HotelId,HotelAddress,HotelCity,Country,PreferedSupplierName as Prefrence,BlockedSupplier as Blocks     
from  Hotel.HotelPrefrence  where IsActive=1    
order by CreatedDate desc  
End