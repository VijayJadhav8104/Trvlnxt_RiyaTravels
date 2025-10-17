  
      
--- Created by Suvarna gavai --    
      
CREATE PROCEDURE spPendingCancellation           
@skipRows int=0,             
@takeRows int=20        
AS            
BEGIN       
      
 ;WITH Hotel_cte AS (      
select distinct                                                                                                                                  
 HB.pkId,                                                                                       
  case when  HB.RequestForCancelled is null then 0 when HB.RequestForCancelled='NO' then 0 else 1 end as 'RequestForCancelled',                                                  
  case when HB.payhotelpaymentstatus=1 then 'Paid'                                                    
  when HB.payhotelpaymentstatus=0 then 'Pending' else '' end as 'Pay@hotelPaymentStatus',                                                                                 
                                                                                                                                        
  HB.BookingReference as book_Id                                                                                                                     
   ,  HB.orderId as 'OrderID'                                                                                                                                                                                                                 
                                           
   ,Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+                                                                                                                          
    Case when B2BPaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                                                                  
   when  B2BPaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                 
   when B2BPaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                  
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
   End as CurrentStatus                                                
                                                                                                                                  
     ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'                                                                                                                     
                                                               
   ,HB.cityName as Destination                                                         
    , 'INR' as 'InrCurrency'                                                  
 ,HCC.EarningAmount as 'EarningAmt'  --add column on 9-5-23                                     
                                                                     
   , CASE                                                   
         WHEN SH.MethodName= 'Manually_OfflineCancel' or SH.MethodName= 'H' or SH.MethodName='HotelBookingCancel' and SH.IsActive=1  THEN  CONCAT(HB.CurrencyCode,' ',Convert(nvarchar,isnull(HB.agentCancellationCharges,0)))                                 
 
    
       
        
 ELSE (HB.CurrencyCode +' '+ HB.DisplayDiscountRate )                                                                      
 END AS 'Amount',                                 
                                                     
   convert(varchar,HB.inserteddate, 0) as BookingDate                         
   ,HB.CheckInDate as ServiceDate   --*                                                                  
   ,convert(varchar,CancellationDeadLine,0) as DeadlineDate                                              
   ,HB.SupplierName                                                   
   ,HB.SupplierReferenceNo                                                                                                 
  ,Case                                                    
      when B2BPaymentMode=1 then '<span style="color:blue; font-weight:bold">Hold</span>'                                                                                
   when B2BPaymentMode=2 then '<span style="color:Black; font-weight:bold">Credit Limit</span>'                                                                                                                  
   when  B2BPaymentMode=3 then '<span style="color:Black; font-weight:bold">Make Payment</span>'                                   
   when  B2BPaymentMode=4 then '<span style="color:Black; font-weight:bold">Self Balalnce</span>'                                                                                                                  
   else   ''    end as 'PaymentMode'                ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'                                                                                                                           
  
   
       
        
               
   ,HB.BookingReference as   ConfirmationNumber   --*                                                                         
   ,HB.VoucherNumber as VoucherID                                                                                  
   ,HB.VoucherDate as VoucherDate                                                                                                                                    
   ,HB.AgentRefNo as AgentReferenceNo                                                                                                                                          
  ,HB.HotelConfNumber as HotelConfirmationAdded                                                                                   
  ,HB.PayAtHotel as PayAtHotel                                                                          
                                                             
   ,'' as LastModifiedDate                                                                                                                                          
   ,CancelDate as CancellationDate  --*                                                             
,'' as 'Action',                                                                                                                                          
   HB.HotelName,                                
case when (HB.ExpirationDate is null) then '2018-03-12 00:00:00.000' else HB.ExpirationDate End as ExpirationDate                                                                                                 
---                                                                                              
, case ReconStatus when 'N' then 'Red' when 'Y' then 'LimeGreen' else 'Black' end as 'ReconStatus'                                                         
 --,case when hb.PayAtHotel = 1 and Hb.orderId=tba.BookingRef then 1 else 0 end as [payathotel]                                                        
   ,HB.HotelConfNumber as 'HotelConfirmation'                         
--                                                                                              
from Hotel_BookMaster HB WITH(NOLOCK)                                                                                      
  left join mUser MU WITH(NOLOCK) on HB.MainAgentID=MU.ID                                                                                                                            
  left join Hotel_Pax_master HP WITH(NOLOCK) on HB.pkId=HP.book_fk_id                                                                                                               
  left join Hotel_Status_History SH WITH(NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                                      
  left join B2BRegistration BR WITH(NOLOCK) on HB.RiyaAgentID=BR.FKUserID                                                                                                                                           
  join AgentLogin AGL WITH(NOLOCK) on HB.RiyaAgentID=AGL.UserID                                                                                                                                          
  --left join Hotel_Status_History HSH on HB.book_Id=HSH.FKHotelBookingId                                                               
  left join Hotel_Status_Master HM  WITH(NOLOCK) on SH.FkStatusId=HM.Id                
  left join  mBranch MB WITH(NOLOCK) on MB.BranchCode=BR.BranchCode                                                              
   left join Hotel_UpdatedHistory HU WITH(NOLOCK) on HU.fkbookid=HB.pkid                                                    
   LEFT join Hotel_Room_master RM WITH(NOLOCK) on HP.room_fk_id=RM.Room_Id                                                  
     --  left join tblAgentBalance tba on HB.orderId=tba.BookingRef                                     
 left join B2BHotel_Commission HCC WITH(NOLOCK) on HB.pkId=HCC.Fk_BookId                                   
            
where HB.RequestForCancelled='yes'    
 )--order by hb.pkId desc      
       
 SELECT                 
   *               
FROM Hotel_cte                
    CROSS JOIN (SELECT Count(*) AS CountOrders FROM Hotel_cte) AS tCountOrders            
 order by pkId desc           
OFFSET @skipRows ROWS                
FETCH NEXT @takeRows ROWS ONLY;           
END            
            
  