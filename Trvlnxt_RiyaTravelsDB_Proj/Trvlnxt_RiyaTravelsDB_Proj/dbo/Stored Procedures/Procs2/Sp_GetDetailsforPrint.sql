--exec Sp_GetDetailsforPrint 'RT20220606105618949','F1DP33','na','INR'
CREATE Procedure [dbo].[Sp_GetDetailsforPrint]
@orderid nvarchar(50) =null,
@RiyaPNR varchar(8)=null,
--@airlinePNR varchar(20),
@GDSPNR varchar(20)=null,
@Currency varchar(10),
@MainAgentId int=null

as
begin

declare @NewOrderID varchar(50)=null
select top 1 @NewOrderID=orderId from tblBookMaster where riyaPNR=@RiyaPNR order by pkId desc;

select top 1 
ISNULL(b.AgencyName,B1.AgencyName) AS AgencyName, 
ISNULL(ISNULL(B.AddrAddressLocation,B1.AddrAddressLocation) +','+ ISNULL(B.AddrCity,B1.AddrCity) +','+ISNULL(B.AddrState,B1.AddrState) +'-'+ ISNULL(B.AddrZipOrPostCode,B1.AddrZipOrPostCode), '') as AgencyAddressNW,
ISNULL(ISNULL(B.AddrAddressLocation,B1.AddrAddressLocation) +','+ ISNULL(B.AddrCity,B1.AddrCity) +','+ISNULL(B.AddrState,B1.AddrState) +'-'+ ISNULL(B.AddrZipOrPostCode,B1.AddrZipOrPostCode), '') as AgencyAddress,
ISNULL(B.AddrLandlineNo,B1.AddrLandlineNo) +'/'+ ISNULL(B.AddrMobileNo,B1.AddrMobileNo) as AgencyContact,
ISNULL(B.AddrEmail,B1.AddrEmail) as AgencyEmail,
t.riyaPNR,
CONVERT(VARCHAR(20), t.IssueDate, 103) as IssueDt,  

t.mobileNo as CustomerContactno,  ISNUll(t.GDSPNR,'NA') AS CRSpnr,
--case when ac.type='LCC' then 'NA' else t.GDSPNR End CRSpnr,
tbi.airlinePNR,
t.ValidatingCarrier as IssueBy,
tbi.aircode,

case when c.CurrencyCode !=@Currency then

'ServiceCharge: ' + convert(varchar(20), cast((ServiceCharge *t.AgentROE * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(YRTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(INTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(JNTax ,0)*t.AgentROE * t.ROE ) as decimal(10)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(OCTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(ExtraTax ,0)*t.AgentROE * t.ROE + ISNULL(RFTax, 0)) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(YQTax ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
	+   ';WOTax :' + convert(varchar(20), cast((isnull(WOTax ,0)  ) as decimal(10,2)))
		+   ';SC :' + convert(varchar(20), cast((isnull(B2BMarkup ,0)*t.AgentROE  ) as decimal(10,2))) 
		+  isnull(case when MCOAmount>0 then ';MCO Amount :' + convert(varchar(20), cast((isnull(MCOAmount ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
		+  isnull(case when ServiceFee>0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)) as decimal(10,2))) end,'')
		+  isnull(case when GST>0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)) as decimal(10,2))) end,'')
		+  isnull(case when BFC>0 then ';BFC:' + convert(varchar(20), cast((isnull(BFC ,0)*t.AgentROE  ) as decimal(10,2))) end,'')
	--    	+  isnull(case when ReissueCharges>0 then ' Reissue Charges :' + convert(varchar(20), cast((isnull(ReissueCharges ,0) ) as decimal(10,2))) end,'')
	ELSE
	'ServiceCharge: ' + convert(varchar(20), cast((ServiceCharge * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(YRTax ,0) * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(INTax ,0) * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(JNTax ,0) * t.ROE ) as decimal(10)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(OCTax ,0) * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(ExtraTax ,0) * t.ROE + ISNULL(RFTax, 0)) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(YQTax ,0) * t.ROE ) as decimal(10,2))) 
	+   ';WOTax :' + convert(varchar(20), cast((isnull(WOTax ,0)  ) as decimal(10,2)))
	+   ';SC :' + convert(varchar(20), cast((isnull(B2BMarkup ,0)  ) as decimal(10,2)))
	+  isnull(case when MCOAmount>0 then ';MCO Amount :' + convert(varchar(20), cast((isnull(MCOAmount ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when ServiceFee>0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when GST>0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)  ) as decimal(10,2))) end,'')
	+  isnull(case when BFC>0 then ';BFC:' + convert(varchar(20), cast((isnull(BFC ,0)  ) as decimal(10,2))) end,'')
	--    +  isnull(case when ReissueCharges>0 then ' Reissue Charges :' + convert(varchar(20), cast((isnull(ReissueCharges ,0) ) as decimal(10,2))) end,'')
	 end taxdesc

, convert(varchar(20), isnull(t.inserteddate_old,t.inserteddate), 103) AS BookingDate
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
			when t.MainAgentId=0 and t.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)'
			when t.MainAgentId=0 and t.BookingSource='GDS' then 'TJQ'
		 end  as BookingType

,isnull(t.isReturnJourney,0) Isreturn
 ,t.FareType 
 ,t.Country as agencyCountry
,isnull(pm.currency,t.agentcurrency)  as currency
,isnull(t.MCOAmount,0) MCOAmount
,isnull(t.BFC,0) BFC

,case when c.CurrencyCode !=@currency then 
cast((t.JNTax *t.AgentROE* t.ROE) as decimal(10,2)) else cast((t.JNTax * t.ROE) as decimal(10,2)) end JNTax

,case when c.CurrencyCode !=@currency then 
cast((t.YQTax *t.AgentROE* t.ROE) as decimal(10,2)) else cast((t.YQTax * t.ROE) as decimal(10,2)) end YQTax

,t.emailId ,BookingSource
,ag.userTypeID
,t.ROE, t.AgentID, t.VendorName, t.CounterCloseTime 
,tbi.cabin
,tbi.farebasis
,t.GDSPNR
,T.Country
,FORMAT(t.IssueDate,'dd/MM/yyyy hh:mm:ss tt')  MarineIssueDate
--JD29.08.2022
, ISNULL(AgentLogoNew, '') AS AgentLogoNew
, ISNULL(Logo, '') AS Logo
, ISNULL(ag.GroupId, 0) AS GroupId -- Added BY JD 22.11.2022
, ISNULL(t.HoldText, '') AS HoldText -- Added by JD 15.12.2022
from tblBookMaster t
left join [AirlineCode_Console] ac on ac.AirlineCode=t.airCode
--inner join tblPassengerBookDetails t1 on t1.fkBookMaster =t.pkId
left join B2BRegistration b on b.FKUserID=t.AgentID
left join mCountryCurrency c on c.CountryCode=t.Country
left join tblBookItenary tbi on tbi.orderid=t.orderid
left join [dbo].[Paymentmaster] pm on pm.order_id=t.orderid
left join [mUser] u on u.id=t.BookedBy
left join  agentLogin ag on ag.UserID=t.AgentID
left join B2BRegistration b1 on b1.FKUserID=AG.ParentAgentID
where t.orderid=@NewOrderID and  returnFlag =0 and t.AgentID !='B2C'
order by t.inserteddate desc


--passenger details
select
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
--'Confirmed' as Status,
CASE when t1.isReturn=0 then 'Single' else 'Return' end Journey, 
case 
when t2.BookingStatus=2 then 'Hold'
WHEN t1.BookingStatus=6  THEN 'To Be Cancelled' 
when t2.BookingStatus=14 then 'Open Ticket'
WHEN t1.BookingStatus=4  THEN 'Cancelled' 
when t2.BookingStatus=0 then 'Failed'
--when t1.BookingStatus is null AND T2.IsBooked=1 then 'Confirmed'
 --when t2.BookingStatus=1 AND T2.IsBooked=1 then 'Confirmed'
 when t2.BookingStatus=1 then 'Confirmed'
when t2.BookingStatus=2 then 'Hold'
when t2.BookingStatus=3 then 'Pending'
when t2.BookingStatus=4 then 'Cancelled'
when t2.BookingStatus=5 then 'Close'
when t2.BookingStatus=11 then 'Cancelled'
when t2.BookingStatus=15 then 'On Hold Canceled'
when t2.BookingStatus=12 then 'In-Process' 
WHEN t2.BookingStatus=13 THEN 'TJQ Pending'
when t1.BookingStatus is null then 'Confirmed'
End Status,

(CASE WHEN CHARINDEX('/',ticketNum)>0 
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
ELSE ticketNum END )as 'TicketNumber',

CASE WHEN t2.returnFlag=1 and t1.paxType='ADULT' then t1.baggage +'/'+t1.baggage	
 WHEN t2.returnFlag=1 and t1.paxType='CHILD' then t1.baggage +'/'+t1.baggage	
  WHEN t2.returnFlag=1 and t1.paxType='INFANT' then CASE WHEN T1.baggage='0' THEN '0 kg/0 kg' ELSE t1.baggage+'/'+t1.baggage END  
 WHEN t2.returnFlag=0 and t1.paxType='ADULT' then t1.baggage +'/'+t1.baggage --Added by JD (+'/'+t1.baggage)
 WHEN t2.returnFlag=0 and t1.paxType='CHILD' then t1.baggage +'/'+t1.baggage --Added by JD (+'/'+t1.baggage)
 WHEN t1.paxType='INFANT' then --t1.baggage
	CASE WHEN T1.baggage='0' THEN '0 kg/0 kg' ELSE t1.baggage+'/'+t1.baggage END -- Added by JD 10.03.2023
 end baggage
,T1.isReturn
,t1.paxType
,t1.pid

,t1.paxFName
,t1.paxLName
, CASE WHEN BarCode IS NULL THEN '' 
		ELSE (SELECT STUFF((SELECT '^' + BarCode 
					FROM tblPassengerBookDetails PB 
					LEFT JOIN tblBookMaster t2 ON t2.pkId=PB.fkBookMaster 
					WHERE t2.riyaPNR = @RiyaPNR AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
					FOR XML PATH('')
				), 1, 1, ''))
		END AS BarCode
, ISNULL(PassengerID, '') AS PassengerID -- Added By JD 20.01.2022
, t2.frmSector
, t2.toSector
 from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
  left join AirlinesName a2 on a2._CODE=t2.airCode
where  t2.orderId=@NewOrderID  and (t1.isReturn=0 or (t1.isReturn=1 and (select count(pkId) from tblBookMaster where orderId=@NewOrderID) =1))and  
(t1.totalFare>0 or (isnull(t2.PreviousRiyaPNR,'')!='') or t1.paxType='Infant') 
order by t1.paxType,FullName asc


--flight details
select distinct 
t.airCode,
t.airName,
t.flightNo,
t.operatingCarrier,
t.fromAirport,
FORMAT(CAST(t.deptTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') deptTime,
t.depDate,
t.fromTerminal,
t.toAirport,
 FORMAT(CAST(t.arrivalTime AS datetime), 'dd/MM/yyyy HH:mm:ss tt') arrivalTime,
t.arrivalDate,
t.toTerminal,
t.farebasis,
t.insertedOn,
CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, t.deptTime,t.arrivalTime), 0), 114) as Traveldifference,
t.cabin,t.deptTime
, tb.VendorName, tb.TotalTime
,t.airlinePNR
,FORMAT(CAST(t.depDate AS datetime), 'dd/MM/yyyy') DepartDate
,convert(char(5), t.deptTime, 108) as DepartTime
,t.frmSector
,t.toSector
,FORMAT(CAST(t.arrivalDate AS datetime), 'dd/MM/yyyy') ArrivDate
,convert(char(5), t.arrivalTime, 108) as ArrivTime

,SUBSTRING(t.fromAirport, 0, charindex('-', t.fromAirport, 0)) fromAirportNEW
,SUBSTRING(t.toAirport, 0, charindex('-', t.toAirport, 0)) toAirportNEW
,tb.inserteddate
--,SUBSTRING(tbi.fromAirport, 0, charindex(' ', tbi.fromAirport, 0)) fromAirportMarine
--,SUBSTRING(tbi.toAirport, 0, charindex(' ', tbi.toAirport, 0)) toAirportMarine
--,convert(varchar(7), tbi.depDate, 106) depDateMarine
--,convert(varchar(7), tbi.arrivalDate, 106) arrivalDateMarine
--,CONVERT(VARCHAR(5),tbi.deptTime,108) AS deptTimeMarine
--,CONVERT(VARCHAR(5),tbi.arrivalTime,108) AS arrivalTimeMarine
--,upper(substring(DATENAME(weekday,tbi.deptTime),1,3)) +','+FORMAT(CAST(tbi.deptTime AS datetime), 'dd MMMM yyyy') WholeDateMarine

from tblBookItenary t
left join tblBookItenary tbi on tbi.fkBookMaster=t.fkBookMaster
inner join tblBookMaster tb on tb.pkId=t.fkBookMaster
where  tb.orderId=@NewOrderID
order by t.deptTime asc



--GST details
select 
ISNULL(RegistrationNumber, '') AS RegistrationNumber,	
ISNULL(CompanyName, '') AS CompanyName,
ISNULL(CAddress, '') AS CAddress,
ISNULL(CState, '') AS CState,
ISNULL(CContactNo, '') AS CContactNo,
ISNULL(CEmailID, '') AS CEmailID

 from tblBookMaster t
where  t.orderId=@NewOrderID --or t.GDSPNR=@GDSPNR


--Cancellation Remarks
select distinct t1.RemarkCancellation2,t1.CancellationPenalty
,ISNULL(t1.CancellationMarkup,0.0) +ISNULL(t1.MarkupOnTaxFare,0.0) +ISNULL(t1.MarkuponPenalty,0.0)  AS CancellationMarkup, Format(cast(t1.CancelledDate as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us') CancelledDate,isnull(u.UserName,br.AgencyName) UserName,
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName, t2.frmSector,t2.toSector,pid,isnull(T1.CancellationServiceFee,0) CancellationServiceFee
  from
 tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
 left join [mUser] u on u.id=t1.CancelByBackendUser1
 left join B2BRegistration br on br.FKUserID=t1.CancelByAgency1
where  t2.orderId=@NewOrderID and t1.RemarkCancellation2 is not null  --and t1.CancellationPenalty>0 and t1.CancellationMarkup>0
order by pid asc



--payment details
--declare @BasicB2BMARKUP decimal(18,2)=0
--declare @TaxB2BMARKUP decimal(18,2)=0
--if exists(select top 1 * from tblBookMaster where orderId=@NewOrderID and B2bFareType=1)
--begin
--set @BasicB2BMARKUP=(select top 1 ISNULL(tp.B2BMarkup,0) from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where orderId=@NewOrderID)
--end
--else if exists(select top 1 * from tblBookMaster where orderId=@NewOrderID and (B2bFareType=2 or B2bFareType=3))
--begin
--set @TaxB2BMARKUP=(select top 1 ISNULL(tp.B2BMarkup,0) from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where orderId=@NewOrderID)
--end

select tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,
--distinct
case when c.CurrencyCode != @Currency then sum(cast((tP.basicFare *tb.AgentROE* tb.ROE) as decimal(10,2)) + CASE WHEN tb.B2bFareType = 1 then tp.B2bMarkup else 0 end) 
	else sum(cast((tp.basicFare * tb.ROE) as decimal(10,2)) + CASE WHEN tb.B2bFareType=1 then CAST(tp.B2bMarkup AS Decimal(18, 2)) else 0 end) end basicFare

,case when c.CurrencyCode!=@Currency then
sum(cast((tp.totalTax *tb.AgentROE * tb.ROE)+ (CASE WHEN tb.B2bFareType!=1 then tp.B2bMarkup else 0 end + isnull(tp.ServiceFee,0) + isnull(tp.gst,0)+ isnull(tp.HupAmount,0) --+ isnull(tb.ServiceFee,0) + isnull(tb.gst,0) 
+ isnull(tp.BFC,0)) *tb.AgentROE  as decimal(10,2))) else sum(cast(tp.totalTax * tb.ROE + (CASE WHEN tb.B2bFareType!=1 then tp.B2bMarkup else 0 end + isnull(tp.ServiceFee,0) + isnull(tp.gst,0)+ isnull(tp.HupAmount,0) --+ isnull(tb.ServiceFee,0) + isnull(tb.gst,0) 
+ isnull(tp.BFC,0))  as decimal(10,2))) end totalTax

,case when c.CurrencyCode !=@Currency then
sum(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2))) --+   isnull(tp.MCOAmount,0) +  isnull(tp.Markup,0)
+ isnull(tp.BFC,0) + isnull(tp.B2BMarkup,0) + isnull(tp.ServiceFee,0) + isnull(tp.gst,0) + isnull(tp.HupAmount,0)--+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0) 
else sum(cast((tp.totalFare) * tb.ROE as decimal(10,2))) --+ isnull(tp.MCOAmount,0) + isnull(tp.Markup,0) 
+ isnull(tp.BFC,0) + isnull(tp.B2BMarkup,0) + isnull(tp.ServiceFee,0) + isnull(tp.gst,0) + isnull(tp.HupAmount,0)--+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0)
end totalFare

,(CASE WHEN c.CurrencyCode!=@Currency 
		THEN SUM(CAST((tp.totalTax * tb.AgentROE * tb.ROE) + (CASE WHEN tb.B2bFareType != 1 THEN tp.B2bMarkup ELSE 0 END + ISNULL(tp.HupAmount,0)
			+ ISNULL(tp.BFC,0)) * tb.AgentROE AS DECIMAL(10,2)))
		ELSE SUM(CAST(tp.totalTax * tb.ROE + (CASE WHEN tb.B2bFareType != 1 THEN tp.B2bMarkup ELSE 0 END + ISNULL(tp.HupAmount,0) + ISNULL(tp.BFC,0)) AS DECIMAL(10,2))) 
	END) AS TotalTaxWithoutServiceFee

, (CASE WHEN c.CurrencyCode != @Currency 
		THEN SUM(CAST((tp.totalFare) * tb.AgentROE * tb.ROE AS DECIMAL(10,2))) + ISNULL(tp.BFC,0) + ISNULL(tp.B2BMarkup,0) + ISNULL(tp.HupAmount,0) 
		ELSE SUM(CAST((tp.totalFare) * tb.ROE AS DECIMAL(10,2))) + ISNULL(tp.BFC,0) + ISNULL(tp.B2BMarkup,0) + ISNULL(tp.HupAmount,0)
	END) AS TotalFareWithoutServiceFee

,case when c.CurrencyCode !=@Currency then
sum(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (isnull(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (isnull(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
else sum(ISNULL(cast(  (isnull(tp.RescheduleMarkup,0)* tb.ROE ) +  (isnull(tp.reScheduleCharge,0)* tb.ROE ) + (isnull(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) end ReschedulePenalty
,c.CurrencyCode, tp.isReturn,
case when c.CurrencyCode !=@currency then 
cast((tp.JNTax *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.JNTax * tb.ROE) as decimal(10,2)) end JNTax
,case when c.CurrencyCode !=@currency then 
cast((tp.YQ *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.YQ * tb.ROE) as decimal(10,2)) end YQTax

--bansi

,case when c.CurrencyCode !=@currency then 
cast((tp.ServiceCharge *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.ServiceCharge * tb.ROE) as decimal(10,2)) end ServiceCharge
,case when c.CurrencyCode !=@currency then 
cast((tp.YRTax *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.YRTax * tb.ROE) as decimal(10,2)) end YRTax
,case when c.CurrencyCode !=@currency then 
cast((tp.INTax *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.INTax * tb.ROE) as decimal(10,2)) end INTax
,case when c.CurrencyCode !=@currency then 
cast((tp.OCTax *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.OCTax * tb.ROE) as decimal(10,2)) end OCTax
--,case when c.CurrencyCode !=@currency then 
--cast((tp.ExtraTax *tb.AgentROE* tb.ROE) as decimal(10,2)) else cast((tp.ExtraTax * tb.ROE) as decimal(10,2)) end ExtraTax

,Case when c.CurrencyCode !=@Currency then
cast((isnull(tp.ExtraTax ,0) *tb.AgentROE * tb.ROE) as decimal(10,2))
else
cast((isnull(tp.ExtraTax ,0) * tb.ROE ) as decimal(10,2)) End ExtraTax

,case when c.CurrencyCode !=@currency then 
cast((tp.WOTax) as decimal(10,2)) else cast((tp.WOTax) as decimal(10,2)) end WOTax
,case when c.CurrencyCode !=@currency then 
cast((tp.B2BMarkup *tb.AgentROE) as decimal(10,2)) else cast((tp.B2BMarkup) as decimal(10,2)) end SC
,tp.RFTax
,tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FName

from tblBookMaster tb
left join tblPassengerBookDetails tp on tp.fkBookMaster=tb.pkId
 left join mCountryCurrency c on c.CountryCode=tb.Country
where orderId=@NewOrderID  and (tb.totalFare>0 or (isnull(tb.PreviousRiyaPNR,'')!=''))
group by c.CurrencyCode,tp.MCOAmount,tp.Markup,tb.ServiceFee,tb.GST,tp.BFC, tb.ReissueCharges,  tp.title, tp.paxFName , tp.paxLName , paxType,tp.BaggageFare, tp.isReturn,tp.B2BMarkup --,SSR.FKBOOKMASTER,SSR.SSR_Amount,riyaPNR
,tp.ServiceFee, tp.GST,HupAmount,tp.JNTax,AgentROE,ROE,tp.YQ,
tp.serviceCharge, tp.YRTax,tp.INTax,tp.OCTax,tp.ExtraTax,tp.WOTax,tp.B2BMarkup,tp.RFTax,tp.paxFName , tp.paxLName , paxType 

--status cancellation
Declare @TotalPasscount int
Declare @CancelledPasscount int

set @TotalPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.orderId=@NewOrderID)

set @CancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster
WHERE   t2.orderId=@NewOrderID and t1.BookingStatus=4)

if(@TotalPasscount=@CancelledPasscount)
begin
select top 1 BookingStatus from tblBookMaster where orderId=@NewOrderID ORDER BY pkId desc
end
else
begin
select top 1 BookingStatus from tblBookMaster where orderId=@NewOrderID ORDER BY pkId desc
end


--booking details
select top 1 
Format(cast(isnull(tb.inserteddate_old,tb.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as BookingDate,
pm.payment_mode,
isnull(u.FullName,ag.UserName) FullName,
case when tb.MainAgentId>=0 and tb.BookingSource='Web' then 'Internal Booking (Web)'
			--afifa	
	      	when tb.MainAgentId>0 and tb.BookingSource='ManualTicketing' then 'Manual Booking'	
			 	when tb.MainAgentId>0 and tb.BookingSource='Retrieve PNR accounting' then 'PNR accounting'
				when tb.MainAgentId>0 and tb.BookingSource='Retrive PNR - MultiTST' then 'Retrive PNR - MultiTST'
				when tb.MainAgentId>0 and tb.BookingSource='Retrive PNR Accounting' then 'Internal Booking (Retrive PNR Accounting)'

			when tb.MainAgentId>=0 and tb.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
			when tb.MainAgentId=0 and tb.BookingSource='Web' then 'Agent Booking (Web)'
			when tb.MainAgentId=0 and tb.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
			when tb.MainAgentId>0 and tb.BookingSource='Retrieve PNR accounting - MultiTST' then 'Retrieve PNR accounting - MultiTST'	
			when tb.MainAgentId=0 and tb.BookingSource='Retrive PNR Accounting' then  'Agent Booking (Retrive PNR Accounting)'	
			when tb.MainAgentId=0 and tb.BookingSource='GDS' then  'TJQ'
			end  as BookingType 

,case when TicketingPCC!='' then TicketingPCC else OfficeID end BookingTicketingSupplier
,isnull(u.UserName,0) ID
,ISNULL(U.ID,0) UserId
,(SELECT top 1  
   STUFF((SELECT '/' + bm.FareType 
          FROM tblBookMaster bm
          WHERE bm.riyaPNR = b.riyaPNR order by BM.pkId ASC
          FOR XML PATH('')), 1, 1, '') [FareType]
FROM tblBookMaster b
where orderId = @NewOrderID and b.returnFlag=0
Group by b.riyaPNR,b.GDSPNR) FareType

from tblBookMaster tb
left join [dbo].[Paymentmaster] pm on pm.order_id=tb.orderid
left join agentLogin ag on ag.UserID=tb.AgentID
left join [mUser] u on u.id=tb.BookedBy
where tb.orderId=@NewOrderID order by tb.pkId desc


--pax type distinct	
select distinct	
t1.paxType	
--,'' as MarkupId	
 from tblPassengerBookDetails t1	
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster	
  left join AirlinesName a2 on a2._CODE=t2.airCode	
where  t2.orderId=@NewOrderID  order by paxType asc	



--BAGGEGE DETAILS FROM SSR TABLE
select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		, SSR_Type
		, isnull(ssr.SSR_Name,'') SSR_Name
		, (CASE WHEN c.CurrencyCode!=@Currency THEN CAST(SUM(ISNULL(SSR.SSR_Amount,0)) * (tb.AgentROE * tb.ROE) AS DECIMAL(10,2)) 
				ELSE CAST(SUM(ISNULL(SSR.SSR_Amount,0)) *(tb.ROE) as decimal(10,2))
			END) AS SSR_Amount
		, tp.paxType
		, pid 
FROM tblPassengerBookDetails tp
INNER JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid
INNER JOIN tblBookMaster tb on tb.pkid=tp.fkBookMaster
LEFT JOIN mCountryCurrency c on c.CountryCode=tb.Country
WHERE  tb.orderId=@NewOrderID and SSR_Type='Baggage'
GROUP BY TP.paxFName,paxLName,paxType,SSR_Type,SSR_Name,CurrencyCode,AgentROE,ROE,pid
ORDER BY tp.pid, tp.paxType


--if(select count(0) cnt from tblBookMaster where orderId=@NewOrderID and bookingsource='Retrive PNR Accounting' and (airName='Indigo' or airName='Spicejet' or airName='GO FIRST'))>0
--begin
--		Select Distinct  tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName, tp.baggage ,tp.paxType, tp.pid, tp.isreturn,
--		 case when c.CurrencyCode!=@Currency then
--cast((isnull(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) as decimal(10,2))
-- else cast((isnull(SSR.SSR_Amount,0)) *(tb.ROE) as decimal(10,2))
-- end SSR_Amount,
--		CASE WHEN tp.isReturn=1 and tp.paxType='ADULT' then  Replace(isnull(tp.baggage,0),'kg','') 
--		 WHEN tp.isReturn=1 and tp.paxType='CHILD' then Replace(isnull(tp.baggage,0),'kg','') 
--		 WHEN tp.isReturn=1 and tp.paxType='INFANT' then Replace(isnull(tp.baggage,0),'kg','') 
--		 Else Replace(isnull(tp.baggage,0),'kg','') 
--		 end PassengerBaggageTotal ,SSR_Type ,
--		 tp.pid, tb.BookingSource ,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
--		 from tblPassengerBookDetails tp
--		 left join tblBookMaster tb on tb.pkId=tp.fkBookMaster
--		 left join tblSSRDetails SSR on SSR.fkpassengerid=tp.pid
--		 left join mCountryCurrency c on c.CountryCode=tb.Country
--		where  tb.orderId=@NewOrderID 
--		order by tp.paxType ,FullName asc
	
--end
--else
--begin
--if exists(select top 1 * from tblSSRDetails s1 where s1.fkpassengerid in(select pid from tblPassengerBookDetails where fkBookMaster in(select pkid from tblBookMaster where riyaPNR=@RiyaPNR)) )
-- begin
-- select distinct tp.baggage,--ssr.SSR_Type,ISNULL(ssr.SSR_Name,'') SSR_Name,
-- --ISNULL(ssr.SSR_Amount,0) SSR_Amount,
-- case when c.CurrencyCode!=@Currency then
--cast(sum(isnull(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) as decimal(10,2))
-- else cast(sum(isnull(SSR.SSR_Amount,0)) *(tb.ROE) as decimal(10,2))
-- end SSR_Amount,
-- SSR_Type,
--tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
--tp.paxType, tp.pid
--,sum(CAST(dbo.udf_GetNumeric(isnull(ssr.SSR_Name,0)) as int) + cast(dbo.udf_GetNumeric(isnull(tp.baggage,0)) as int))  as PassengerBaggageTotal
--,tp.isreturn
--,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
--,pid
--from tblPassengerBookDetails tp
--inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid
--inner join tblBookMaster tb on tb.pkid=tp.fkBookMaster
--left join mCountryCurrency c on c.CountryCode=tb.Country
--where  tb.orderId=@NewOrderID and SSR_Type='baggage'
--group by title,paxFName,paxLName,paxType,tp.baggage,isReturn, SSR_Amount,tp.pid, SSR_Type,CurrencyCode,AgentROE,ROE --,SSR_Name,SSR_Type
----and ssr.SSR_Amount>=0
--order by tp.paxType,FullName,tp.pid

--end
--else

--begin
--select
--tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,tp.baggage --,'' as SSR_Type,'' as SSR_Name,'0' as SSR_Amount
--,tp.paxType, tp.pid
--,cast(dbo.udf_GetNumeric(isnull(REPLACE(tp.baggage,'1 Piece',''),0)) as int)  as PassengerBaggageTotal
--,tp.isreturn, 0 as SSR_Amount, '' SSR_Type
--,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
--from
--tblPassengerBookDetails tp
-- left join tblBookMaster tb on tb.pkid=tp.fkBookMaster
--where  tb.orderId=@NewOrderID
----group by title,paxFName,paxLName,paxType,tp.baggage,isReturn
--order by tp.paxType
--end
--end

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
where  t2.orderId=@NewOrderID  --and r1.Status in(7,8)--and t1.isReturn=0


--Old PNR  payment details


select tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName, tp.isReturn,

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
--(ISNULL(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2)),0)) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0)  + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0) else --sum
--(ISNULL(cast((tp.totalFare) * tb.ROE as decimal(10,2)),0)) +   isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0) end totalFare
(ISNULL(cast((tp.totalFare) * tb.AgentROE * tb.ROE  +   (isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0)  + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0)) as decimal(10,2)),0)) else --sum
(ISNULL(cast((tp.totalFare) * tb.ROE +   (isnull(tb.MCOAmount,0) +  isnull(tb.AgentMarkup,0) + isnull(tb.ServiceFee,0) + isnull(tb.GST,0) + isnull(tb.BFC,0)  + isnull(tb.ReissueCharges,0))  as decimal(10,2)),0)) end totalFare

, (CASE WHEN c.CurrencyCode != @Currency 
		THEN (ISNULL(CAST(((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.AgentROE * tb.ROE)+ (ISNULL(tb.B2BMarkup,0) + ISNULL(tb.BFC,0)) * tb.AgentROE  AS DECIMAL(10,2)),0)) 
		ELSE (ISNULL(CAST((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.ROE + (ISNULL(tp.B2BMarkup,0) + ISNULL(tb.BFC,0))  AS DECIMAL(10,2)),0)) 
	END) AS TotalTaxWithoutServiceFee

, (CASE WHEN c.CurrencyCode != @Currency 
		THEN (ISNULL(CAST((tp.totalFare) * tb.AgentROE * tb.ROE  +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0)) 
		ELSE (ISNULL(CAST((tp.totalFare) * tb.ROE +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0)) 
	END) TotalFareWithoutServiceFee
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
where tb.riyaPNR= (select top 1 PreviousRiyaPNR from tblBookMaster where orderId= @NewOrderID) 
and isnull(tp.reScheduleCharge,0) = 0 and tb.totalFare>0

--MEAL DETAILS FROM SSR TABLE		 
 select tp.baggage,ssr.SSR_Type,ISNULL('Meal-'+ SSR.SSR_Code +'/','') as SSR_Name, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
case when c.CurrencyCode!=@Currency then
cast(isnull(SSR.SSR_Amount,0) *(tb.AgentROE * tb.ROE)  as decimal(10,2))
 else cast(isnull(SSR.SSR_Amount,0) * tb.ROE  as decimal(10,2))
 end SSR_Amount,
  tp.paxType			
 		
   from tblPassengerBookDetails tp		
 inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid	
 inner join tblBookMaster tb on tb.pkid=SSR.fkBookMaster
 left join mCountryCurrency c on c.CountryCode=tb.Country
where  tb.orderId=@NewOrderID and SSR_Type='Meals' --and ssr.SSR_Amount>0 
AND isReturn = 0 -- JD || 09.03.2023


--tblSSRDetails BAGAGE FARE 
SELECT 
case when c.CurrencyCode!=@Currency then
sum(isnull(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) 
 else sum(isnull(SSR.SSR_Amount,0)) *(tb.ROE)
 end SSR_Amount

FROM tblBookMaster tb
LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=TB.pkId
 left join mCountryCurrency c on c.CountryCode=tb.Country
WHERE orderId=@NewOrderID and ssr.SSR_Type='Baggage'
group by c.CurrencyCode,tb.AgentROE,tb.ROE

--Net fare calculation
select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName

,case when c.CurrencyCode !=@Currency then
sum(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2))) +   isnull(tp.MCOAmount,0) +  isnull(tp.Markup,0) + isnull(tp.BFC,0) +isnull(tp.B2BMarkup,0) 
else sum(cast((tp.totalFare) * tb.ROE as decimal(10,2))) +   isnull(tp.MCOAmount,0) +  isnull(tp.Markup,0) + isnull(tp.BFC,0) +isnull(tp.B2BMarkup,0) end totalFare

--,sum(isnull(tp.DiscountTDS,0)) DiscountTDS
--,sum(isnull(tp.DiscountGST,0)) DiscountGST
,sum(isnull(TP.IATACommission,0) + isnull(TP.PLBCommission,0) + isnull(TP.DropnetCommission,0)) TotalCommission

,isnull(tp.IATACommission,0) IATACommission
,isnull(tp.PLBCommission,0) PLBCommission
,isnull(tp.DropnetCommission,0) DropnetCommission
,isnull(tp.ServiceFee,0) ServiceFee
--,CAST(isnull(tb.ServiceFee,0) / (Select count(*) from tblPassengerBookDetails where fkBookMaster IN (Select pkId From tblbookmaster where riyaPNR = @RiyaPNR AND totalFare >0)) as decimal(10,2)) ServiceFee
,isnull(tp.GST,0) GST
,isnull(tp.HupAmount,0) HupAmount

from tblPassengerBookDetails tp
left join tblBookMaster tb on tb.pkid=tp.fkBookMaster
 left join mCountryCurrency c on c.CountryCode=tb.Country
where orderId=@NewOrderID AND TP.totalFare >0
GROUP BY TP.paxFName,TP.paxLName,TP.paxType,C.CurrencyCode
,TP.MCOAmount,TP.Markup,TB.BFC,TP.B2BMarkup,tp.IATACommission,tp.PLBCommission,tp.DropnetCommission,tP.ServiceFee,TP.GST, tp.BFC,HupAmount
 order by tP.paxType,FullName asc

 --TAX DESCRIPTION STRING
select 
case when c.CurrencyCode !=@Currency then

'ServiceCharge: ' + convert(varchar(20), cast((sum(ServiceCharge) *t.AgentROE * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(sum(YRTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(sum(INTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(sum(JNTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(sum(OCTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(sum(ExtraTax) ,0)*t.AgentROE * t.ROE + ISNULL(RFTax, 0) ) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(sum(YQTax) ,0)*t.AgentROE * t.ROE ) as decimal(10,2)))
	+   ';WOTax :' + convert(varchar(20), cast((isnull(WOTax ,0)  ) as decimal(10,2)))
		+   ';SC :' + convert(varchar(20), cast((isnull(sum(B2BMarkup) ,0)*t.AgentROE  ) as decimal(10,2))) 
		+  isnull(case when ServiceFee>0 and @MainAgentId=0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)) as decimal(10,2))) end,'')
		+  isnull(case when GST>0 and @MainAgentId=0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)) as decimal(10,2))) end,'')
	
	ELSE
	'ServiceCharge: ' + convert(varchar(20), cast((sum(ServiceCharge) * t.ROE ) as decimal(10,2)))+ ';YRTax:' + convert(varchar(20), cast((isnull(sum(YRTax) ,0) * t.ROE ) as decimal(10,2)))   
	+  ';INTax:' + convert(varchar(20), cast((isnull(sum(INTax) ,0) * t.ROE ) as decimal(10,2))) + ';JNTax:' +  convert(varchar(20), cast((isnull(sum(JNTax) ,0) * t.ROE ) as decimal(10,2)))
	 +  ';OCTax :' +  convert(varchar(20), cast((isnull(sum(OCTax) ,0) * t.ROE ) as decimal(10,2))) + ';ExtraTax:' + convert(varchar(20), cast((isnull(sum(ExtraTax) ,0) * t.ROE + ISNULL(RFTax, 0)) as decimal(10,2))) 
	+   ';YQTax:' + convert(varchar(20), cast((isnull(sum(YQTax) ,0) * t.ROE ) as decimal(10,2))) 
	+   ';WOTax :' + convert(varchar(20), cast((isnull(WOTax ,0)  ) as decimal(10,2)))
	+   ';SC :' + convert(varchar(20), cast((isnull(sum(B2BMarkup) ,0)  ) as decimal(10,2)))
		+  isnull(case when ServiceFee>0 and @MainAgentId=0 then ';Service Fee :' + convert(varchar(20), cast((isnull(ServiceFee ,0)) as decimal(10,2))) end,'')
	+  isnull(case when GST>0 and  @MainAgentId=0 then ';GST :' + convert(varchar(20), cast((isnull(GST ,0)  ) as decimal(10,2))) end,'')

	 end taxdesc



from tblBookMaster t

left join mCountryCurrency c on c.CountryCode=t.Country
where t.orderId=@NewOrderID
group by CurrencyCode ,AgentROE,roe,ServiceFee,GST, WOTax, RFTax


--Passenger details for new print copy
--declare @BasicB2BMARKUP1 decimal(18,2)=0
--declare @TaxB2BMARKUP1 decimal(18,2)=0
--if exists(select top 1 * from tblBookMaster where riyaPNR='' and B2bFareType=1)
--begin
--set @BasicB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where orderId=@NewOrderID)
--end
--else if exists(select top 1 * from tblBookMaster where orderId=@NewOrderID and (B2bFareType=2 or B2bFareType=3))
--begin
--set @TaxB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where orderId=@NewOrderID)
--end


select  
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
case when c.CurrencyCode !=@Currency then
sum(cast((t1.basicFare *t2.AgentROE* t2.ROE+isnull(t1.Markup,0)) as decimal(10,2))+(CASE WHEN t2.B2bFareType=1 then t1.B2bMarkup else 0 end)) else sum(cast((t1.basicFare * t2.ROE+ isnull(t1.Markup,0)) as decimal(10,2))+CASE WHEN t2.B2bFareType=1 then t1.B2bMarkup else 0 end) end basicFare
,t1.GST
,case when c.CurrencyCode!=@Currency then
sum(cast((t1.totalTax *t2.AgentROE * t2.ROE)+ (CASE WHEN t2.B2bFareType!=1 then t1.B2bMarkup else 0 end + isnull(t1.ServiceFee,0) + isnull(t1.gst,0) + isnull(t1.HupAmount,0) 
+ isnull(t1.BFC,0)) *t2.AgentROE  as decimal(10,2))) else sum(cast(t1.totalTax * t2.ROE + (CASE WHEN t2.B2bFareType!=1 then t1.B2bMarkup else 0 end + isnull(t1.ServiceFee,0) + isnull(t1.HupAmount,0) + isnull(t1.gst,0) 
+ isnull(t1.BFC,0))  as decimal(10,2))) end totalTax

,case when c.CurrencyCode !=@Currency then
sum(cast((t1.totalFare) * t2.AgentROE * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0) + isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0) + isnull(t1.ServiceFee,0) + isnull(t1.gst,0) + isnull(t1.HupAmount,0)  --+ isnull(t2.ServiceFee,0) + isnull(t2.GST,0) 

 else sum(cast((t1.totalFare) * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0)  + isnull(t1.HupAmount,0)+ isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0) + isnull(t1.ServiceFee,0) + isnull(t1.gst,0)  --+ isnull(t2.ServiceFee,0) + isnull(t2.GST,0) 
end totalFare

, (CASE WHEN c.CurrencyCode!=@Currency 
		THEN SUM(CAST((t1.totalTax *t2.AgentROE * t2.ROE) + (CASE WHEN t2.B2bFareType!=1 THEN t1.B2bMarkup ELSE 0 END + ISNULL(t1.HupAmount,0) + ISNULL(t1.BFC,0)) * t2.AgentROE  AS DECIMAL(10,2))) 
		ELSE SUM(CAST(t1.totalTax * t2.ROE + (CASE WHEN t2.B2bFareType != 1 THEN t1.B2bMarkup ELSE 0 END + ISNULL(t1.HupAmount,0) + ISNULL(t1.BFC,0))  AS DECIMAL(10,2))) 
	END) AS TotalTaxWithoutServiceFee

, (CASE WHEN c.CurrencyCode != @Currency 
		THEN SUM(CAST((t1.totalFare) * t2.AgentROE * t2.ROE AS DECIMAL(10,2))) + ISNULL(t1.Markup,0) + ISNULL(t1.BFC,0) + ISNULL(t1.B2BMarkup,0) + ISNULL(t1.HupAmount,0)
		ELSE SUM(CAST((t1.totalFare) * t2.ROE AS DECIMAL(10,2)))+ ISNULL(t1.Markup,0)  + ISNULL(t1.HupAmount,0)+ ISNULL(t1.BFC,0) +ISNULL(t1.B2BMarkup,0)
	END) AS TotalFareWithoutServiceFee

,(CASE WHEN CHARINDEX('/',ticketNum)>0   
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
ELSE ticketNum END )as 'TicketNumber', 
CASE when t1.isReturn=0 then 'Single' else 'Return' end Journey,   
case   
when t2.BookingStatus=2 then 'Hold'  
WHEN t1.BookingStatus=6  THEN 'To Be Cancelled'   
WHEN t1.BookingStatus=4  THEN 'Cancelled'   
when t2.BookingStatus=0 then 'Failed'  
when t2.BookingStatus=14 then 'Open Ticket'  
when t1.BookingStatus is null AND T2.IsBooked=1 then 'Confirmed'  
 when t2.BookingStatus=1 AND T2.IsBooked=1 then  'Confirmed'  
when t2.BookingStatus=2 then 'Hold'  
when t2.BookingStatus=3 then 'Pending'  
when t2.BookingStatus=4 then 'Cancelled'  
when t2.BookingStatus=5 then 'Close'  
when t2.BookingStatus=11 then 'Cancelled'  
when t2.BookingStatus=12 then 'In-Process' 
WHEN t2.BookingStatus=13 THEN 'TJQ Pending'
when t1.BookingStatus is null then 'Confirmed'  
End Status,  
CASE WHEN t2.returnFlag=1 and t1.paxType='ADULT' then t1.baggage+'/'+t1.baggage   
 WHEN t2.returnFlag=1 and t1.paxType='CHILD' then t1.baggage+'/'+t1.baggage   
 --WHEN t2.isReturnJourney=1 and t1.paxType='INFANT' then t1.baggage+'/'+t1.baggage   
 WHEN t2.returnFlag=0 and t1.paxType='ADULT' then t1.baggage   
 WHEN t2.returnFlag=0 and t1.paxType='CHILD' then t1.baggage   
 WHEN t1.paxType='INFANT' then cast(dbo.udf_GetNumeric(isnull(t1.baggage,0)) as varchar(30)) +' Kg'
 end baggage,  
T1.isReturn ,  
t1.paxType,
pid,
case when c.CurrencyCode !=@currency then 
cast((t1.JNTax *t2.AgentROE* t2.ROE) as decimal(10,2)) else cast((t1.JNTax * t2.ROE) as decimal(10,2)) end JNTax

,case when c.CurrencyCode !=@Currency then
CAST((t1.YQ *t2.AgentROE* t2.ROE) as decimal(10,2)) else CAST((t1.YQ * t2.ROE) as decimal(10,2)) end YQTax

,isnull(t1.FrequentFlyNo,'') FrequentFlyNo
  ,paxFName
  ,paxLName
--, CASE WHEN t1.BarCode IS NULL THEN '' ELSE t1.BarCode END AS BarCode
, CASE WHEN BarCode IS NULL THEN '' 
		ELSE (SELECT STUFF((SELECT '^' + BarCode 
					FROM tblPassengerBookDetails PB 
					LEFT JOIN tblBookMaster t2 ON t2.pkId=PB.fkBookMaster 
					WHERE t2.riyaPNR = @RiyaPNR AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
					FOR XML PATH('')
				), 1, 1, ''))
		END AS BarCode
, ISNULL(PassengerID, '') AS PassengerID -- Added By JD 20.01.2022
 from tblPassengerBookDetails t1  
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster  
  left join AirlinesName a2 on a2._CODE=t2.airCode  
  left join mCountryCurrency c on c.CountryCode=t2.Country
where  t2.orderId=@NewOrderID  and (t1.isReturn=0 or (t1.isReturn=1 and (select count(pkId) from tblBookMaster where orderId=@NewOrderID) =1))and  
(t1.totalFare>0 or (isnull(t2.PreviousRiyaPNR,'')!=''))  
--and isReturnJourney=0
group by title,paxFName,paxLName,paxType,ticketNum,isReturn,t2.BookingStatus,t1.BookingStatus,t2.IsBooked,c.CurrencyCode
,t1.Markup,t1.bfc,t1.B2BMarkup,t1.GST,t1.ServiceFee,t1.HupAmount,t2.returnFlag,t1.baggage,t1.pid,t1.JNTax,FrequentFlyNo,t2.ROE,t2.AgentROE
,T1.YQ, t1.BarCode, PassengerID
order by t1.paxType,FullName asc

--SSR Seats 
select ssr.SSR_Type,ssr.SSR_Name, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
case when c.CurrencyCode!=@Currency then
cast(isnull(SSR.SSR_Amount,0) *(tb.AgentROE * tb.ROE)  as decimal(10,2))
 else cast(isnull(SSR.SSR_Amount,0) * tb.ROE  as decimal(10,2))
 end SSR_Amount,  tp.paxType			
 		
   from tblPassengerBookDetails tp		
 inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid	
 inner join tblBookMaster tb on tb.pkid=SSR.fkBookMaster
 left join mCountryCurrency c on c.CountryCode=tb.Country
where  tb.orderId=@NewOrderID and SSR_Type='Seat' 
--AND isReturn = 0 -- JD || 09.03.2023

--Flight Details Marine ticket copy Viewpnr
select 
tbi.flightNo
,convert(varchar(7), tbi.depDate, 106) depDateMarine
,convert(varchar(7), tbi.arrivalDate, 106) arrivalDateMarine
,SUBSTRING(tbi.fromAirport, 0, charindex('[', tbi.fromAirport, 0)) fromAirportMarine
,SUBSTRING(tbi.toAirport, 0, charindex('[', tbi.toAirport, 0)) toAirportMarine
,CONVERT(VARCHAR(5),tbi.deptTime,108) AS deptTimeMarine
,CONVERT(VARCHAR(5),tbi.arrivalTime,108) AS arrivalTimeMarine
,tbi.fromTerminal
,tbi.toTerminal
,tb.riyaPNR
,tbi.airCode,
tbi.airName, 
upper(substring(DATENAME(weekday,tbi.deptTime),1,3)) +','+FORMAT(CAST(tbi.deptTime AS datetime), 'dd MMMM yyyy') WholeDateMarine,
case when tb.BookingStatus=1 AND tb.IsBooked=1 then  'Confirmed'  
when tb.BookingStatus=2 then 'Hold'  
when tb.BookingStatus=3 then 'Pending'  
when tb.BookingStatus=4 then 'Cancelled'  
when tb.BookingStatus=5 then 'Close'  
when tb.BookingStatus=11 then 'Cancelled'  
when tb.BookingStatus=12 then 'In-Process' 
end Status
,tbi.fromAirport
,tbi.toAirport
,tbi.cabin
,CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, tbi.deptTime,tbi.arrivalTime), 0), 114) +' '+'Hrs.'  Traveldifference
,case when count(tb.pkid)=count(tbi.fkBookMaster) then 'Non-stop' end JourneyType
,tbi.farebasis
,tbi.airlinepnr as AirlinePNR
,FareType
, tb.VendorName, tb.TotalTime

from tblBookItenary tbi
left join tblBookMaster tb on tb.pkId=tbi.fkBookMaster
where tb.orderId=@NewOrderID
group by tbi.flightNo,tbi.depDate,tbi.arrivalDate,tbi.fromAirport,tbi.toAirport,tbi.deptTime,tbi.arrivalTime,tbi.fromTerminal,tbi.toTerminal
,tb.riyaPNR,tbi.airCode,tbi.airName,tb.BookingStatus,tb.IsBooked,tbi.cabin,tbi.farebasis,tbi.airlinePNR,FareType, tb.VendorName, tb.TotalTime
order by tbi.deptTime asc  

--AIEXpress PNR Accounting Baggage/Meal desc with SSR

if exists(select top 1 * from tblSSRDetails s1 where s1.fkpassengerid in(select pid from tblPassengerBookDetails where fkBookMaster in(select pkid from tblBookMaster where orderId=@NewOrderID)) )
 begin
 select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
 tp.baggage,
 tp.paxType,
 SSR_Type,
isnull(ssr.SSR_Name,tp.baggage) PassengerBaggageTotal
,tp.isreturn, 0 as SSR_Amount
,pid
,'' as ExtenstionBaggage
from tblPassengerBookDetails tp
inner JOIN tblSSRDetails SSR ON SSR.fkpassengerid=tp.pid
inner join tblBookMaster tb on tb.pkid=tp.fkBookMaster
where  tb.orderId=@NewOrderID and bookingsource='Retrive PNR Accounting' and airName='Air India Express' and (SSR_Type='baggage') and ssr.SSR_Amount>0
order by tp.paxType,FullName,pid

end
else

begin
select
tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,
tp.baggage 
,tp.paxType,
'' as SSR_Type
,cast(dbo.udf_GetNumeric(isnull(REPLACE(tp.baggage,'1 Piece',''),0)) as int)  as PassengerBaggageTotal
,tp.isreturn, 0 as SSR_Amount
,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
,pid
,isReturn
from
tblPassengerBookDetails tp
 left join tblBookMaster tb on tb.pkid=tp.fkBookMaster
where  tb.orderId=@NewOrderID and bookingsource='Retrive PNR Accounting' and airName='Air India Express'
order by tp.paxType
end


--AIEXpress PNR Accounting Baggage/Meal desc withOUT SSR
	Select 1, tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,
	tp.baggage ,tp.paxType, tp.pid, tp.isReturn, tb.BookingSource
	 from tblPassengerBookDetails tp
	 left join tblBookMaster tb on tb.pkId=tp.fkBookMaster
	where  tb.orderId=@NewOrderID and bookingsource='Retrive PNR Accounting' and airName='Air India Express'  
	order by tp.paxType ,FullName asc
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetDetailsforPrint] TO [rt_read]
    AS [dbo];

