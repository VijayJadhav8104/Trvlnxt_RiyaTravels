        
--- created Date - 17 Apr  2024 --                
--  Created by - Aman Wagde  --                
                
CREATE Proc Hotel.PendingPanCardConsole                
                
as                
begin                
select  count(distinct (HB.pkId)) as TotalCount  
         
from                
 Hotel_BookMaster HB       
 left join Hotel_Status_History SH on HB.pkId= SH.FKHotelBookingId    
where  HB.CorporatePANVerificatioStatus='pending'           
      and SH.FkStatusId=3  and IsActive=1       
end  
  
  
  