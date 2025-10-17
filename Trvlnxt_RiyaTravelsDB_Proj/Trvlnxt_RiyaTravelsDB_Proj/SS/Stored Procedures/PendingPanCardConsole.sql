            
--- created Date - 19 Sep  2024 --                    
--  Created by - Aman Wagde  --                    
                    
CREATE Proc SS.PendingPanCardConsole                    
                    
as                    
begin                    
  
select count(distinct (BM.BookingId)) as TotalCount   
from   
SS.SS_BookingMaster BM  
left join Ss.SS_Status_History SH on Bm.BookingId=SH.BookingId  
where BM.CorporatePANVerificatioStatus='Pending'  
and SH.FkStatusId=3 and SH.IsActive=1      
end      
      
  