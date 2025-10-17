  
    
CREATE Proc Hotel.HoldBookingCount    
as     
    
Begin    
select Count(HB.pkId) as TotalCount     
from      
 Hotel_BookMaster HB  WITH (NOLOCK)      
 Left join Hotel_Status_History  SH  WITH (NOLOCK) on HB.pkid=SH.FKHotelBookingId and SH.IsActive=1     
 where HB.ExpirationDate<GETDATE() and SH.FkStatusId=3      
end