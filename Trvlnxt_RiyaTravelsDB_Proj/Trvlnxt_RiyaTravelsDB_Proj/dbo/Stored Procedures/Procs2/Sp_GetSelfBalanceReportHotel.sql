  
-- =============================================  
-- Author:  AKASH SINGH  
-- Create date:30/07/21  
-- Description: <Description,,>  
--   
-- =============================================  
CREATE PROCEDURE Sp_GetSelfBalanceReportHotel  
 @FromDate Date=null,   
 @ToDate Date=null,  
 @UserId int=null  
AS  
BEGIN  
  
  
select   
 --HB.inserteddate 'Date&Time'  
 CONVERT(varchar(20),hb.inserteddate,120) 'Date&Time'  
,al.Country  
,pm.amount  as 'Credit',   
'0.00'  as 'Debit',  
 MU.UserName  
,HB.HotelName  
,HB.BookingReference 'Booking Id'  
,HB.riyaPNR 'Hotel Pnr'  
,HB.FileNo  
,HB.OBTCNo 'OBTC No'  
,HB.InquiryNo   
,HB.OpsRemark  
,HB.AcctsRemark  
,MU.UserName 'Updated By'  
,'' as 'Updated Remark'   
from   
Hotel_BookMaster HB  WITH (NOLOCK) 
left join Paymentmaster PM  WITH (NOLOCK) on HB.orderId=PM.order_id   
join AgentLogin AL  WITH (NOLOCK) on HB.RiyaAgentID=AL.UserID    
join mUser MU  WITH (NOLOCK) on HB.MainAgentID=Mu.ID     
where   
B2BPaymentMode=4 and HB.SB_ReversalStatus=1  
and cast(HB.inserteddate as date) between @FromDate and @ToDate   
and  HB.MainAgentID=@USerId  
  
union   
  
select   
 --HB.inserteddate 'Date&Time'  
 CONVERT(varchar(20),hb.inserteddate,120) 'Date&Time'  
,al.Country  
,'0.00'  as 'Credit',   
 pm.amount  as 'Debit',  
 MU.UserName  
,HB.HotelName  
,HB.BookingReference 'Booking Id'  
,HB.riyaPNR 'Hotel Pnr'  
,HB.FileNo  
,HB.OBTCNo 'OBTC No'  
,HB.InquiryNo   
,HB.OpsRemark  
,HB.AcctsRemark  
,MU.UserName 'Updated By'  
,'' as 'Updated Remark'   
from   
Hotel_BookMaster HB  WITH (NOLOCK)  
left join Paymentmaster PM  WITH (NOLOCK) on HB.orderId=PM.order_id   
join AgentLogin AL  WITH (NOLOCK) on HB.RiyaAgentID=AL.UserID    
join mUser MU  WITH (NOLOCK) on HB.MainAgentID=Mu.ID     
where   
B2BPaymentMode=4  and HB.SB_ReversalStatus=0  
and cast(HB.inserteddate as date) between @FromDate and @ToDate   
and  HB.MainAgentID=@USerId  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSelfBalanceReportHotel] TO [rt_read]
    AS [dbo];

