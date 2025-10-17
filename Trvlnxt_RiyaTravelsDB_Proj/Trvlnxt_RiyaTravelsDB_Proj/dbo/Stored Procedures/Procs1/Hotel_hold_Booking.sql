    
--- created Date - 15 jan  2024 --    
--  Created by - Aman Wagde  --    
    
CREATE Proc Hotel_hold_Booking    
    
as    
begin    
select HB.pkId,    
BookingReference,    
BR.AgencyName,    
HB.CancellationDeadLine,    
      
  Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+                                                                                                                              
    Case when B2BPaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                                                                      
   when B2BPaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                     
   when  B2BPaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                      
   when  B2BPaymentMode=4 then '<span style="color:Black; ">Self Balalnce</span>'                                                              
   else   ''                                                                                            
   end                                                          
                                                                                                                         
   else HM.Status +' / '+ Case when B2BPaymentMode=1 then '<span style="color:blue;">Hold</span>'                                                                                                                      
   when B2BPaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                      
   when  B2BPaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                      
   when  B2BPaymentMode=4 then '<span style="color:Black; ">Self Balance</span>'                                                                    
   when  B2BPaymentMode=5 then '<span style="color:Black; ">PayAtHotel</span>'                                                                                                                     
   else   'NA'                                                                                                                      
   end                                                                                                                                            
   End as CurrentStatus,     
    
   (HB.CurrencyCode +' '+ HB.DisplayDiscountRate )                                                                          
  AS 'Amount'    
    
    
from    
 Hotel_BookMaster HB  WITH (NOLOCK)   
 Left join Hotel_Status_History  SH  WITH (NOLOCK) on HB.pkid=SH.FKHotelBookingId and SH.IsActive=1    
 left join B2BRegistration BR  WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID     
 left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id    
 where HB.ExpirationDate<GETDATE() and SH.FkStatusId=3    
 order by pkId desc    
end