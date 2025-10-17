      
--- created Date - 15 jan  2024 --      
--  Created by - Aman Wagde  --      
      
CREATE Proc SS_Activity_hold_Booking      
      
as      
begin      
select 
HB.BookingId as pkId,      
  HB.BookingRefId as BookingReference,      
BR.AgencyName,      
HB.CancellationDeadLine,      
        
  Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+                                                                                                                                
    Case when HB.PaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                                                                        
   when HB.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                       
   when  HB.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                        
   when  HB.PaymentMode=4 then '<span style="color:Black; ">Self Balalnce</span>'                                                                
   else   ''                                                                                              
   end                                                            
                                                                                                                           
   else HM.Status +' / '+ Case when HB.PaymentMode=1 then '<span style="color:blue;">Hold</span>'                                                                                                                        
   when HB.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                        
   when  HB.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                        
   when  HB.PaymentMode=4 then '<span style="color:Black; ">Self Balance</span>'                                                                      
   when  HB.PaymentMode=5 then '<span style="color:Black; ">PayAtHotel</span>'                                                                                                                       
   else   'NA'                                                                                                                        
   end                                                                                                                                              
   End as CurrentStatus,       
      
   (HB.BookingCurrency +' '+ CAST(HB.BookingRate as varchar(500)))                                                                            
  AS 'Amount'      
      
      
from      
 ss.SS_BookingMaster HB  WITH (NOLOCK)     
left join Ss.SS_Status_History SH on HB.BookingId=SH.BookingId ANd SH.IsActive=1     
 left join B2BRegistration BR on HB.AgentID=BR.FKUserID       
 left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id      
 where HB.CancellationDeadline<GETDATE() and SH.FkStatusId=3      
 order by pkId desc      
end