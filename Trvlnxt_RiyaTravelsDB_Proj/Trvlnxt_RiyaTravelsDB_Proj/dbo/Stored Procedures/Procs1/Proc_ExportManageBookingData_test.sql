
--Proc_ExportManageBookingData_test 46999,0,'2023-09-07','2023-09-07'           
CREATE Procedure [dbo].[Proc_ExportManageBookingData_test]                              
@AgentId int = 0 ,                             
@MainAgentId int = 0,                          
@FromDate varchar(100)='',                          
@ToDate varchar(100)=''                          
As                              
Begin                              
 
 SET NOCOUNT ON
 
  if @ToDate in ('',NULL)                                                                                
set @ToDate = DATEADD(DAY,1,@FromDate)                                                                                
else set @ToDate = DATEADD(DAY,1,@ToDate)              
              
 ;with  tmp as(            
 Select                     
   HH.CreateDate as TransactionDate,                
   HB.BookingReference As BookingId,                
   case when tbs.OpenBalance is null then tbla.OpenBalance end as OpeningBalance,              
   CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS BookingDebit,                
   CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS RefundCredit,           
   0 as AccountCredit,        
   isnull(HB.AgentCommission,0) as CommCredit,              
   0 as CommDebit,              
   case when tbs.CloseBalance is null then tbla.CloseBalance end as ClosingBalance               
   from Hotel_BookMaster HB                                                                                            
   join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId = 4                                                                        
   join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                                      
   left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                                             
   left join tblSelfBalance tbs on tbs.BookingRef=HB.orderId and  tbs.UserID=HB.MainAgentID                       
   left join tblAgentBalance tbla on tbla.BookingRef=HB.orderId  and  tbla.AgentNo=HB.RiyaAgentID                       
   where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                            
   and HB.BookingPortal in('TNH','TNHAPI')                           
   and HB.RiyaAgentID is not null                                                                                                                               
   --and HH.IsActive=1                         
    and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')        
    and (tbs.TransactionType='Debit' or tbla.TransactionType='Debit')           
 or (tbs.BookingRef='Credit' or tbla.BookingRef='Credit')        
            
 UNION               
               
 Select                     
   HH.CreateDate as TransactionDate,                
   HB.BookingReference As BookingId,                
   case when tbs.OpenBalance is null then tbla.OpenBalance end as OpeningBalance,              
   CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Debit'                
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS BookingDebit,                
   CASE WHEN (case when tbs.TransactionType is null then tbla.TransactionType end) = 'Credit'                
   THEN (case when tbs.TranscationAmount is null then tbla.TranscationAmount end) ELSE 0 END AS RefundCredit,          
   0 as AccountCredit,        
   0 as CommCredit,              
   isnull(HB.AgentCommission,0) as CommDebit,              
   case when tbs.CloseBalance is null then tbla.CloseBalance end as ClosingBalance               
   from Hotel_BookMaster HB                                                                          
   join Hotel_Status_History HH on HB.pkId=HH.FKHotelBookingId and HH.FkStatusId = 7                            
   join Hotel_Status_Master HM on HH.FkStatusId=HM.Id                                                                                                                    
   left join B2BHotel_Commission BC on BC.Fk_BookId=hb.pkId                                                             
   left join tblSelfBalance tbs on (tbs.BookingRef=HB.orderId or tbs.BookingRef=HB.BookingReference) and  tbs.UserID=HB.MainAgentID                       
   left join tblAgentBalance tbla on (tbla.BookingRef=HB.orderId or tbla.BookingRef=HB.BookingReference)  and  tbla.AgentNo=HB.RiyaAgentID                       
   where (HB.RiyaAgentID=@AgentId or (HB.MainAgentID=@MainAgentId and HB.MainAgentID >0))                            
   and HB.BookingPortal in('TNH','TNHAPI')                             
   and HB.RiyaAgentID is not null                                                                                                                               
   --and HH.IsActive=1                         
    and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')            
        
    and (tbs.TransactionType='Credit' or tbla.TransactionType='Credit')         
 or (tbs.BookingRef='Credit' or tbla.BookingRef='Credit')        
      
 UNION      
  Select                     
   tbla.CreatedOn as TransactionDate,                
   '' As BookingId,                
   0 as OpeningBalance,                 
   0 AS BookingDebit,                         
   0 AS RefundCredit,          
   tbla.TranscationAmount as AccountCredit,        
   0 as CommCredit,              
   0 as CommDebit,              
   0 as ClosingBalance               
   from tblAgentBalance tbla                                                                                                                                                          
 Where tbla.BookingRef= 'Credit' and  tbla.AgentNo=@AgentId                                         
    and ((Convert(date,tbla.CreatedOn) >= Convert(date,@FromDate) and Convert(date,tbla.CreatedOn) < @ToDate) or @FromDate='')            
     and tbla.TransactionType='Credit'         
        
  UNION      
  Select                     
   tbs.CreatedOn as TransactionDate,                
   '' As BookingId,                
   0 as OpeningBalance,                 
   0 AS BookingDebit,                         
   0 AS RefundCredit,          
   tbs.TranscationAmount as AccountCredit,        
   0 as CommCredit,              
   0 as CommDebit,              
   0 as ClosingBalance               
   from tblSelfBalance tbs                                                                                                                                                          
 Where tbs.BookingRef= 'Credit' and  (tbs.UserID=@MainAgentId And  tbs.CreatedBy=@AgentId)                                     
    and ((Convert(date,tbs.CreatedOn) >= Convert(date,@FromDate) and Convert(date,tbs.CreatedOn) < @ToDate) or @FromDate='')            
     and tbs.TransactionType='Credit'         
  )            
            
 SELECT             
  cast(t.TransactionDate as date) as TransactionDate,            
  (select top 1 OpeningBalance from tmp t2 where cast(t2.TransactionDate as date) = cast(t.TransactionDate as date) order by TransactionDate asc) as OpeningBalance,             
  sum(t.BookingDebit) as BookingDebit,            
  sum(t.RefundCredit) as RefundCredit,         
  sum(t.AccountCredit) as AccountCredit,        
  sum(t.CommCredit) as CommCredit,            
  sum(t.CommDebit) as CommDebit,            
  (select top 1 ClosingBalance from tmp t2 where cast(t2.TransactionDate as date) = cast(t.TransactionDate as date) order by TransactionDate desc) as ClosingBalance            
 from             
  tmp as t            
 group by cast(t.TransactionDate as date)             
 order by cast(t.TransactionDate as date)  ASC              
                   
End 
