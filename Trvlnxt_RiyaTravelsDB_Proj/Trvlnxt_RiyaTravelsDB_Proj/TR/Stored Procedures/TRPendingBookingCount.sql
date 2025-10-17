CREATE Proc TR.TRPendingBookingCount    
as     
    
Begin    
select Count(HB.RequestForCancelled) as TotalCount     
from      
 TR.TR_BookingMaster HB      
 Left join TR.TR_Status_History  SH on HB.BookingId=SH.BookingId and SH.IsActive=1     
-- where HB.ExpirationDate<GETDATE() and SH.FkStatusId=10   
where HB.RequestForCancelled='YES'  
end