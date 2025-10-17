  
  
  
-- =============================================  
-- Author:  Bhavika kawa  
-- Description: self balance revesal  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_GetSelfBalanceRevesaltest]  
 @FromDate   datetime=null,  
 @ToDate  datetime=null,  
 @Status varchar(10)=null,  
 @Start int=null,  
 @Pagesize int=null,  
 @IsPaging bit,  
 @riyaPNR VARCHAR(20)=null,  
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
 select distinct b.pkId,  
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
 b.InquiryNo,b.FileNo,b.PaymentRefNo,b.OBTCNo,b.RTTRefNo,b.OpsRemark,b.AcctsRemark   
 --added by afifa  
 ,isnull(mu.UserName,'') as 'AddUserSelfBalance'  
  
 from  tblBookMaster b  
 inner join Paymentmaster PM ON PM.order_id=B.orderId  
 inner join B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 inner join mUser u on b.MainAgentId=u.ID  
 left join agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.IssueBy  
 left join mUser u1 ON u1.ID=b.IssueBy  
 inner join mCountry c on b.Country=c.CountryCode  
 --added by afifa  
    left join mUser mu on mu.ID=b.AddUserSelfBalance  
 where b.totalFare>0 and ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))  
    AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date,@ToDate)))  
  AND ((@Status='All') or   
   (@Status='Pending' and isnull(b.AgentInvoiceNumber,'') ='') or   
   (@Status='Completed' and  isnull(b.AgentInvoiceNumber,'') !=''))  
   AND b.IsBooked=1 AND b.returnFlag =0   
   and PM.payment_mode='Self Balance' and b.DisplaySelfBalanceReport=1  
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
 select  distinct ROW_NUMBER() Over (Order by b.pkid) As [Sr.No.],   
 b.IssueDate  as 'TKT issue date' ,  
 R.Icast as 'CUST ID',(u.UserName +' - '+u.FullName) as 'Branch Staff (Booked By)',  
 isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Ticketing Staff (Issued By)',  
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
 b.InquiryNo,b.FileNo,b.PaymentRefNo,b.OBTCNo,b.RTTRefNo,b.OpsRemark,b.AcctsRemark   
 from  tblBookMaster b  
 inner join Paymentmaster PM ON PM.order_id=B.orderId  
 inner join B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 inner join mUser u on b.MainAgentId=u.ID  
 left join agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.IssueBy  
 left join mUser u1 ON u1.ID=b.IssueBy  
 inner join mCountry c on b.Country=c.CountryCode  
  
 where b.totalFare>0 and ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))  
    AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date,@ToDate)))  
  AND ((@Status='All') or   
   (@Status='Pending' and isnull(b.AgentInvoiceNumber,'') ='') or   
   (@Status='Completed' and  isnull(b.AgentInvoiceNumber,'') !=''))  
   AND b.IsBooked=1 AND b.returnFlag=0   
   and PM.payment_mode='Self Balance' and b.DisplaySelfBalanceReport=1  
     
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
    ON OBJECT::[dbo].[Sp_GetSelfBalanceRevesaltest] TO [rt_read]
    AS [dbo];

