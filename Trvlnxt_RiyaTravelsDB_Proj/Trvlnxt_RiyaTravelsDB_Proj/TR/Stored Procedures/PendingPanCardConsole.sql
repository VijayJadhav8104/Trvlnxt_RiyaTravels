--- created Date - 19 Feb  2025 --            
--  Created by - Amol Chaudhari  --            
            
CREATE Proc TR.PendingPanCardConsole            
            
as            
begin            
select  Count(HB.BookingId) as TotalCount            
    
      
from            
 TR.TR_BookingMaster HB                 
where  HB.CorporatePANVerificatioStatus='pending'or HB.CorporatePANVerificatioStatus='reject'        
           
end