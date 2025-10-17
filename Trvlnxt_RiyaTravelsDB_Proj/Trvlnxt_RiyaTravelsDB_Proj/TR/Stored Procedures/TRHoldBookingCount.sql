  
Create Proc TR.TRHoldBookingCount  
as   
  
Begin  
select Count(HB.BookingId) as TotalCount   
from    
 TR.TR_BookingMaster HB    
 Left join tr.TR_Status_History  SH on HB.BookingId=SH.BookingId and SH.IsActive=1   
 where HB.ExpirationDate<GETDATE() and SH.FkStatusId=3    
end