
--DECLARE @RecordCount int
--exec [Sp_GetSelfBalanceRevesal] '2023-01-17','2023-01-17','Pending',0,100,1,'','445',0,@RecordCount OUTPUT
-- =============================================        
-- Author:  Bhavika kawa        
-- Description: self balance revesal        
-- =============================================        
--declare @RecordCount int 
--exec [dbo].[Sp_GetSelfBalanceRevesal] '2022-08-01','2022-08-31','ALL',0,100,1,'',375,0,@RecordCount
CREATE PROCEDURE [dbo].[Sp_GetSelfBalanceRevesal]    
 @FromDate   datetime=null,    
 @ToDate  datetime=null,    
 @Status varchar(10)=null,    
 @Start int=null,    
 @Pagesize int=null,    
 @IsPaging bit,    
 @riyaPNR VARCHAR(20)=null, 
 @UserId Varchar(500)=null, -- Jitendra Nakum 21/09/2022 add User Filter as per discussed date 20/09/2022
 @OBTC Int,-- Jitendra Nakum 21/09/2022 add OBTC Filter when check box check then all record fetch other wise only OBTC No available that record fetch as per discussed date 20/09/2022
 @RecordCount INT OUTPUT    
AS    
BEGIN    
set @RecordCount=0    
if(@riyaPNR='')    
BEGIN    
if(@IsPaging=1)    
BEGIN    
 IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL    
 DROP table  #tempTableA    
 SELECT * INTO #tempTableA     
 from    
 (      
 select b.pkId,    
 '' as type,
 b.IssueDate  as 'Date/Time' ,    
 R.Icast as 'CUST ID',(u.UserName +' - '+u.FullName) as 'Booked By',     
 isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By',    
 b.riyaPNR as 'Booking ID',CONVERT(varchar, b.depDate, 101) as 'Departure date',b.airCode as 'Airline Code',    
 (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',    
 (select     
STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s     
WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber    
from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId    
GROUP BY t.fkBookMaster) as 'Ticket No',     
(SELECT     
STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector    
FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Travel Sector',    
     
 (select sum(b1.basicFare) from tblBookMaster b1 where b1.orderId=b.orderId group by orderId) as  'Base Amt',    
 (select sum(b1.totalTax) from tblBookMaster b1 where b1.orderId=b.orderId group by orderId) as  'Tax Amt',    
 PM.amount as 'Total Air Cost',c.Currency as 'Currency',    
 (SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',    
 (SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax','Self Balance' as 'Payment Mode' ,    
 (CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) AS 'Status',    
 b.AgentInvoiceNumber as 'Agent Invoice Number',    
 b.InquiryNo,b.FileNo,b.PaymentRefNo,
 CASE WHEN ISNULL(b.OBTCNo,'')!='' THEN b.OBTCNo ELSE MAD.OBTCno END AS OBTCNo,
 b.RTTRefNo,b.OpsRemark,b.AcctsRemark     
 --added by afifa    
 ,isnull(mu.UserName,'')  
 +'-'+isnull(mu.FullName,'') as 'AddUserSelfBalance'    
    
 from  tblBookMaster b    
 inner join Paymentmaster PM ON PM.order_id=B.orderId    
 inner join B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID    
 inner join mUser u on b.MainAgentId=u.ID    
 left join agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.IssueBy    
 left join mUser u1 ON u1.ID=b.IssueBy    
 inner join mCountry c on b.Country=c.CountryCode    
 --added by afifa    
 left join mUser mu on mu.ID=b.AddUserSelfBalance    
 --Jitendra Nakum 17.01.2023 If OBTC no is null in tblbookmaster then fetch OBTC No from mAttrributesDetails table
 left join mAttrributesDetails MAD on MAD.OrderID=b.orderId
 where b.totalFare>0 and ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))    
    AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date,@ToDate)))    
  AND ((@Status='All') or     
   (@Status='Pending' and isnull(b.AgentInvoiceNumber,'') ='') or     
   (@Status='Completed' and  isnull(b.AgentInvoiceNumber,'') !=''))    
   AND b.IsBooked=1 AND b.returnFlag =0     
   and PM.payment_mode='Self Balance' and b.DisplaySelfBalanceReport=1    
   AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId))
   --AND (@IsOBTC =1 OR (b.OBTCNo is not null and b.OBTCNo != ''))
   AND (@OBTC = 0 
			OR
			(@OBTC=1 and b.OBTCNo is not null AND b.OBTCNo != '')
			OR
			(@OBTC=2 and (b.OBTCNo is null OR b.OBTCNo = ''))
		)
   ) p    
   order by p.[Date/Time] desc    
    
 SELECT @RecordCount = @@ROWCOUNT    
    


 SELECT * FROM #tempTableA    
 ORDER BY [Date/Time] desc    
 OFFSET @Start ROWS    
 FETCH NEXT @Pagesize ROWS ONLY    
END    
ELSE    
BEGIN    
 select ROW_NUMBER() Over (Order by b.pkid) As [Sr.No.],   
 '' as type,
 b.IssueDate  as 'TKT issue date' ,    
 R.Icast as 'CUST ID',(u.UserName +' - '+u.FullName) as 'Branch Staff (Booked By)',    
 isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Ticketing Staff (Issued By)',
 ----dev--
 isnull(mu.UserName,'')  
 +'-'+isnull(mu.FullName,'') as 'New User(SB)',
 ------devendr---
 b.riyaPNR as 'Booking ID',CONVERT(varchar, b.depDate, 101) as 'Departure date',b.airCode as 'Airline Code',    
 (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',    
 (select     
STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s     
WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber    
from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId    
GROUP BY t.fkBookMaster) as 'Ticket No',     
(SELECT     
STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector    
FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Travel Sector',    
 (select sum(b1.basicFare) from tblBookMaster b1 where b1.orderId=b.orderId group by orderId) as  'Base Amt',    
 (select sum(b1.totalTax) from tblBookMaster b1 where b1.orderId=b.orderId group by orderId) as  'Tax Amt',    
 PM.amount as 'Total Air Cost',c.Currency as 'Currency',    
 (SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',    
 (SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax','Self Balance' as 'Payment Mode' ,    
 (CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) AS 'Status',    
 b.AgentInvoiceNumber as 'Agent Invoice Number',    
 b.InquiryNo,b.FileNo,b.PaymentRefNo,
 CASE WHEN ISNULL(b.OBTCNo,'')!='' THEN b.OBTCNo ELSE MAD.OBTCno END AS OBTCNo,
 b.RTTRefNo,b.OpsRemark,b.AcctsRemark     
 from  tblBookMaster b    
 inner join Paymentmaster PM ON PM.order_id=B.orderId    
 inner join B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID    
 inner join mUser u on b.MainAgentId=u.ID    
 left join agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.IssueBy    
 left join mUser u1 ON u1.ID=b.IssueBy    
 inner join mCountry c on b.Country=c.CountryCode 
 ---dev--
   left join mUser mu on mu.ID=b.AddUserSelfBalance
 --Jitendra Nakum 17.01.2023 If OBTC no is null in tblbookmaster then fetch OBTC No from mAttrributesDetails table
 left join mAttrributesDetails MAD on MAD.OrderID=b.orderId
   ---dev
 where b.totalFare>0 and ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))    
    AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date,@ToDate)))    
  AND ((@Status='All') or     
   (@Status='Pending' and isnull(b.AgentInvoiceNumber,'') ='') or     
   (@Status='Completed' and  isnull(b.AgentInvoiceNumber,'') !=''))    
   AND b.IsBooked=1 AND b.returnFlag=0     
   and PM.payment_mode='Self Balance' and b.DisplaySelfBalanceReport=1    
   AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId))
	--AND (@IsOBTC =1 OR (b.OBTCNo is not null and b.OBTCNo != ''))
	AND (@OBTC = 0 
			OR
			(@OBTC=1 and b.OBTCNo is not null AND b.OBTCNo != '')
			OR
			(@OBTC=2 and (b.OBTCNo is null OR b.OBTCNo = ''))
		)
   order by [TKT issue date] desc    
END    
END    
ELSE if(@riyaPNR!='')    
BEGIN     
 -- to get payment amount    
 select p.amount    
  from Paymentmaster p    
inner join tblBookMaster b on b.orderid=p.order_id    
where b.riyaPNR=@riyaPNR    
END    
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSelfBalanceRevesal] TO [rt_read]
    AS [dbo];

