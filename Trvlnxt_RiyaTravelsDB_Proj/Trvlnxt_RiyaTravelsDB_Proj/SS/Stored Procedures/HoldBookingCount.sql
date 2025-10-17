    
      
CREATE Proc SS.HoldBookingCount      
as       
      
Begin      
select Count(HB.BookingId) as TotalCount       
from        
 SS.SS_BookingMaster HB  WITH (NOLOCK)        
 Left join SS.SS_Status_History   SH  WITH (NOLOCK) on HB.BookingId=SH.BookingId and SH.IsActive=1       
 where HB.CancellationDeadline<GETDATE() and SH.FkStatusId=3        
end