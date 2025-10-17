--- created Date - 25 March  2025 --          
--  Created by - Aman Wagde  --          
  --exec SS.Activity_Pending_Booking        
CREATE Proc SS.Activity_Pending_Booking          
          
as          
begin          
select 
 BM.BookingId as pkId,          
BM.BookingRefId as BookingReference,          
BR.AgencyName,          
Convert(varchar, ISNULL(BM.CancellationDeadline,'')) as CancellationDeadLine,          
            
  Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+                                                                                                                                    
    Case when BM.PaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                                                                            
   when BM.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                           
   when  BM.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                            
   when  BM.PaymentMode=4 then '<span style="color:Black; ">Self Balalnce</span>'                                                                    
   else   ''                                                                                                  
   end                                                                
                                                                                                                               
   else HM.Status +' / '+ Case when BM.PaymentMode=1 then '<span style="color:blue;">Hold</span>'                                                                                                                            
   when BM.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                            
   when  BM.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                            
   when  BM.PaymentMode=4 then '<span style="color:Black; ">Self Balance</span>'                                                                          
   when  BM.PaymentMode=5 then '<span style="color:Black; ">PayAtHotel</span>'                                                                                                                           
   else   'NA'                                                                                                                            
   end                                                                                                                                                  
   End as CurrentStatus,           
          
   Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200), BM.BookingRate) 
                                                                                 
  AS 'Amount'          
          
          
from          
 ss.SS_BookingMaster BM   WITH (NOLOCK)          
 left join Ss.SS_Status_History SH on BM.BookingId=SH.BookingId and SH.Isactive=1           
 left join B2BRegistration BR on BM.AgentID=BR.FKUserID            
 left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id          
 where BM.Pendingcancellation=1    and Sh.FkStatusId in (4,3)    
 order by pkId desc          
end