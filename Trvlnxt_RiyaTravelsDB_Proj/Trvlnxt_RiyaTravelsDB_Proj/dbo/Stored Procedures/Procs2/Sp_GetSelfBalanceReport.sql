                
-- =============================================                
-- Author:  Bhavika kawa                
-- Description: to get self balance Credit/Debit report                
-- =============================================                
CREATE PROCEDURE [dbo].[Sp_GetSelfBalanceReport] -- '01-Oct-2021','21-Oct-2021',3,'0','100','1',''          
 @FromDate Date=null,                 
 @ToDate Date=null,                
 @UserId int=null,                
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
                        
     end  as 'Date & Time',                
                  
  c.CountryName as 'Country',                
  '0.00'  as 'Credit',  pm.mer_amount as 'Debit',                
  u1.UserName as 'User id',        
  case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 then (SELECT sb.UserName +'-' +sb.FullName  FROM  mUser sb WHERE CAST(sb.ID as varchar(50))=b.AddUserSelfBalance) else '' end AS 'New User SB' ,        
  b.airName as 'Airline Name',B.riyaPNR as 'Booking id',                
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',                
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
  b.OfficeID as 'Vendor id','' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',                
  '' as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                  
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID                
  inner join mUser u1 on b.MainAgentId=u1.ID          
          
            
  where pm.payment_mode='Self Balance'                 
  AND ((@FROMDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))                
   AND ((@ToDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))                
  AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId)) AND B.totalFare>0                
            
                
  UNION ALL              
                
  select                 
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)) as 'Date & Time',                
   case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                   
    end   as 'Date & Time',                
                   
  c.CountryName as 'Country',                
  pm.mer_amount  as 'Credit',  '0.00'  as 'Debit',                
  u1.UserName as 'User id',  
  case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 then  (SELECT sb.UserName +'-' +sb.FullName as 'New User SB'  FROM  mUser sb WHERE b.AddUserSelfBalance=CAST(sb.ID as varchar(50))) else '' end  AS  'New User SelfBalance',        
    
  b.airName as 'Airline Name',B.riyaPNR as 'Booking id',  
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',                
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
  b.OfficeID as 'Vendor id',b.FileNo as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',                
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID                
  inner join mUser u1 on b.MainAgentId=u1.ID               
                  
  where pm.payment_mode='Self Balance' and b.AgentInvoiceNumber is not null                
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) >= CONVERT(date,@FROMDate)))                
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old)) <= CONVERT(date, @ToDate)))                
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0                
                  
                
 UNION  ALL               
                
  select                 
  --isnull(b.CancelledDate,isnull(b.inserteddate_old,inserteddate)) as 'Date & Time',                
   case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                     
    end   as 'Date & Time',                
              
  c.CountryName as 'Country',              
  pm.mer_amount  as 'Credit',  '0.00'  as 'Debit',                
  u1.UserName as 'User id',  
    case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 then  (SELECT sb.UserName +'-' +sb.FullName as 'New User SB'  FROM  mUser sb WHERE b.AddUserSelfBalance =CAST(sb.ID as varchar(50))) else '' end AS  'New User SelfBalance',       
 
    b.airName as 'Airline Name',B.riyaPNR as 'Booking id',               
        
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',            
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
  b.OfficeID as 'Vendor id',b.FileNo as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',                
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID            
  inner join mUser u1 on b.MainAgentId=u1.ID                
                
  where pm.payment_mode='Self Balance' and (b.BookingStatus=4 or b.BookingStatus=8)                
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(date,@FROMDate)))                
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(date, @ToDate)))                
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0                
                  
                
                
                
  UNION   ALL              
                
  select                 
  --sb.CreatedOn as 'Date & Time',                
    case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),sb.CreatedOn,120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),sb.CreatedOn,120)))  --- 0 hour, 0 minutes and 0 seconds                
                      
    end   as 'Date & Time',                
                  
               
  c.CountryName as 'Country',          
          
  (case when sb.TransactionType='Credit' then sb.Amount else 0 end) as 'Credit',                
  (case when sb.TransactionType='Debit' then sb.Amount else 0 end) as 'Debit',                
  u.UserName as 'User id',  
  '' as 'New User SelfBalance',  
  '' as 'Airline Name','' as 'Booking id',                
  '' AS  'Airlines PNR',                
  '' AS 'CRS PNR',                
  '' as 'Ticket No',                
  '' as 'Vendor id','' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',                
  '' as 'Accts Remarks' ,u1.UserName as 'Updated by',sb.Remark as 'Updated Remarks'                
  from mSelfBalanceCreditDebit sb    
  left join mCountry c on sb.CountryId=c.ID                
  inner join mUser u on sb.UserId=u.ID                
  inner join mUser u1 on sb.CreatedBy=u1.ID                
             
  where ((@FROMDate = '') or (CONVERT(date,sb.CreatedOn) >= CONVERT(date,@FROMDate)))                
   AND ((@ToDate = '') or (CONVERT(date,sb.CreatedOn) <= CONVERT(date, @ToDate)))                
  AND ((@UserId = '') or  (sb.UserId=@UserId))                 
  ) p                
   order by p.[Date & Time] desc                
                
   SELECT @RecordCount = @@ROWCOUNT                
                
  SELECT * FROM #tempTableA                
  ORDER BY  [Date & Time] desc                
  OFFSET @Start ROWS                
  FETCH NEXT @Pagesize ROWS ONLY                
END           
ELSE                
BEGIN                
  select                 
 -- isnull(b.inserteddate_old,b.inserteddate) as 'Date & Time',                
                  
  case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.inserteddate_old,b.inserteddate),120)))  --- 0 hour, 0 minutes and 0 seconds                
                      
    end   as 'Date & Time',                
               
  c.CountryName as 'Country',                
  '0.00'  as 'Credit', pm.mer_amount  as 'Debit',                
  u1.UserName as 'User id',  
    case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 then  (SELECT sb.UserName +'-' +sb.FullName as 'New User SB'  FROM  mUser sb WHERE b.AddUserSelfBalance =CAST(sb.ID as varchar(50))) else '' end as 'New User SelfBalance',        
  b.airName as 'Airline Name',B.riyaPNR as 'Booking id',              
        
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',                
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
  b.OfficeID as 'Vendor id','' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',                
  '' as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                  
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID                
  inner join mUser u1 on b.MainAgentId=u1.ID                
               
  where pm.payment_mode='Self Balance'                 
  AND ((@FROMDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))                
   AND ((@ToDate = '') or (CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))                
  AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0                
                 
                
  UNION  ALL              
                
  select                 
  --isnull(b.ModifiedOn,b.inserteddate_old) as 'Date & Time',                
  case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.ModifiedOn,b.inserteddate_old),120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,b.inserteddate_old),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,b.inserteddate_old),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.ModifiedOn,b.inserteddate_old),120)))  --- 0 hour, 0 minutes and 0 seconds                
                      
    end   as 'Date & Time',                
        
  c.CountryName as 'Country',                
   pm.mer_amount  as 'Credit', '0.00'  as 'Debit',                
  u1.UserName as 'User id',  
  case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0         
 then  (SELECT sb.UserName +'-' +sb.FullName as 'New User SB'  FROM  mUser sb WHERE b.AddUserSelfBalance =CAST(sb.ID as varchar(50))) else '' end as 'New User SelfBalance' ,        
        
  b.airName as 'Airline Name',B.riyaPNR as 'Booking id',         
      
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',                
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
  b.OfficeID as 'Vendor id',b.FileNo as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',                
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID                
  inner join mUser u1 on b.MainAgentId=u1.ID                
                 
  where pm.payment_mode='Self Balance' and b.AgentInvoiceNumber is not null                
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old) ) >= CONVERT(date,@FROMDate)))                
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.ModifiedOn,b.inserteddate_old) ) <= CONVERT(date, @ToDate)))                
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (CAST(b.AddUserSelfBalance AS int)=@UserId)) AND B.totalFare>0                
             
  UNION  ALL              
                
                
                
  select                 
  --isnull(b.ModifiedOn,b.inserteddate_old) as 'Date & Time',                
   case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds                     
    end   as 'Date & Time',                
    
           
  c.CountryName as 'Country',                
  pm.mer_amount  as 'Credit',  '0.00'  as 'Debit',                
  u1.UserName as 'User id',  
  case when  b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 then  (SELECT sb.UserName +'-' +sb.FullName as 'New User SB'  FROM  mUser sb WHERE CAST(b.AddUserSelfBalance AS int)=sb.ID) else '' end as 'New User SelfBalance' ,        
  b.airName as 'Airline Name',B.riyaPNR as 'Booking id',                
  (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',             
  B.GDSPNR AS 'CRS PNR',                
  (select                 
  STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s                 
  WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber                
  from tblPassengerBookDetails t where TicketNumber is not null and fkBookMaster=b.pkId                
  GROUP BY t.fkBookMaster) as 'Ticket No',                 
 b.OfficeID as 'Vendor id',b.FileNo as 'FILE NO',b.OBTCNo as 'OBT NO',b.InquiryNo as 'Inquiry No',b.OpsRemark as 'Opss remarks',                
  b.AcctsRemark as 'Accts Remarks',u.UserName as 'Updated by','' as 'Updated Remarks'                
                
  from  tblBookMaster b                 
  inner join Paymentmaster pm ON pm.order_id=b.orderId                
  inner join mCountry c on b.Country=c.CountryCode                
  left join mUser u on b.IssueBy=u.ID                
  inner join mUser u1 on b.MainAgentId=u1.ID                
            
  where pm.payment_mode='Self Balance' and (b.BookingStatus=4 or b.BookingStatus=8)                
    and ((@FROMDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(date,@FROMDate)))                
     AND ((@ToDate = '') or (CONVERT(date,isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(date, @ToDate)))                
    AND ((@UserId = '') or  (b.MainAgentId=@UserId) or   (CAST(b.AddUserSelfBalance AS int)=@UserId))  AND B.totalFare>0                
                
    union  ALL              
                
  select                
  -- sb.CreatedOn as 'Date & Time',                
   case                 
      when  c.CountryCode ='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),sb.CreatedOn,120))) -- 1 hour, 29 minutes and 13 seconds                
      when  c.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds                
      when  c.CountryCode='IN' then (DATEADD(SECOND, 0,CONVERT(varchar(20),sb.CreatedOn,120)))  --- 0 hour, 0 minutes and 0 seconds                
                      
    end   as 'Date & Time',                
                   
             
   c.CountryName as 'Country',                
  (case when sb.TransactionType='Credit' then sb.Amount else 0 end) as 'Credit',                
  (case when sb.TransactionType='Debit' then sb.Amount else 0 end) as 'Debit',                
  u.UserName as 'User id',  
  '' as 'New User SelfBalance',  
  '' as 'Airline Name','' as 'Booking id',                
  '' AS  'Airlines PNR',                
  '' AS 'CRS PNR',                
  '' as 'Ticket No',                
  '' as 'Vendor id','' as 'FILE NO','' as 'OBT NO','' as 'Inquiry No','' as 'Opss remarks',                
  '' as 'Accts Remarks' ,u1.UserName as 'Updated by',sb.Remark as 'Updated Remarks'                
  from mSelfBalanceCreditDebit sb                 
  left join mCountry c on sb.CountryId=c.ID                
  inner join mUser u on sb.UserId=u.ID                
  inner join mUser u1 on sb.CreatedBy=u1.ID                
            
  where ((@FROMDate = '') or (CONVERT(date,sb.CreatedOn) >= CONVERT(date,@FROMDate)))                
   AND ((@ToDate = '') or (CONVERT(date,sb.CreatedOn) <= CONVERT(date, @ToDate)))                
  AND ((@UserId = '') or  (sb.UserId=@UserId))                 
                
  order by [Date & Time]                
END                
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetSelfBalanceReport] TO [rt_read]
    AS [dbo];

