--- created Date - 5 march  2025 --      
--  Created by - Amol C  --      
      
CREATE Proc Transfer_hold_Booking      
      
as      
begin      
select top 100 HB.BookingId,      
HB.BookingRefId,      
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
   --when  HB.PaymentMode=5 then '<span style="color:Black; ">PayAtHotel</span>'                                                                                                                     
   else   'NA'                                                                                                                      
   end                                                                                                                                            
   End as CurrentStatus,            
      
  ISNULL(HB.BookingCurrency + ' ' + CAST(HB.AmountBeforePgCommission AS VARCHAR), 'NA') AS Amount 
     
      
      
from      
  TR.TR_BookingMaster HB    
 Left join tr.TR_Status_History  SH on HB.BookingId=SH.BookingId and SH.IsActive=1    
 left join B2BRegistration BR on HB.AgentID=BR.FKUserID     
 left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id 
 where HB.ExpirationDate<GETDATE() and SH.FkStatusId=3      
 order by BookingId desc      
end