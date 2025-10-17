              
--- created Date - 17 Apr  2024 --                      
--  Created by - Aman Wagde  --                      
                      
   ---  exec SS.PancardDetailsConsole  
  
CREATE Proc SS.PancardDetailsConsole                      
                      
as                      
begin                      
select   
BM.BookingId,                      
BM.BookingRefId,                      
BR.AgencyName,                      
BM.CancellationDeadLine,                      
                        
   Case                                                     
      when BM.PaymentMode=1 then HM.[Status]  +' /'+ '<span style="color:blue; font-weight:normal">Hold</span>'                                                                            
   when BM.PaymentMode=2 then HM.[Status]  +' /'+ '<span style="color:Black; font-weight:normal">Credit Limit</span>'                                                                                                              
   when  BM.PaymentMode=3 then HM.[Status]  +' /'+ '<span style="color:Black; font-weight:normal">Make Payment</span>'                                                                              
   when  BM.PaymentMode=4 then HM.[Status]  +' /'+ '<span style="color:Black; font-weight:normal">Self Balance</span>'                                                                                                              
   else   ''    end as   CurrentStatus,                       
                       
  isnull(BM.BookingCurrency +' '+ CONVERT(varchar(200), BM.BookingRate),'NA')                                                                                           
  AS 'Amount',                
  BM.CorporatePANVerificatioStatus as PanStatus                
                      
                      
from                      
 Ss.SS_BookingMaster BM  WITH (NOLOCK)                     
 Left join SS.SS_Status_History  SH WITH (NOLOCK) on BM.BookingId=SH.BookingId and SH.IsActive=1                      
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                       
 left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                      
 where  BM.CorporatePANVerificatioStatus='pending'           
 and sh.FkStatusId=3 and sh.IsActive=1          
 order by pkId desc                      
end