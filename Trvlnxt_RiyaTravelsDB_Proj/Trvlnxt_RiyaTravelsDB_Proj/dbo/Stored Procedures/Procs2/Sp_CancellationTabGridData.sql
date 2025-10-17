--exec [Sp_CancellationTabGridData] '1D0JF5','USD'
CREATE Procedure [dbo].[Sp_CancellationTabGridData]
@RiyaPNR nvarchar(20)=null
,@Currency varchar(10)=null
,@AgentID int=null
,@CancellationType varchar(50)=null
as
begin

--above details
select distinct
t1.riyaPNR,
b.AgencyName,
b.AddrEmail,
t1.GDSPNR,
b.Icast as TerminalID,
tbi.airlinePNR,
b.AddrEmail,
t1.OfficeID as Supplier,
b.AddrMobileNo as PhoneNo,
t1.airName,
t1.ROE,
t1.Country,
ag.UserTypeID,
b.AddrAddressLocation +','+b.AddrCity +'-'+b.AddrZipOrPostCode as Address,
pm.payment_mode as PaymentMode

,ISNULL(ag.AgentBalance,0) AgentBalance


 from tblBookMaster t1
left join B2BRegistration b on b.FKUserID=t1.AgentID
left join tblBookItenary tbi on tbi.orderid=t1.orderid
left join  Paymentmaster pm on pm.order_id=t1.orderId
left join AgentLogin ag on ag.UserID=t1.AgentID 
--INNER join mUserCountryMapping cm on cm.UserId=t1.MainAgentId
where t1.riyaPNR=@RiyaPNR  AND t1.AgentID !='B2C'

--passenger grid
select
@RiyaPNR as BookingId,
t1.title +'.'+' '+ t1.paxFName +' '+t1.paxLName +' '+'('+t1.paxType +')' as FullName,
	(CASE WHEN CHARINDEX('/',ticketNum)>0 
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)))) 
ELSE ticketNum END )as 'TicketNumber',
t2.flightNo,
t2.frmSector,
Format(cast(t2.deptTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as deptTime,
t2.toSector,
Format(cast(t2.arrivalTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as arrivalTime,
--tbi.cabin as Class,
case when t1.BookingStatus=6 then 'To be Cancelled' else 'Confirmed' end  Status  


--,case when c.CurrencyCode !=@Currency then
--sum(cast((t1.basicFare *t2.AgentROE* t2.ROE+isnull(t2.AgentMarkup,0)) as decimal(10,2))) else sum(cast((t1.basicFare * t2.ROE+ isnull(t2.AgentMarkup,0)) as decimal(10,2))) end basicFare

--,case when c.CurrencyCode !=@Currency then
--sum(cast((t1.totalTax *t2.AgentROE * t2.ROE)+ isnull(t2.B2BMarkup,0) *t2.AgentROE  as decimal(10,2))) else sum(cast(t1.totalTax * t2.ROE + isnull(t2.B2BMarkup,0) as decimal(10,2))) end  totalTax

--,case when c.CurrencyCode !=@Currency then
--sum(cast(t1.totalFare * t2.AgentROE * t2.ROE as decimal(10,2))) else sum(cast(t1.totalFare * t2.ROE as decimal(10,2)))  end totalFare

,case when c.CurrencyCode !=@Currency then
(cast((t1.basicFare *t2.AgentROE* t2.ROE+isnull(t2.AgentMarkup,0)) as decimal(10,2))) else (cast((t1.basicFare * t2.ROE+ isnull(t2.AgentMarkup,0)) as decimal(10,2))) end basicFare

,case when c.CurrencyCode !=@Currency then
(cast((t1.totalTax *t2.AgentROE * t2.ROE)+ isnull(t1.B2BMarkup,0) *t2.AgentROE  as decimal(10,2))) else (cast(t1.totalTax * t2.ROE + isnull(t1.B2BMarkup,0) as decimal(10,2))) end  totalTax

,case when c.CurrencyCode !=@Currency then
(cast(t1.totalFare * t2.AgentROE * t2.ROE as decimal(10,2))) else (cast(t1.totalFare * t2.ROE as decimal(10,2)))  end totalFare


--,count(tbi.fkBookMaster) as Segment
--,ROW_NUMBER() OVER(Partition by t1.paxFName,t1.paxLName  ORDER BY t2.frmSector +''+t2.toSector asc) Segment
,ROW_NUMBER() OVER(Partition by t1.paxFName,t1.paxLName  ORDER BY t2.deptTime asc) Segment
,t1.pid
,c.CurrencyCode
,t2.pkid
,t1.isReturn
,isnull(t1.BookingStatus,0) BookingStatus,
t1.CancellationPenalty,        
t1.CancellationMarkup,
t1.MarkupOnTaxFare,
t1.MarkuponPenalty,
t1.CancellationServiceFee,
t1.RemarkCancellation2
	
 from tblPassengerBookDetails t1
 left join tblBookMaster t2 on t2.pkId=t1.fkBookMaster
  left join mCountryCurrency c on c.CountryCode=t2.Country
-- left join tblBookItenary tbi on tbi.fkBookMaster=t2.pkId
  left join AirlinesName a2 on a2._CODE=t2.airCode
where  t2.riyaPNR=@RiyaPNR  
 and (t1.BookingStatus=6 or @CancellationType='OnlineCancellation') and  t1.totalFare>0 
 --and t2.deptTime>=getdate() -- and t1.isReturn=0 --and t1.totalFare>0 and t2.totalFare>0 --and t1.isReturn=0

group by t1.title,t1.paxFName,t1.paxLName,t1.paxType,ticketNum,
t2.flightNo,
t2.frmSector,
t2.deptTime,
t2.toSector,
t2.arrivalTime,
--tbi.cabin,
t1.BookingStatus
,t1.basicFare
,t1.totalTax
,t1.totalFare
,t1.pid
,c.CurrencyCode
,t2.pkId
,isReturn
,t1.BookingStatus,
t1.CancellationPenalty,        
t1.CancellationMarkup,
t1.MarkupOnTaxFare,
t1.MarkuponPenalty,
t1.CancellationServiceFee,
t1.RemarkCancellation2,
t2.ROE,
t2.AgentMarkup,
t1.B2BMarkup,
t2.AgentROE
 order by 2,t2.deptTime asc 



 --TOTAL FARE
Declare @Total decimal
set @Total=(select TOP 1 tp.totalFare from tblPassengerBookDetails tp
left join tblBookMaster tb on tb.pkId=tp.fkBookMaster
where tb.riyaPNR=@RiyaPNR AND (tp.BookingStatus=6 or @CancellationType='OnlineCancellation')) 

if(@Total=0)
begin
select  
case when c.CurrencyCode !=@Currency then
sum(cast(t1.totalFare * t2.AgentROE * t2.ROE as decimal(10,2))) else sum(cast(t1.totalFare * t2.ROE as decimal(10,2)))  end totalFare
FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster 
left join mCountryCurrency c on c.CountryCode=t2.Country
WHERE   t2.riyaPNR=@RiyaPNR --AND t1.BookingStatus=6 
GROUP BY CurrencyCode
end

else
begin
select  
case when c.CurrencyCode !=@Currency then
sum(cast(t1.totalFare * t2.AgentROE * t2.ROE as decimal(10,2))) else sum(cast(t1.totalFare * t2.ROE as decimal(10,2)))  end totalFare
FROM    tblPassengerBookDetails t1 
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster 
left join mCountryCurrency c on c.CountryCode=t2.Country
WHERE   t2.riyaPNR=@RiyaPNR AND (t1.BookingStatus=6 or @CancellationType='OnlineCancellation')
GROUP BY CurrencyCode
end
 

--Agency Balance
Select top 1 ISNULL(ag.AgentBalance,0) Agencybalance,tb.AgentID  from AgentLogin ag 
left join tblBookMaster tb on tb.AgentID=ag.UserID
where ag.userid=@AgentID

--Total Flight Fare
select CASE WHEN c.CurrencyCode !=tb.AgentCurrency then
totalfare*agentroe*roe else totalFare*roe end totalFare from tblbookmaster tb 
left join mCountryCurrency c on c.CountryCode=tb.Country
where riyapnr=@RiyaPNR

--travel class
select top 1 cabin as Travelclass,ac.type as Airlinetype,
convert(varchar(30),tb.IssueDate,103) IssueDate,
convert(varchar(30),getdate(),103) TodayDate,tb.VendorName,tb.isReturnJourney

 from tblBookItenary tbi
left join tblBookMaster tb on tb.pkId=tbi.fkBookMaster
left join AirlineCode_Console ac on ac.AirlineCode=tb.airCode
where tb.riyaPNR=@RiyaPNR

--Baggage fare SSR
SELECT   tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,
ssr.SSR_Type,
--sum(SSR_Amount) SSR_Amount
case when c.CurrencyCode !='UDS' then
sum(cast(isnull(SSR.SSR_Amount,0) * TB.AgentROE * TB.ROE as decimal(10,2))) else sum(cast(isnull(SSR.SSR_Amount,0) * TB.ROE as decimal(10,2)))  end SSR_Amount

FROM tblPassengerBookDetails TP 
LEFT JOIN tblSSRDetails SSR ON SSR.fkPassengerid=TP.pid
LEFT JOIN tblBookMaster TB ON TB.PKID=TP.fkBookMaster
left join mCountryCurrency c on c.CountryCode=TB.Country
WHERE RIYAPNR=@RiyaPNR AND SSR_Type='Baggage' and (tp.BookingStatus=6 or @CancellationType='OnlineCancellation')
group by title,paxFName,paxLName,paxType,SSR_Type,CurrencyCode

--Meal fare SSR
SELECT  tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,ssr.SSR_Type,sum(isnull(SSR_Amount,0)) SSR_Amount
FROM tblPassengerBookDetails TP 
LEFT JOIN tblSSRDetails SSR ON SSR.fkPassengerid=TP.pid
LEFT JOIN tblBookMaster TB ON TB.PKID=TP.fkBookMaster
WHERE RIYAPNR=@RiyaPNR AND SSR_Type='Meals'  and (tp.BookingStatus=6 or @CancellationType='OnlineCancellation')
group by title,paxFName,paxLName,paxType,SSR_Type

--Total SSR fare (total baggage fare+ total Meal fare)
select 
sum(isnull(SSR_Amount,0)) TotalSSR_Amount 
from tblBookMaster tb
left join tblSSRDetails ssr on tb.pkid=ssr.fkBookMaster
left join mCountryCurrency c on c.CountryCode=tb.Country
where riyapnr=@RiyaPNR

End




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_CancellationTabGridData] TO [rt_read]
    AS [dbo];

