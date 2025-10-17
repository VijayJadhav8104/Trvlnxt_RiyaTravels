
CREATE PROCEDURE [dbo].[fetchInprocessData]
@Userid int
AS
BEGIN

--SELECT  t.pid as pid, bm.riyaPNR as RiyaPNR,bm.frmSector  as frmloc,bm.toSector as toloc,OrderId
--,CASE WHEN (pm.order_status is null) THEN 'Pending'
-- WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
-- WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus,
-- t.ticketNum as TicketNum,status_message,
-- DATEDIFF(mi,bm.inserteddate,getdate()) as mints,
-- --(convert(varchar(5),DateDiff(s, bm.inserteddate, GETDATE())/3600)+':'+convert(varchar(5),DateDiff(s,bm.inserteddate, GETDATE())%3600/60)+':'+convert(varchar(5),(DateDiff(s, bm.inserteddate, GETDATE())%60)) ) as timeline,
--  timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()-bm.inserteddate))) +
--   ' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-bm.inserteddate))) +
-- ' M:'+  convert(varchar(5),datepart(minute,(GETDATE()-bm.inserteddate))),
 
-- GDSPNR as GDSPNR,bm.[airName] as airname,
--bm.emailId as email,bm.mobileNo as mob,
--bm.depDate as deptdate,bm.arrivalDate arrivaldate,[paxfname]+' ' +[paxlname] as paxname
--,CASE WHEN (pm.order_status is null) THEN 'Pending'
-- WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
--	 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
--	  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus 
--	  ,bm.IP
--from [dbo].[tblPassengerBookDetails] t
--inner join  [dbo].[tblBookMaster] bm on t.fkBookMaster=bm.pkId
--left join dbo.Paymentmaster pm on pm.order_id=bm.orderId
-- where bm.IsBooked =0
-- Order by t.pId 

SELECT  distinct(t.pkId) as pid, t.riyaPNR as RiyaPNR,t.frmSector  as frmloc,
t.TicketIssuanceError as TicketIssuanceError,
t.toSector as toloc,OrderId
,CASE WHEN (pm.order_status is null) THEN 'Pending'
 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus,status_message,
 DATEDIFF(mi,t.inserteddate,getdate()) as mints,
   timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()-t.inserteddate))) +
   ' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-t.inserteddate))) +
 ' M:'+  convert(varchar(5),datepart(minute,(GETDATE()-t.inserteddate))),
  GDSPNR as GDSPNR,t.[airName] as airname,
t.emailId as email,t.mobileNo as mob,t.depDate as deptdate,t.arrivalDate arrivaldate
,CASE WHEN (pm.order_status is null) THEN 'Pending'
 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
	 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
	  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus 
	  ,t.IP,p.ticketNum,p.isReturn,t.Country,t.OfficeID
from  [dbo].[tblBookMaster] t
left join dbo.Paymentmaster pm on pm.order_id=t.orderId
inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
 where t.IsBooked =0 and t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
 AND T.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)

end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInprocessData] TO [rt_read]
    AS [dbo];

