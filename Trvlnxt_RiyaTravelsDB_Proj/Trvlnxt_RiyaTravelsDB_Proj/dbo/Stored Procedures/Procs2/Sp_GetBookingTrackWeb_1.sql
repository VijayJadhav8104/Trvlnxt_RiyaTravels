CREATE PROCEDURE [dbo].[Sp_GetBookingTrackWeb_1]    
 @FromDate varchar(50)=null,     
 @ToDate varchar(50)=null,     
 @PaymentType varchar(50)=null,    
 @UserType varchar(max)=null,     
 @Country varchar(max)=null,    
 @AgentId int=null,    
 @SubUserId int=null,    
 @Status varchar(2)=null,    
 @ProductType varchar(50)=null,    
 @BookingType varchar(50)=null,    
 @AirportType varchar(50)=null,    
 @Airline varchar(max)=null,    
 @CRS varchar(50)=null,    
 @BookingId varchar(50)=null,    
 @AirlinePnr varchar(50)=null,    
 @GDSPnr varchar(50)=null     
     
AS    
BEGIN    
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL    
 DROP table  #tempTableA    
 SELECT * INTO #tempTableA     
 from    
 (     
 select --top 1 with ties    
   AL.BookingCountry as 'Country',c.Value as 'User Type',isnull(R.AgencyName,r1.AgencyName) as 'Agency Name',    
 isnull(R.Icast,r1.Icast) as 'Cust id',    
 --CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate))  AS 'Booking date & time',    
     
 case     
       when  country.CountryCode='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate)),120)))     
       when   country.CountryCode='US' then(DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate)),120)))     
       when  country.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate)),120)))     
       when   country.CountryCode='IN' then DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate)),120))      
    end   AS 'Booking date & time',    
     
     
     
 b.orderId AS 'Track ID',    
    
 (CASE WHEN (b.BookingStatus=1) THEN 'Confirmed'     
   WHEN B.BookingStatus=2 THEN 'Hold'     
   WHEN B.BookingStatus=3 THEN 'Pending'    
   WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled'     
   WHEN B.BookingStatus=0 THEN 'Failed'     
   WHEN B.BookingStatus=5 THEN 'Close'    
   WHEN B.BookingStatus=6 THEN 'To Be Cancelled'    
         WHEN B.BookingStatus=7 THEN 'To Be Reschedule'    
   WHEN B.BookingStatus=10 THEN 'Manual Booking'     
   WHEN B.BookingStatus=8 THEN 'Reschedule PNR' END) AS 'Status', B.riyaPNR AS 'Booking id',    
 (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR',B.GDSPNR AS 'CRS PNR', B.TicketIssuanceError AS 'Remarks',    
    
 (case     
    when b.MainAgentId=0 and AL.ParentAgentID is null and  BookedBy>0 then (select  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') from AgentLogin a where a.UserID=b.BookedBy)    
    when b.MainAgentId=0 and BookedBy=0 then (select a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') from AgentLogin a where a.UserID=b.AgentID)    
    when b.MainAgentId>0  and AL.ParentAgentID is null  then (select a.UserName + '-' +   a.FullName from mUser a where a.ID=b.MainAgentId)    
    when b.MainAgentId=0 and AL.ParentAgentID is not null      
    then (select r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')  from tblBookMaster b1    
inner join agentLogin al on al.UserID=b1.AgentID    
inner join B2BRegistration r on r.FKUserID=al.ParentAgentID    
 where b1.pkId=b.pkId)    
 else '' end    
 ) AS 'User',    
    
 (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport', B.airName+' ('+B.airCode+')' 'Airline name',    
    
 (SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Sector',    
    
 (SELECT STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Flight No',        
 (SELECT STUFF((SELECT '-' +    
  CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END     
  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Class Code',    
    
 --(SELECT STUFF((SELECT '-' + CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) FROM tblBookMaster s    
 -- WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 --AS 'Dep Date' FROM tblBookMaster t where t.orderId=b.orderId  GROUP BY t.orderId) as 'Dep Date',    
    
 --(SELECT STUFF((SELECT '-' + CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103) FROM tblBookMaster s    
 -- WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 --AS 'Arrvl Date' FROM tblBookMaster t where t.orderId=b.orderId  GROUP BY t.orderId) as 'Arrvl Date',    
    
 (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Dep Date all',    
    
 (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')     
 AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Arrvl Date all',    
    
    
 (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date',    
(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date',    
(CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode',    
country.Currency as 'Currency'    
    
    
 --,convert(varchar,isnull( cast((((B.totalFare+B.TotalMarkup+B.MCOAmount+B.B2BMarkup+b.AgentMarkup)-B.TotalDiscount)* b.ROE) as decimal(18,2)) ,0)) AS 'Net fare',    
 
 
-- ,(select SUM(cast(((bm.totalFare+bm.B2BMarkup+isnull(bm.MCOAmount,0) + +isnull(bm.AgentMarkup,0))* bm.ROE) as decimal(18,2))) as 'Gross fare' From tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR)

,(select SUM (cast((((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.MCOAmount,0)+isnull(bm.B2BMarkup,0)+isnull(bm.AgentMarkup,0))-isnull(bm.TotalDiscount,0))* bm.ROE) as decimal(18,2))) from tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) AS 'Net fare' 

,(select SUM(cast(((bm.totalFare+bm.B2BMarkup+isnull(bm.MCOAmount,0) + +isnull(bm.AgentMarkup,0))* bm.ROE) as decimal(18,2))) From tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) as 'Gross fare'




 
 ,B.MCOAmount as 'MCO Amount'  
 ,(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108)) as 'UpdatedDate',    
--(ISNULL(u.UserName,agl.UserName) + '-' + ISNULL(u.FullName,(agl.FirstName+' '+agl.LastName))) as 'UpdatedbyUser',  --    
(u.UserName + '-' + u.FullName) as 'UpdatedbyUser',    
b.Remarks as 'UpdatedUserRemarks',    
     
 (case when b.MainAgentId>=0 and b.BookingSource='Web' then 'Internal Booking (Web)'    
   when b.MainAgentId>=0 and b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'    
   when b.MainAgentId>=0 and b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'    
   when b.MainAgentId>=0 and b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'    
   when b.MainAgentId>=0 and b.BookingSource='Retrieve PNR accounting' then 'Internal Booking (Retrive PNR Accounting)'    
   when b.MainAgentId=0 and b.BookingSource='Web' then 'Agent Booking (Web)'    
   when b.MainAgentId=0 and b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)'     
   when b.MainAgentId=0 and b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)'     
   when b.MainAgentId=0 and b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'  
   when b.MainAgentId>0 and b.BookingSource='ManualTicketing' then 'Manual Booking' end) as 'Booking Mode',    
     
 b.VendorName as 'CRS',b.OfficeID as 'Booking Supplier',b.OfficeID as 'Ticketing Suppier',    
    
 --(case when isnull(al.NewCurrency,0) !=0 then     
 -- (select com.Value from mCommon com where com.ID=al.NewCurrency) else '' end) as 'Agent Currency',    
  ''  as 'Agent Currency',    
 ('') as 'ROE'    
 ,b.inserteddate ,b.orderId ,b.riyaPNR ,b.AgentId   
    
 from tblBookMaster b    
 INNER JOIN agentLogin AL ON cast(AL.UserID AS VARCHAR(50))=B.AgentID    
 INNER JOIN mCommon C on C.ID=AL.UserTypeID    
 left JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID    
 left JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID    
 left JOIN Paymentmaster P ON P.order_id=B.orderId    
 left join mUser u on b.BookingTrackModifiedBy=u.ID     
 --inner join agentLogin agl on b.BookingTrackModifiedBy=agl.UserID    
 inner join mCountry country on b.Country=country.CountryCode    
 --inner join tblPassengerBookDetails pb on pb.fkBookMaster=b.pkId    
 --INNER JOIN mCommon CS ON CS.ID=B.BookingStatus    
     
 where ((@FROMDate = '') or (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(datetime,@FROMDate)))    
    AND ((@ToDate = '') or (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(datetime, @ToDate)))    
    AND ((@PaymentType = '') or (@PaymentType='Wallet' and (p.payment_mode='Check' or p.payment_mode='Credit')) or (p.payment_mode=@PaymentType))    
   AND ((@UserType = '') or ( AL.UserTypeID IN  ( select Data from sample_split(@UserType,','))))    
   AND ((@Country = '') or (al.BookingCountry IN ( select Data from sample_split(@Country,','))))    
   AND ((@AgentId = '') or  (b.AgentID =cast(@AgentId as varchar(50))) or (al.ParentAgentID=@AgentId))    
   AND ((@SubUserId = '') or  (b.AgentID =cast(@SubUserId as varchar(50))))    
    
   AND ((@Status = '')      
   or ((@Status = '1') and (cast(b.BookingStatus as varchar(50))='1' or cast(b.BookingStatus as varchar(50))='6' or cast(b.BookingStatus as varchar(50))='4') and ( b.IsBooked=1))     
   or ((@Status != '') and (cast(b.BookingStatus as varchar(50))=@Status)))    
    
   AND ((@ProductType = '') or ( @ProductType = 'Airline'))    
    
   AND ((@AirportType = '')      
   or ((@AirportType = 'Domestic') and (b.CounterCloseTime = 1))     
   or ((@AirportType = 'International') and (b.CounterCloseTime != 1)))    
    
   AND ((@Airline = '') or (b.airCode IN  ( select Data from sample_split(@Airline,','))))    
    
   AND ((@BookingId = '') or (b.riyaPNR = @BookingId))    
   AND ((@AirlinePnr = '') or ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))    
   AND ((@GDSPnr = '') or (b.GDSPNR = @GDSPnr))    
   AND ((@CRS = '') or (b.VendorName = @CRS))    
    
   AND ( (@BookingType = '') or((@BookingType='IBW') and b.MainAgentId>0 and (b.BookingSource='Web'))    
    or((@BookingType='IBR') and b.MainAgentId>0 and (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))    
    or((@BookingType='IBRA') and b.MainAgentId=0 and (b.BookingSource='Retrieve PNR accounting'))    
    or((@BookingType='ABW') and b.MainAgentId=0 and (b.BookingSource='Web'))    
    or((@BookingType='ABR') and b.MainAgentId=0 and (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))     
    or((@BookingType='CRYPI') and b.MainAgentId>0 and (b.BookingSource='Cryptic'))    
    or((@BookingType='CRYPA') and b.MainAgentId=0 and (b.BookingSource='Cryptic'))  
 or((@BookingType='Manual') and b.MainAgentId>0 and (b.BookingSource='ManualTicketing'))  
    )    
    
    and b.returnFlag=0    
    
    --order by row_number() over (partition by b.GDSPNR order by b.inserteddate desc)    
   ) p    
   order by p.[Booking date & time] desc    
    
     
 SELECT * FROM #tempTableA    
 ORDER BY [Booking date & time] desc     
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetBookingTrackWeb_1] TO [rt_read]
    AS [dbo];

