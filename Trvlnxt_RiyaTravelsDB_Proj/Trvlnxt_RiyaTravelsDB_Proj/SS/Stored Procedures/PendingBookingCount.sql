        
CREATE Proc SS.PendingBookingCount        
as         
        
Begin        
select Count(HB.Pendingcancellation) as TotalCount         
from          
 SS.SS_BookingMaster HB          
 Left join SS.SS_Status_History  SH on HB.BookingId=SH.BookingId and SH.IsActive=1         
-- where HB.ExpirationDate<GETDATE() and SH.FkStatusId=10       
where HB.Pendingcancellation=1 and sh.FkStatusId in (4,3)   
end