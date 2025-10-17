create PROCEDURE [dbo].[Sp_GetSelfBalanceReportNew] -- '01-Oct-2021','21-Oct-2021',3,'0','100','1',''            
 @FromDate Date=null,                   
 @ToDate Date=null,                  
 @UserId int=null, 
 @UserType varchar(max)=null, 
 @roleId int=null,
 @BookingId varchar(50)=null,
 @Location varchar(max)=null, 
 @Start int=null,                  
 @Pagesize int=null,   

 @IsPaging bit,                  
 @RecordCount INT OUTPUT                  
AS                  
BEGIN                  
set @RecordCount=0                  
                  
IF(@IsPaging=1)                  
BEGIN                  
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL                  
 DROP table  #tempTableA                  
 SELECT * INTO #tempTableA                   
 from                  
 (                    
  select                   
  --isnull(b.inserteddate_old,b.inserteddate) as 'Date & Time',                  
  case                   
         when  c.CountryCode='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 1 hour, 29 minutes and 13 seconds                  
         when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                  
         when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                  
         when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120)))  --- 0 hour, 0 minutes and 0 seconds                  
                          
     end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'      
                    
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID                  
  inner join mUser u1 on b.MainAgentId=u1.ID   
 INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
  left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID        
              
  where pm.payment_mode='Self Balance'                   
  AND ((@FROMDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))                  
   AND ((@ToDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))                  
  AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId)) AND B.totalFare>0   and (@roleId='' or u1.RoleID=@roleId)                 
          AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))  
		   AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
		    AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
  UNION ALL                
                  
  select                   
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)) as 'Date & Time',                  
   case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                     
    end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'                  
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID                  
  inner join mUser u1 on b.MainAgentId=u1.ID                 
    INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID 
    left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID     

  where pm.payment_mode='Self Balance' and b.AgentInvoiceNumber is not null                  
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) >= CONVERT(date,@FROMDate)))                  
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) <= CONVERT(date, @ToDate)))                  
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0 and (@roleId='' or u1.RoleID=@roleId)                 
        AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))   
		 AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
		  AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
 UNION  ALL                 
                  
  select                   
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,inserteddate)) as 'Date & Time',                  
   case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                       
      end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'                  
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID              
  inner join mUser u1 on b.MainAgentId=u1.ID                  
      INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID 
	    left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID     

  where pm.payment_mode='Self Balance' and (b.BookingStatus=4 or b.BookingStatus=8)                  
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(date,@FROMDate)))                  
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(date, @ToDate)))                  
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0  and (@roleId='' or u1.RoleID=@roleId)             
            AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))          
                  
                   AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
				    AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
  UNION   ALL                
                  
  select                   
  --sb.CreatedOn as 'Date & Time',                  
    case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),sb.CreatedOn,120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),sb.CreatedOn,120)))  --- 0 hour, 0 minutes and 0 seconds                  
                        
    end   as 'Booking Date-Time',                  
     '' as [Agent Type],'Air' as 'Service type','' as 'Agency Name',                
                  '' as 'CUST ID', c.CountryName as 'Country', '' as [State],'' as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	 '' as 'Issued By(Sub User Id)',
	'' as 'Booking ID','' as Description,'' as 'Lead Pax Name',
	''as 'No.of Pax',
 case when sb.TransactionType='Credit' then sb.Amount else 0 end  as 'Credit',    (case when sb.TransactionType='Debit' then sb.Amount else 0 end) as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges','' as 'Status',
  '' as 'Service date','' as [Deadline date],

'' AS  [Airline/ Hotel  PNR],                  
  '' AS 'CRS PNR',   
  '' as 'Ticket No/ Supplier conformation No',  '' as 'Vendor Id / Supplier Name',
  '' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',    '' as 'Accounts Status' ,             
  '' as 'Accts Remarks',u1.UserName as 'Updated by'                 
                 
                   
  from mSelfBalanceCreditDebit sb      
  left join mCountry c on sb.CountryId=c.ID                  
  inner join mUser u on sb.UserId=u.ID                  
  inner join mUser u1 on sb.CreatedBy=u1.ID                  
   --INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
  where ((@FROMDate = '') or (CONVERT(date,sb.CreatedOn) >= CONVERT(date,@FROMDate)))                  
   AND ((@ToDate = '') or (CONVERT(date,sb.CreatedOn) <= CONVERT(date, @ToDate)))                  
  AND ((@UserId = '') or  (sb.UserId=@UserId)) 
   -- AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))
  ) p                  
   order by p.[Booking Date-Time] desc                  
                  
   SELECT @RecordCount = @@ROWCOUNT                  
                  
  SELECT * FROM #tempTableA                  
  ORDER BY  [Booking Date-Time] desc                  
  OFFSET @Start ROWS                  
  FETCH NEXT @Pagesize ROWS ONLY                  
END             
ELSE                  
BEGIN                  
  select                   
  --isnull(b.inserteddate_old,b.inserteddate) as 'Date & Time',                  
  case                   
         when  c.CountryCode='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 1 hour, 29 minutes and 13 seconds                  
         when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                  
         when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                  
         when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120)))  --- 0 hour, 0 minutes and 0 seconds                  
                          
     end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'      
                    
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID                  
  inner join mUser u1 on b.MainAgentId=u1.ID   
 INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
  left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID        
              
  where pm.payment_mode='Self Balance'                   
  AND ((@FROMDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))                  
   AND ((@ToDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))                  
  AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId)) AND B.totalFare>0   and (@roleId='' or u1.RoleID=@roleId)                 
          AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))  
		   AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
		    AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
  UNION ALL                
                  
  select                   
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)) as 'Date & Time',                  
   case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                     
    end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'                  
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID                  
  inner join mUser u1 on b.MainAgentId=u1.ID                 
    INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID 
    left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID     

  where pm.payment_mode='Self Balance' and b.AgentInvoiceNumber is not null                  
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) >= CONVERT(date,@FROMDate)))                  
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) <= CONVERT(date, @ToDate)))                  
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0 and (@roleId='' or u1.RoleID=@roleId)                 
        AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))   
		 AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
		  AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
 UNION  ALL                 
                  
  select                   
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,inserteddate)) as 'Date & Time',                  
   case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                       
      end  as 'Booking Date-Time',  value as [Agent Type],'Air' as 'Service type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',                
                    R.Icast as 'CUST ID', c.CountryName as 'Country',  R.AddrState as [State],L.LocationName as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By(Sub User Id)',
	b.riyaPNR as 'Booking ID',(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)  as Description,(SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb where pb.fkBookMaster=b.pkId order by paxFName) as 'Lead Pax Name',
	(SELECT count(*) FROM tblPassengerBookDetails PD where PD.fkBookMaster=b.pkId) as 'No.of Pax',
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges',(CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) as 'Status',
  CONVERT(varchar, b.depDate, 101) as 'Service date','' as [Deadline date],

  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  [Airline/ Hotel  PNR],                  
  B.GDSPNR AS 'CRS PNR',   
  (select                   
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                   
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                  
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                  
  GROUP BY t.fkBookMaster) as 'Ticket No/ Supplier conformation No',   b.OfficeID as 'Vendor Id / Supplier Name',
  '' as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',    '' as 'Accounts Status' ,             
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by'                  
                  
  from  tblBookMaster b                   
  inner join Paymentmaster pm ON pm.order_id=b.orderId                  
  inner join mCountry c on b.Country=c.CountryCode                  
  left join mUser u on b.IssueBy=u.ID              
  inner join mUser u1 on b.MainAgentId=u1.ID                  
      INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID 
	    left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID  
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID  
      inner join mCommon on mCommon.ID=al.UserTypeID
	left join mLocation L on L.ID=u1.LocationID     

  where pm.payment_mode='Self Balance' and (b.BookingStatus=4 or b.BookingStatus=8)                  
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(date,@FROMDate)))                  
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(date, @ToDate)))                  
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0  and (@roleId='' or u1.RoleID=@roleId)             
            AND ((@UserType = '') or ( al.UserTypeID IN  ( select Data from sample_split(@UserType,','))))          
                  
                   AND ((@BookingId = '') or (b.riyaPNR = @BookingId))
				    AND ((@Location = '') or (u.LocationID IN ( select Data from sample_split(@Location,',')))) 
                  
  UNION   ALL                
                  
  select                   
  --sb.CreatedOn as 'Date & Time',                  
    case                   
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),sb.CreatedOn,120))) -- 1 hour, 29 minutes and 13 seconds                  
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                  
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),sb.CreatedOn,120)))  --- 0 hour, 0 minutes and 0 seconds                  
                        
    end   as 'Booking Date-Time',                  
     '' as [Agent Type],'Air' as 'Service type','' as 'Agency Name',                
                  '' as 'CUST ID', c.CountryName as 'Country', '' as [State],'' as 'Branch',
      (u.UserName +' - '+u.FullName) as 'Branch Staff(Booked By)', 
	 '' as 'Issued By(Sub User Id)',
	'' as 'Booking ID','' as Description,'' as 'Lead Pax Name',
	''as 'No.of Pax',
 case when sb.TransactionType='Credit' then sb.Amount else 0 end  as 'Credit',    (case when sb.TransactionType='Debit' then sb.Amount else 0 end) as 'Debit',     '' as 'Remaining balance' , c.Currency as 'Currency','Self Balance' as 'Payment Mode' ,'' as 'Transaction Id','' as 'Transcation Charges','' as 'Status',
  '' as 'Service date','' as [Deadline date],

'' AS  [Airline/ Hotel  PNR],                  
  '' AS 'CRS PNR',   
  '' as 'Ticket No/ Supplier conformation No',  '' as 'Vendor Id / Supplier Name',
  '' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',    '' as 'Accounts Status' ,             
  '' as 'Accts Remarks',u1.UserName as 'Updated by'                 
                 
                   
  from mSelfBalanceCreditDebit sb      
  left join mCountry c on sb.CountryId=c.ID                  
  inner join mUser u on sb.UserId=u.ID                  
  inner join mUser u1 on sb.CreatedBy=u1.ID                  
   --INNER JOIN agentLogin al ON cast(al.UserID AS VARCHAR(50))=b.AgentID  
  where ((@FROMDate = '') or (CONVERT(date,sb.CreatedOn) >= CONVERT(date,@FROMDate)))                  
   AND ((@ToDate = '') or (CONVERT(date,sb.CreatedOn) <= CONVERT(date, @ToDate)))                  
  AND ((@UserId = '') or  (sb.UserId=@UserId))                 
                  
  order by [Booking Date-Time]                  
END                  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSelfBalanceReportNew] TO [rt_read]
    AS [dbo];

