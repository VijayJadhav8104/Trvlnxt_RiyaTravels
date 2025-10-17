--Proc_GetCancelationreport 46999,0,'2025-07-16','2025-07-18'                
CREATE procedure Proc_GetCancelationreport               
@AgentId int = 0 ,                        
@MainAgentId int = 0,                    
@FromDate varchar(100)='',                    
@ToDate varchar(100)=''                
As              
Begin              
 if @ToDate in ('',NULL)                                                                            
  set @ToDate = DATEADD(DAY,1,@FromDate)                                                                            
 else               
  set @ToDate = DATEADD(DAY,1,@ToDate)                
               
 Select                 
  ISNULL(HH.CreateDate,'') As TransactionDate,              
  HM.Status as BookingType, HB.CheckInDate as CheckInDate, HB.CheckOutDate as CheckOutDate,              
  HB.BookingReference As BookingId, ISNULL(HB.providerConfirmationNumber,0) as VoucherId,              
  'Hotel' As ServiceType, HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,              
  CASE WHEN (case when tbs.TransactionType is null THEN tbla.TransactionType END) = 'Debit'              
   THEN (CASE WHEN tbs.TranscationAmount is null THEN tbla.TranscationAmount END) ELSE 0 END AS Debit,              
  CASE WHEN (case when tbs.TransactionType is null THEN tbla.TransactionType END) = 'Credit'              
   THEN (CASE WHEN tbs.TranscationAmount is null THEN tbla.TranscationAmount END) ELSE 0 END AS Credit,           
    CASE WHEN tbs.OpenBalance is null THEN tbla.OpenBalance END AS CumulativeBalance,            
  CASE WHEN tbs.CloseBalance is null THEN tbla.CloseBalance END AS Balance,               
             
  --case when tbs.TranscationAmount is null then tbla.TranscationAmount end as TransactionAmount,              
  --case when tbs.OpenBalance is null then tbla.OpenBalance end as OpenBalance,               
  --case when tbs.CloseBalance is null then tbla.CloseBalance end as ClosingBalance,               
  --case when tbs.TransactionType is null then tbla.TransactionType end CreditOrDebit,              
  HB.CurrencyCode as Currency            
  from Hotel_BookMaster HB WITH (NOLOCK)                                                                      
   join Hotel_Status_History HH WITH (NOLOCK) on HB.pkId = HH.FKHotelBookingId            
   join Hotel_Status_Master HM WITH (NOLOCK) on HH.FkStatusId = HM.Id                                                                                                                                                  
   --left join Hotel_Pax_master HPM WITH (NOLOCK) on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                        
   --left join Hotel_BookingGSTDetails HBG WITH (NOLOCK) on HBG.PKID = HB.pkId                  
   left join tblSelfBalance tbs WITH (NOLOCK) on (tbs.BookingRef = HB.orderId or tbs.BookingRef = HB.BookingReference) and  tbs.UserID = HB.MainAgentID                
   left join tblAgentBalance tbla WITH (NOLOCK) on (tbla.BookingRef = HB.orderId or tbla.BookingRef = HB.BookingReference) and tbla.AgentNo = HB.RiyaAgentID               
      where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                        
   and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                        
   and HB.RiyaAgentID is not null                                                                                                                           
   and HH.IsActive = 1 and HH.FkStatusId = 7              
   and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                    
   and (tbs.TransactionType = 'Credit' or tbla.TransactionType = 'Credit')            
  order by HH.CreateDate ASC                       
End