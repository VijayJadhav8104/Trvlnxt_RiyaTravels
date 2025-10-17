



CREATE procedure [dbo].[GetConfirmList]
@Userid int
as
begin


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
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) and AgentAction=2


end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetConfirmList] TO [rt_read]
    AS [dbo];

