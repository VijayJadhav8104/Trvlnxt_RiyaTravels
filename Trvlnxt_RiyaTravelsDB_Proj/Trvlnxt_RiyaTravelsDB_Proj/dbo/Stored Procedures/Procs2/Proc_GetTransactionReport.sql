--Proc_GetTransactionReport 46999,0,'2024-04-24','2024-04-25'                          
CREATE procedure Proc_GetTransactionReport                        
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
  --HH.CreateDate As TransactionDate,      
  tbla.CreatedOn As TransactionDate,    
  HM.Status as BookingType,                          
  HB.CheckInDate as CheckInDate,                          
  HB.CheckOutDate as CheckOutDate,                          
  HB.BookingReference As BookingId,                          
  isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
  'Hotel' As ServiceType,                          
  HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                        
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                          
                        
 case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,          
   case when tbs.CloseBalance is null then tbla.CloseBalance end as CloseBalance,         
  --case when tbs.TranscationAmount is null then tbla.TranscationAmount end as TransactionAmount,                          
  --case when tbs.OpenBalance is null then tbla.OpenBalance end as OpenBalance,                           
  --case when tbs.CloseBalance is null then tbla.CloseBalance end as ClosingBalance,                           
  --case when tbs.TransactionType is null then tbla.TransactionType end CreditOrDebit,                          
  HB.CurrencyCode as Currency,           
  '' as TransactionType,          
  '' As Remark            
  from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                
   join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 4                                                                                
   join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                                              
   left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
   left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
   left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and  tbs.UserID = HB.MainAgentID                               
   left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId and  tbla.AgentNo = HB.RiyaAgentID  and tbla.IsDeleted=0                           
  where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
   and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
   and HB.RiyaAgentID is not null                                                                                                                                       
   --and HH.IsActive = 1                                 
   --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')          
   and  ((Convert(date,tbla.CreatedOn) >= Convert(date,@FromDate) and Convert(date,tbla.CreatedOn) < @ToDate) or @FromDate='')        
   and (tbs.TransactionType='Debit' or tbla.TransactionType='Debit')                        
  --order by HB.inserteddate ASC                             
                          
  UNION ------------ Cancelled condition                          
                          
  Select                           
  --HH.CreateDate As TransactionDate,     
  tbla.CreatedOn As TransactionDate,    
  HM.Status as BookingType,                     
  HB.CheckInDate as CheckInDate, HB.CheckOutDate as CheckOutDate,                          
  HB.BookingReference As BookingId, isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
  'Hotel' As ServiceType, HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                                         
  case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,         
   case when tbs.CloseBalance is null then tbla.CloseBalance end as CloseBalance,        
  HB.CurrencyCode as Currency,          
  '' as TransactionType,          
  '' As Remark            
  from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                      
   join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 7                          
   join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                                              
   left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
   left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
   left join tblSelfBalance tbs on (tbs.BookingRef = HB.orderId or tbs.BookingRef = HB.BookingReference) and  tbs.UserID = HB.MainAgentID                               
   left join tblAgentBalance tbla on (tbla.BookingRef = HB.orderId or tbla.BookingRef = HB.BookingReference) and  tbla.AgentNo = HB.RiyaAgentID  and tbla.IsDeleted=0                               
  where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
   and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
   and HB.RiyaAgentID is not null                                                                                                                                       
   --and HH.IsActive = 1                                 
   --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')      
   and  ((Convert(date,tbla.CreatedOn) >= Convert(date,@FromDate) and Convert(date,tbla.CreatedOn) < @ToDate) or @FromDate='')        
   and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')                        
  --order by HB.inserteddate ASC                                   
                          
  UNION                              
  --------- Reject Condition                              
  Select                           
  HH.CreateDate As TransactionDate, HM.Status as BookingType,                          
  HB.CheckInDate as CheckInDate, HB.CheckOutDate as CheckOutDate,                          
  HB.BookingReference As BookingId, isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
  'Hotel' As ServiceType, HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                                            
  case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,          
   case when tbs.CloseBalance is null then tbla.CloseBalance end as CloseBalance,        
  HB.CurrencyCode as Currency,          
  '' as TransactionType,          
  '' As Remark            
  from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                      
   join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 5                          
  join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                  
   left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
   left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
   left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and  tbs.UserID = HB.MainAgentID                               
   left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId and  tbla.AgentNo = HB.RiyaAgentID and tbla.IsDeleted=0                                 
  where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
   and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
   and HB.RiyaAgentID is not null                                                                                                                                       
   --and HH.IsActive = 1                                 
   and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                                
  --order by HB.inserteddate ASC                                   
                          
  --UNION                              
  ----------- Failed Condition                            
                          
  --Select                           
  --HH.CreateDate As TransactionDate, HM.Status as BookingType,                          
  --HB.CheckInDate as CheckInDate, HB.CheckOutDate as CheckOutDate,                          
  --HB.BookingReference As BookingId, isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
  --'Hotel' As ServiceType, HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                          
  --CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
  -- THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
  --CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
  -- THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                          
  --case when tbs.CloseBalance is null then tbla.CloseBalance end as Balance,                           
  --case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,                          
  --HB.CurrencyCode as Currency                          
  --from Hotel_BookMaster HB                                                 
  -- join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 11                          
  -- join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                  
  -- left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
  -- left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
  -- left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and  tbs.UserID = HB.MainAgentID                               
  -- left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId and  tbla.AgentNo = HB.RiyaAgentID                               
  --where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
  -- and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
  -- and HB.RiyaAgentID is not null                                                                                                           
  -- --and HH.IsActive = 1                                 
  -- and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                                
  ----order by HB.inserteddate ASC                                   
                          
  UNION              
   Select                           
  CreatedOn As TransactionDate,             
  '' as BookingType,                          
 '' as CheckInDate,             
 '' as CheckOutDate,                          
 '' As BookingId,             
 '' as VoucherId,                    
  'Hotel' As ServiceType,             
  '' as PaxName,            
 CASE WHEN TransactionType='Debit' then TranscationAmount ELSE 0 END as Debit,            
 --ranscationAmount  AS Debit,               
 CASE WHEN TransactionType='Credit' then TranscationAmount ELSE 0 END as Credit,            
 --TranscationAmount  AS Credit,                                      
 OpenBalance  as CumulativeBalance,        
 CloseBalance as CloseBalance,        
  '' as Currency,           
  'TOP-UP' as TransactionType,          
  ISNULL(Remark,'') as Remark            
  from tblAgentBalance  WITH (NOLOCK)                                                                                                                                                                      
  where             
 AgentNo = @AgentId                                                                                                                                                             
   and ((Convert(date,CreatedOn) >= Convert(date,@FromDate) and Convert(date,CreatedOn) < @ToDate) or @FromDate='')                                
   and  (TransactionType='Credit' or TransactionType='Debit')            
   and PaymentMode='Check'           
   and Reference='Temp Balance'          
  UNION      
  --------------Pending Condition                              
  Select                           
  HH.CreateDate As TransactionDate,             
  HM.Status as BookingType,                          
  HB.CheckInDate as CheckInDate,             
  HB.CheckOutDate as CheckOutDate,                          
  HB.BookingReference As BookingId,             
  isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
  'Hotel' As ServiceType,             
  HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
  CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                          
                         
  case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,          
   case when tbs.CloseBalance is null then tbla.CloseBalance end as CloseBalance,        
  HB.CurrencyCode as Currency,          
  '' as TransactionType,          
  '' As Remark            
  from Hotel_BookMaster HB    WITH (NOLOCK)                                                                                                    
   join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 10                          
   join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                      
   left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
   left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
   left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and  tbs.UserID = HB.MainAgentID                               
   left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId and  tbla.AgentNo = HB.RiyaAgentID  and tbla.IsDeleted=0                                
  where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
   and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
and HB.RiyaAgentID is not null                                                                                                                                       
   --and HH.IsActive = 1                                 
   and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                                
  --order by HH.CreateDate ASC         
  order by tbla.CreatedOn ASC                                       
              
       
            
 ------- Not Found Condition                              
                          
 -- Select                           
 -- HH.CreateDate As TransactionDate, HM.Status as BookingType,                          
 -- HB.CheckInDate as CheckInDate, HB.CheckOutDate as CheckOutDate,                          
 -- HB.BookingReference As BookingId, isnull(HB.providerConfirmationNumber,0) as VoucherId,                          
 -- 'Hotel' As ServiceType, HB.LeaderFirstName+' '+HB.LeaderLastName as PaxName,                          
-- CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                          
 --  THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Debit,                          
 -- CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                          
 --  THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS Credit,                          
 -- case when tbs.CloseBalance is null then tbla.CloseBalance end as Balance,                           
 -- case when tbs.OpenBalance is null then tbla.OpenBalance end as CumulativeBalance,                          
 -- HB.CurrencyCode as Currency                          
 -- from Hotel_BookMaster HB                                                                                                    
 --  join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 13                          
 --  join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                                              
 --  left join Hotel_Pax_master HPM on HPM.book_fk_id = HB.pkId and HPM.IsLeadPax = 1                                    
 --  left join Hotel_BookingGSTDetails HBG on HBG.PKID = HB.pkId                              
 --  left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and  tbs.UserID = HB.MainAgentID                           
 --  left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId and  tbla.AgentNo = HB.RiyaAgentID                               
 -- where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                    
 --  and (HB.BookingPortal = 'TNH' or HB.BookingPortal='TNHAPI')                                    
 --  and HB.RiyaAgentID is not null                                               
 --  --and HH.IsActive = 1                                 
 --  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')                                
 -- --order by HB.inserteddate ASC                           
 --order by HH.CreateDate ASC                           
End