      
CREATE Proc Hotel.PendingBookingCount      
as       
      
Begin      
select Count(HB.RequestForCancelled) as TotalCount       
from        
 Hotel_BookMaster HB        
 Left join Hotel_Status_History  SH on HB.pkid=SH.FKHotelBookingId and SH.IsActive=1       
-- where HB.ExpirationDate<GETDATE() and SH.FkStatusId=10     
where HB.RequestForCancelled='YES' and sh.FkStatusId in (4,3) 
end