--exec [Sp_GetDetailsforPrint] '','59CG9K','3A6OP6',''
CREATE Procedure [dbo].[Sp_GetDetailsforPrintNEW1]
@orderid nvarchar(50) =null,
@RiyaPNR varchar(8)=null,
--@airlinePNR varchar(20),
@GDSPNR varchar(20)=null,
@Currency varchar(10)

as
begin


select top 1 
b.AgencyName,
AddrAddressLocation +','+ AddrCity +','+AddrState +'-'+ AddrZipOrPostCode as AgencyAddress,
AddrLandlineNo +'/'+ AddrMobileNo as AgencyContact,
AddrEmail as AgencyEmail,
t.riyaPNR,
CONVERT(VARCHAR(20), t.IssueDate, 103) as IssueDt,  

t.mobileNo as CustomerContactno,
 case when ac.type='LCC' then 'NA' else t.GDSPNR End CRSpnr,
tbi.airlinePNR,
t.operatingCarrier as IssueBy,
--'' as contactno,
tbi.aircode,
--c.CurrencyCode,


case when c.CurrencyCode !=@Currency then

'ServiceCharge: ' + convert(varchar(20), cast((ServiceCharge *t.AgentROE * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(YRTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(INTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(JNTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(OCTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(ExtraTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(YQTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
		+   ';SC :' + convert(varchar(20), cast((isnull(B2BMarkup ,0)*t.AgentROE  ) as decimal(10,2))) 
		+  isnull(case when MCOAmount>0 then ';MCO Amount :' + convert(varchar(20), cast((isnull(MCOAmount ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
		+  isnull(case when ServiceFee>0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
		+  isnull(case when GST>0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
		+  isnull(case when BFC>0 then ';BFC:' + convert(varchar(20), cast((isnull(BFC ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
	--    	+  isnull(case when ReissueCharges>0 then ' Reissue Charges :' + convert(varchar(20), cast((isnull(ReissueCharges ,0) ) as decimal(10,2))) end,'')
	ELSE
	'ServiceCharge: ' + convert(varchar(20), cast((ServiceCharge * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(YRTax ,0) * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(INTax ,0) * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(JNTax ,0) * t.ROE ) as decimal(10,2)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(OCTax ,0) * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(ExtraTax ,0) * t.ROE ) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(YQTax ,0) * t.ROE ) as decimal(10,2))) 
	+   ';SC :' + convert(varchar(20), cast((isnull(B2BMarkup ,0)  ) as decimal(10,2)))
	+  isnull(case when MCOAmount>0 then ';MCO Amount :' + convert(varchar(20), cast((isnull(MCOAmount ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when ServiceFee>0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when GST>0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when BFC>0 then ';BFC:' + convert(varchar(20), cast((isnull(BFC ,0)  ) as decimal(10,2))) end,'')
	--    +  isnull(case when ReissueCharges>0 then ' Reissue Charges :' + convert(varchar(20), cast((isnull(ReissueCharges ,0) ) as decimal(10,2))) end,'')
	 end taxdesc

, convert(varchar(20), isnull(t.inserteddate_old,t.inserteddate), 103) AS BookingDate
-- t.inserteddate as BookingDate
,pm.payment_mode
,u.FullName as BookedBy
,u.EmployeeNo as EmployeeCode
,t.OfficeID as BookingTicketingSupplier
,case when t.MainAgentId>0 and t.BookingSource='Web' then 'Internal Booking (Web)'
			when t.MainAgentId>0 and t.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
			--afifa
	      	when t.MainAgentId>0 and t.BookingSource='ManualTicketing' then 'Manual Booking'
			--
			when t.MainAgentId=0 and t.BookingSource='Web' then 'Agent Booking (Web)'
			when t.MainAgentId=0 and t.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' end  as BookingType

,isnull(t.isReturnJourney,0) Isreturn
 ,t.FareType 
 ,t.Country as agencyCountry
 ,pm.currency
from tblBookMaster t
left join [AirlineCode_Console] ac on ac.AirlineCode=t.airCode
--inner join tblPassengerBookDetails t1 on t1.fkBookMaster =t.pkId
left join B2BRegistration b on b.FKUserID=t.AgentID
left join mCountryCurrency c on c.CountryCode=t.Country
left join tblBookItenary tbi on tbi.orderid=t.orderid
left join [dbo].[Paymentmaster] pm on pm.order_id=t.orderid
left join [mUser] u on u.id=t.BookedBy
where t.orderid=@orderid or t.riyaPNR=@RiyaPNR 
 --group by t.pkId,CurrencyCode
--where t.riyaPNR=@RiyaPNR or t.GDSPNR=@GDSPNR or tbi.airlinePNR=@airlinePNR

--passenger details
select
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
--'Confirmed' as Status,

case 
when t2.BookingStatus=2 then 'Hold'
WHEN t1.BookingStatus=6  THEN 'To Be Cancelled' 
WHEN t1.BookingStatus=4  THEN 'Cancelled' 
when t1.BookingStatus is null then 'Confirmed'
when t2.BookingStatus=0 then 'Failed'
 when t2.BookingStatus=1 then 'Confirmed'
when t2.BookingStatus=2 then 'Hold'
when t2.BookingStatus=3 then 'Pending'
when t2.BookingStatus=4 then 'Cancelled'
when t2.BookingStatus=5 then 'Close'
when t1.BookingStatus is null then 'Confirmed'
End Status,

 --concat(t1.TicketNumber ,'-',a2.[AWB Prefix]) TicketNumber,

(CASE WHEN CHARINDEX('/',ticketNum)>0 
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
ELSE ticketNum END )as 'TicketNumber',

--STUFF((SELECT '/' + t1.baggage FROM tblBookMaster s 
--WHERE t1.fkBookMaster = s.pkId FOR XML PATH('')),1,1,'') AS baggage

CASE WHEN t2.isReturnJourney=1 and t1.paxType='ADULT' then t1.baggage+'/'+t1.baggage	
 WHEN t2.isReturnJourney=1 and t1.paxType='CHILD' then t1.baggage+'/'+t1.baggage	
 WHEN t2.isReturnJourney=1 and t1.paxType='INFANT' then t1.baggage+'/'+t1.baggage	
 WHEN t2.isReturnJourney=0 and t1.paxType='ADULT' then t1.baggage	
 WHEN t2.isReturnJourney=0 and t1.paxType='CHILD' then t1.baggage	
 WHEN t2.isReturnJourney=0 and t1.paxType='INFANT' then t1.baggage	
 end baggage

,T1.isReturn
,t1.paxType

 from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
  left join AirlinesName a2 on a2._CODE=t2.airCode
where  t2.riyaPNR=@RiyaPNR  and t1.isReturn=0


--flight details
select distinct 
t.airCode,
t.airName,
t.flightNo,
t.operatingCarrier,
t.fromAirport,
--t.deptTime,
 --convert(varchar(20), t.deptTime, 103) deptTime,
FORMAT(CAST(t.deptTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') deptTime,
t.depDate,
t.fromTerminal,

t.toAirport,
--t.arrivalTime,
 --convert(varchar(20), t.arrivalTime, 103) arrivalTime,
 FORMAT(CAST(t.arrivalTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') arrivalTime,
t.arrivalDate,
t.toTerminal,
t.farebasis,
t.insertedOn,

CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, t.deptTime,t.arrivalTime), 0), 114) as Traveldifference,
t.cabin,t.deptTime

from tblBookItenary t
left join tblBookItenary tbi on tbi.fkBookMaster=t.fkBookMaster
where t.orderid=@orderid 
order by t.deptTime asc
--where t.riyaPNR=@RiyaPNR or t.airlinePNR=@airlinePNR


--GST details
select 
RegistrationNumber,	
CompanyName,
CAddress,
CState,
CContactNo,
CEmailID

 from tblBookMaster t
where  t.riyaPNR=@RiyaPNR or t.GDSPNR=@GDSPNR

--Cancellation Remarks
select distinct t1.RemarkCancellation2,t1.CancellationPenalty
,ISNULL(t1.CancellationMarkup,0.0) AS CancellationMarkup, Format(cast(t1.CancelledDate as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') CancelledDate,isnull(u.UserName,br.AgencyName) UserName,
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName, t2.frmSector,t2.toSector,pid
  from
 tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
 left join [mUser] u on u.id=t1.CancelByBackendUser1
 left join B2BRegistration br on br.FKUserID=t1.CancelByAgency1
where  t2.riyaPNR=@RiyaPNR and t1.RemarkCancellation2 is not null  --and t1.CancellationPenalty>0 and t1.CancellationMarkup>0
order by pid asc


--payment details
select tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,
--distinct
case when c.CurrencyCode !=@Currency then
sum(cast((tP.basicFare *tb.AgentROE* tb.ROE+isnull(tp.Markup,0)) as decimal(10,2))) else sum(cast((tp.basicFare * tb.ROE+ isnull(tp.Markup,0)) as decimal(10,2))) end basicFare

,case when c.CurrencyCode!=@Currency then
sum(cast(((tp.totalTax + isnull(tp.MCOAmount,0)) *tb.AgentROE * tb.ROE)+ (isnull(tb.B2BMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.gst,0) + isnull(tb.BFC,0)) *tb.AgentROE  as decimal(10,2))) else sum(cast((tp.totalTax + isnull(tp.MCOAmount,0)) * tb.ROE + (isnull(tp.B2BMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.gst,0) + isnull(tb.BFC,0))  as decimal(10,2))) end totalTax

,case when c.CurrencyCode !=@Currency then
sum(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2))) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0)  + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0) else sum(cast((tp.totalFare) * tb.ROE as decimal(10,2))) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0) end  totalFare

,case when c.CurrencyCode !=@Currency then
sum(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (isnull(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (isnull(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
else sum(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)* tb.ROE ) +  (isnull(tp.reScheduleCharge,0)* tb.ROE ) + (isnull(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) end ReschedulePenalty
,c.CurrencyCode
from tblBookMaster tb
left join tblPassengerBookDetails tp on tp.fkBookMaster=tb.pkId
 left join mCountryCurrency c on c.CountryCode=tb.Country
where riyaPNR=@RiyaPNR  and tb.totalFare>0
group by c.CurrencyCode,tb.MCOAmount,tb.AgentMarkup,tb.ServiceFee,tb.GST,TB.BFC, tb.ReissueCharges,  tp.title, tp.paxFName , tp.paxLName , paxType

--status cancellation
Declare @TotalPasscount int
Declare @CancelledPasscount int

set @TotalPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@RiyaPNR)

set @CancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=4)

if(@TotalPasscount=@CancelledPasscount)
begin
select top 1 BookingStatus from tblBookMaster where riyapnr=@RiyaPNR
end
else
begin
select top 1 BookingStatus from tblBookMaster where riyapnr=@RiyaPNR
end

--booking details
select 
Format(cast(isnull(tb.inserteddate_old,tb.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as BookingDate,
pm.payment_mode,
isnull(u.FullName,ag.UserName) FullName,
case when tb.MainAgentId>=0 and tb.BookingSource='Web' then 'Internal Booking (Web)'
			when tb.MainAgentId>=0 and tb.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
			--afifa
	      	when tb.MainAgentId>0 and tb.BookingSource='ManualTicketing' then 'Manual Booking'
			--
			when tb.MainAgentId=0 and tb.BookingSource='Web' then 'Agent Booking (Web)'
			when tb.MainAgentId=0 and tb.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' end  as BookingType 

,tb.OfficeID as BookingTicketingSupplier
,isnull(u.UserName,0) ID
,ISNULL(U.ID,0) UserId

from tblBookMaster tb
left join [dbo].[Paymentmaster] pm on pm.order_id=tb.orderid
left join agentLogin ag on ag.UserID=tb.AgentID
left join [mUser] u on u.id=tb.BookedBy
where tb.riyapnr=@RiyaPNR


--pax type distinct	
select distinct	
t1.paxType	
--,'' as MarkupId	
 from tblPassengerBookDetails t1	
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster	
  left join AirlinesName a2 on a2._CODE=t2.airCode	
where  t2.riyaPNR=@RiyaPNR  order by paxType asc	

	--BAGGEGE DETAILS FROM SSR TABLE	
  select tp.baggage,ssr.SSR_Type,SSR.SSR_Name, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName	
 	
   from tblPassengerBookDetails tp	
 inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid
 inner join tblBookMaster tb on tb.pkid=SSR.fkBookMaster

where  tb.riyaPNR=@RiyaPNR and SSR_Type='baggage'


--Reschedule passenger details List
select
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
--'Confirmed' as Status,
case
when r1.Status=7 then 'To Be Rescheduled' 
when r1.Status=8 then 'Rescheduled' 
WHEN t1.BookingStatus is null  THEN 'Confirmed'
End Status , t1.paxType
from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
 left join RescheduleData r1 on r1.pid=t1.pid  
where  t2.riyaPNR=@RiyaPNR  --and r1.Status in(7,8)--and t1.isReturn=0


--Old PNR  payment details


select tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,

case when c.CurrencyCode !=@Currency then
--sum
(ISNULL(cast((tP.basicFare *tb.AgentROE* tb.ROE+isnull(tp.Markup,0)) as decimal(10,2)),0)) else --sum
(ISNULL(cast((tp.basicFare * tb.ROE+ isnull(tp.Markup,0)) as decimal(10,2)),0)) end basicFare
,
case when c.CurrencyCode!=@Currency then
--sum
(ISNULL(cast(((tp.totalTax + isnull(tp.MCOAmount,0)) *tb.AgentROE * tb.ROE)+ (isnull(tb.B2BMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.gst,0) + isnull(tb.BFC,0)) *tb.AgentROE  as decimal(10,2)),0)) else --sum
(ISNULL(cast((tp.totalTax + isnull(tp.MCOAmount,0)) * tb.ROE + (isnull(tp.B2BMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.gst,0) + isnull(tb.BFC,0))  as decimal(10,2)),0)) end  totalTax
,
case when c.CurrencyCode !=@Currency then
--sum
(ISNULL(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2)),0)) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0)  + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0) else --sum
(ISNULL(cast((tp.totalFare) * tb.ROE as decimal(10,2)),0)) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0) end totalFare
,
case when c.CurrencyCode!=@Currency then
(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (isnull(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (isnull(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
else --sum
(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)* tb.ROE ) +  (isnull(tp.reScheduleCharge,0)* tb.ROE ) + (isnull(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) end ReschedulePenalty
,
Case when c.CurrencyCode !=@Currency then
cast((isnull(tp.YQ ,0)*tb.AgentROE * tb.ROE) as decimal(10,2))
else
cast((isnull(tp.YQ ,0) * tb.ROE ) as decimal(10,2)) End YQ
,
Case when c.CurrencyCode !=@Currency then
cast((isnull(tp.JNTax ,0)*tb.AgentROE * tb.ROE ) as decimal(10,2))
else
cast((isnull(tp.JNTax ,0) * tb.ROE ) as decimal(10,2)) End JNTax
,
Case when c.CurrencyCode !=@Currency then
cast((isnull(tp.ExtraTax ,0)*tb.AgentROE * tb.ROE ) as decimal(10,2))
else
cast((isnull(tp.ExtraTax ,0) * tb.ROE ) as decimal(10,2)) End ExtraTax

--,tp.YQ, tp.JNTax, tp.ExtraTax, tp.INTax, tp.OCTax, tp.ServiceFee

from tblBookMaster tb
left join tblPassengerBookDetails tp on tp.fkBookMaster=tb.pkId
left join mCountryCurrency c on c.CountryCode=tb.Country
--inner join tblBookMaster ntb on tb.riyaPNR=ntb.PreviousRiyaPNR
--where tb.riyaPNR= @RiyaPNR 
where tb.riyaPNR= (select top 1 PreviousRiyaPNR from tblBookMaster where riyaPNR	= @RiyaPNR) 
and isnull(tp.reScheduleCharge,0) = 0 and tb.totalFare>0

	--MEAL DETAILS FROM SSR TABLE	
  select tp.baggage,ssr.SSR_Type,SSR.SSR_Name, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName	
 	
   from tblPassengerBookDetails tp	
 inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid
 inner join tblBookMaster tb on tb.pkid=SSR.fkBookMaster

where  tb.riyaPNR=@RiyaPNR and SSR_Type='Meals'
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetDetailsforPrintNEW1] TO [rt_read]
    AS [dbo];

