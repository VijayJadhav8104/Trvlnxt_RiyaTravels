--exec SP_GetRescheduleData '8O5D4T'  
CREATE Procedure [dbo].[SP_GetRescheduleData]  
@RiyaPNR nvarchar(20)=null  
as  
begin  
  
select distinct   
b.Icast as TerminalID,  
b.AgencyName,  
b.AddrMobileNo as PhoneNo,  
b.AddrEmail,  
Format(cast(t2.IssueDate as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as IssueDate,  
pm.payment_mode as PaymentMode,  
mobileNo as ResmobileNo,  
emailId as ResemailId  
  
 from tblBookMaster t2  
 left join B2BRegistration b on b.FKUserID=t2.AgentID  
left join  Paymentmaster pm on pm.order_id=t2.orderId  
where  t2.riyaPNR=@RiyaPNR and t2.BookingStatus=1 ----and t2.isReturn=0  
  
--passenger details  
  
select  title +' .'+paxFName+' '+paxLName as Fullname,  tp.paxType,  
case when rd.Status=7 then 'To Be Rescheduled'   
when rd.Status=8 then 'Rescheduled'   
when tp.bookingstatus is null then 'Confirmed' end Status, tp.fkBookMaster as PassfkBookMaster, tp.pid as ResPid  
from tblPassengerBookDetails tp  
left join tblBookMaster tb on tb.pkid=tp.fkbookmaster  
left join RescheduleData rd on rd.pid=tp.pid    
where tb.riyapnr=@RiyaPNR --and tp.isReturn=0 
and tb.BookingStatus=1 
and
 (tp.isReturn=0 or (tp.isReturn=1 and (select count(pkId) from tblBookMaster where riyaPNR=@RiyaPNR) =1))and  
(tp.totalFare>0 ) 
  
--Old Query commented on 07-06-2021  
--select  title +' .'+paxFName+' '+paxLName as Fullname,  
--tp.paxType,  
--case when tp.bookingstatus is null then 'Confirmed' end Status, tp.fkBookMaster as PassfkBookMaster, tp.pid as ResPid  
  
-- from tblPassengerBookDetails tp  
--left join tblBookMaster tb on tb.pkid=tp.fkbookmaster  
--where tb.riyapnr=@RiyaPNR and tp.isReturn=0  
--End  
  
  
  
--//--flight details  
select distinct   
 t1.airCode+' '+t1.flightNo as flightNo1,  
 --Start (Added by Nitish on 13-05-2021)   
 tbi.airCode +' '+tbi.flightNo as flightNo,  
 -- End  
 tbi.frmSector,  
tbi.toSector,  
--tbi.deptTime,  
Format(cast(tbi.deptTime as datetime),'dd/MM/yyyy HH:mm','en-us')  as deptTime,  
--t1.arrivalTime,  
tbi.cabin,  
tbi.fkBookMaster as FlightFKbookmaster  
,tbi.deptTime  
  
from tblBookMaster t1  
inner join tblPassengerBookDetails tp on tp.fkBookMaster=t1.pkId  
left join tblBookItenary tbi on tbi.fkBookMaster=tp.fkBookMaster  
where t1.riyaPNR=@RiyaPNR and t1.BookingStatus=1  order by tbi.deptTime asc  
  
End  
  
--Order Id  
Select top 1 orderId as OrderId,isReturnJourney from tblBookMaster where riyaPNR=@RiyaPNR  
  
--Passenger list  
select  title +' .'+paxFName+' '+paxLName as Fullname,  
tp.paxType,  
case when tb.bookingstatus=1 then 'Confirmed' end Status, tp.fkBookMaster as PassfkBookMaster, tp.pid as ResPid  
  
 from tblPassengerBookDetails tp  
left join tblBookMaster tb on tb.pkid=tp.fkbookmaster  
where tb.riyapnr=@RiyaPNR  and tb.BookingStatus=1  
--select * from tblbookmaster where riyapnr='4QT5O8'
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetRescheduleData] TO [rt_read]
    AS [dbo];

