CREATE procedure TodayVoucharBookingDataNew      
As        
BEGIN        
  Select isnull(HM.BookingReference,'') as BookingReference,isnull(HM.pkId,0) as PKID,        
 isnull(HM.DisplayDiscountRate,0) as DisplayDiscountRate,        
 isnull(CASE when sb.TranscationAmount IS NOT NULL THEN sb.TranscationAmount ELSE Ab.TranscationAmount end ,0) as TranscationAmount,        
 isnull(CASE when sb.OpenBalance IS NOT NULL THEN sb.OpenBalance ELSE Ab.OpenBalance end,0) as OpenBalance,        
 isnull(CASE when sb.CloseBalance IS NOT NULL THEN sb.CloseBalance ELSE Ab.CloseBalance end,0) as CloseBalance,        
 isnull(CASE when sb.TransactionType IS NOT NULL THEN sb.TransactionType ELSE Ab.TransactionType end,'') as TransactionType,isnull(HM.CurrentStatus,'') as  CurrentStatus,        
 --(case when hm.B2BPaymentMode = 4 then 'SelfBalance' Else 'CreditLimit' END) As PaymentMode,   
 hm.B2BPaymentMode As PaymentMode,  
 isnull(HM.PGStatus,'') as PGStatus,    
 isnull(MPC.ModeOfPayment,'') as ModeOfPayment,    
 isnull(MPC.ConvenienFeeInPercent,0) as MPCConvenienFeeInPercent,    
 isnull(MPC.TotalCommission,0) as TotalCommission,    
 isnull(MPC.AmountBeforeCommission,0) as AmountBeforeCommission,    
 isnull(MPC.AmountWithCommission,0) as AmountWithCommission    
 from Hotel_BookMaster HM              
 left Join tblSelfBalance sb on HM.orderId=Sb.BookingRef        
 left Join tblAgentBalance Ab on HM.orderId=Ab.BookingRef        
 inner JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HM.pkId and hsh.IsActive=1        
 inner JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id    
  left Join B2BMakepaymentCommission MPC on HM.pkId=MPC.FkBookId    
 where                                                      
 HSM.Status in('Vouchered','Cancelled')      
 AND cast(hsh.CreateDate as date)= Cast(getdate() as date)        
 AND hsh.FkStatusId in(4,7)      
 and hm.B2BPaymentMode in(2,4,3)      
 and (hm.BookingPortal='TNH' or hm.BookingPortal='TNHAPI')     
         
END        
        
--select B2BPaymentMode, DisplayDiscountRate, * from Hotel_BookMaster where BookingReference='RT2458056'        
--select * from Hotel_Status_History where FKHotelBookingId=3840        
--select * from Hotel_Status_Master        
--select * from tblSelfBalance where BookingRef='RT20220801140135146'        
--select * from tblSelfBalance order by PKID desc        
--select * from Hotel_Status_Master        
--select  * from Hotel_Status_History order by id desc 