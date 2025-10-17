        
-- =============================================          
-- Author:  AKASH SINGH          
-- Create date:30/07/21          
-- Description: <Description,,>          
--  Sp_GetSelfBalanceReportHotel '2022-07-01','2022-07-12',3        
--  Sp_GetSBReportHotel '2022-12-01','2023-01-04',375         
      
-- =============================================          
CREATE PROCEDURE [dbo].[Sp_GetSBReportHotel]          
 @FromDate Date=null,           
 @ToDate Date=null,          
 @UserIds varchar(max)=null,      
 @Branch varchar(max)=null --Jitendra Nakum add branch/Location filter as per today mail 20/09/2022      
AS          
BEGIN          
(        
select           
 SB.UserID,        
 --HB.inserteddate 'Date&Time'          
 CONVERT(varchar(20),hb.inserteddate,120) 'Date&Time'          
,al.Country          
,TranscationAmount  as 'Debit',           
'0.00'  as 'Credit',          
 MU.FullName          
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
Hotel_BookMaster HB   WITH (NOLOCK)        
--left join Paymentmaster PM on HB.orderId=PM.order_id           
left join tblSelfBalance SB  WITH (NOLOCK) on HB.orderId=SB.BookingRef         
join AgentLogin AL  WITH (NOLOCK) on HB.RiyaAgentID=AL.UserID            
join mUser MU  WITH (NOLOCK) on HB.MainAgentID=Mu.ID             
where           
B2BPaymentMode=4 -- and HB.SB_ReversalStatus=1          
and cast(HB.inserteddate as date) between @FromDate and @ToDate           
--and  HB.MainAgentID=@USerId          
and HB.MainAgentID IN (select Data from sample_split(@UserIds,','))      
and TransactionType='Debit'       
and((@Branch ='') or (mu.LocationID IN (select Data from sample_split(@Branch,','))) )      
        
Union        
        
--select         
--UserID        
--,CONVERT(varchar(20),CreatedOn,120) 'Date&Time'        
--,'' Country          
--,'0.00'  as 'Debit'          
-- ,TranscationAmount as 'Credit'        
--, '' as UserName          
--,'' HotelName          
--,'' as  'Booking Id'          
--,'' as 'Hotel Pnr'          
--,'' as FileNo          
--,'' as 'OBTC No'          
--,'' as InquiryNo           
--,'' as OpsRemark          
--,'' as AcctsRemark          
--,'' as  'Updated By'          
--,'' as 'Updated Remark'           
-- from         
--tblSelfBalance  tsb      
--where         
--cast(CreatedOn as date) between @FromDate and @ToDate and     
----and UserID=@USerId        
--UserID IN (select Data from sample_split(@UserIds,','))  
-- and TransactionType='Credit'  
select         
UserID   
,CONVERT(varchar(20),tsb.CreatedOn,120) 'Date&Time'        
,'' Country          
,'0.00'  as 'Debit'          
 ,TranscationAmount as 'Credit'        
, m.FullName as UserName          
,HB.HotelName HotelName          
,HB.book_Id as  'Booking Id'          
,hb.riyaPNR as 'Hotel Pnr'          
,HB.FileNo as FileNo          
,HB.OBTCNo as 'OBTC No'          
,HB.InquiryNo as InquiryNo           
,HB.OpsRemark as OpsRemark          
,HB.AcctsRemark as AcctsRemark          
,M.FullName as  'Updated By'          
,tsb.Remark as 'Updated Remark'           
 from         
tblSelfBalance  tsb  WITH (NOLOCK)  
join Hotel_BookMaster HB  WITH (NOLOCK)  on tsb.BookingRef=HB.orderId or BookingRef is null  
left join mUser M  WITH (NOLOCK) on m.ID=tsb.UserID   
where         
cast(tsb.CreatedOn as date) between @FromDate and @ToDate and     
--and UserID=@USerId        
UserID IN (select Data from sample_split(@UserIds,','))  
and  TransactionType='Credit'  
) order by [Date&Time]         
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSBReportHotel] TO [rt_read]
    AS [dbo];

