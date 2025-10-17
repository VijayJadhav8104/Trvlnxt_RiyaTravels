--exec [Sp_CancellationTabData] '1D0JF5','AED'  
  
CREATE Procedure [dbo].[Sp_CancellationTabData_backup]  
@RiyaPNR nvarchar(20)=null  
,@Currency varchar(10)=null  
as  
begin  
  
--passenger  
select    
@RiyaPNR as BookingId,    
 t1.paxType,  
t1.title +'.'+ +' '+t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,  
(CASE WHEN CHARINDEX('/',ticketNum)>0   
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
ELSE ticketNum END )as 'TicketNumber'  
  
,case when t1.BookingStatus=6 then 'To Be Cancelled'  
  
 else 'Confirmed' end  Status  
  
 ,t2.pkid as PassngerpkId ,t1.pid ,t1.isReturn  
  
,case when c.CurrencyCode !=@Currency then sum(cast((t1.basicFare *t2.AgentROE* t2.ROE+isnull(t2.AgentMarkup,0)) as decimal(10,2))) else sum(cast((t1.basicFare * t2.ROE+ isnull(t2.AgentMarkup,0)) as decimal(10,2))) end basicFare  ,case when c.CurrencyCode
  
 !=@Currency then  
sum(cast((t1.totalTax *t2.AgentROE * t2.ROE)+ isnull(t2.B2BMarkup,0) *t2.AgentROE  as decimal(10,2))) else sum(cast(t1.totalTax * t2.ROE + isnull(t2.B2BMarkup,0) as decimal(10,2))) end  totalTax   
,case when c.CurrencyCode !=@Currency then sum(cast(t1.totalFare * t2.AgentROE * t2.ROE as decimal(10,2))) else sum(cast(t1.totalFare * t2.ROE as decimal(10,2)))  end totalFare  
--,t1.basicFare --,t1.totalTax --,t1.totalFare ,t1.BookingStatus ,c.CurrencyCode --,(select top 1  mc.CurrencyCode from mCountryCurrency mc where mc.CountryCode=t2.Country) AS CurrencyCode  
 from tblBookMaster t2  
 INNER join tblPassengerBookDetails  t1 on t1.fkBookMaster=t2.pkId  
 left join mCountryCurrency c on c.CountryCode=t2.Country  
 --left join AirlinesName a2 on a2._CODE=t2.airCode  
where  t2.riyaPNR=@RiyaPNR and (t1.BookingStatus is null or t1.BookingStatus=6) --and t1.isReturn=0  
group by paxFName,paxType,title,country,paxFName,t1.paxLName,paxType,t1.BookingStatus,ticketNum,pkId,pid,isReturn,t1.basicFare,t1.totalTax,t1.totalFare,c.CurrencyCode  
  
--flight  
select distinct   
 t1.airCode+' '+t1.flightNo as flightNo,  
 t1.frmSector,  
t1.toSector,  
Format(cast(t1.deptTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as depDate,  
Format(cast(t1.arrivalTime as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as arrivalDate,  
t1.pkId as FlightpkId  
--,tbi.pid  
from tblBookMaster t1  
--inner join tblPassengerBookDetails tbi on tbi.fkBookMaster=t1.pkId  
--left join tblBookItenary ti on ti.orderId=t1.orderId  
where t1.riyaPNR=@RiyaPNR and  t1.deptTime>=getdate() order by t1.pkId asc  
  
  
--filter  
select   
@RiyaPNR as BookingId,    
 tp.paxType,  
tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName  
,(CASE WHEN CHARINDEX('/',ticketNum)>0   
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
ELSE ticketNum END )as 'TicketNumber'  
   
 ,case when tp.BookingStatus=6 then 'To Be Cancelled'  
  
 else 'Confirmed' end  Status  
,tp.pid,  
  
case when c.CurrencyCode !=@Currency then sum(cast((tP.basicFare *tb.AgentROE* tb.ROE+isnull(tb.AgentMarkup,0)) as decimal(10,2))) else sum(cast((tp.basicFare * tb.ROE+ isnull(tb.AgentMarkup,0)) as decimal(10,2))) end basicFare  ,case when c.CurrencyCode 
  
!=@Currency then  
sum(cast((tp.totalTax *tb.AgentROE * tb.ROE)+ isnull(tb.B2BMarkup,0) *tb.AgentROE  as decimal(10,2))) else sum(cast(tp.totalTax * tb.ROE + isnull(tb.B2BMarkup,0) as decimal(10,2))) end  totalTax   
,case when c.CurrencyCode !=@Currency then sum(cast(tp.totalFare * tb.AgentROE * tb.ROE as decimal(10,2))) else sum(cast(tp.totalFare * tb.ROE as decimal(10,2)))  end totalfare  
  
,@RiyaPNR as RiyaPNR,  c.CurrencyCode  
  
 ,tb.pkid as PassngerpkId ,tp.pid  
,tp.isReturn  
,isnull(tp.BookingStatus,0) BookingStatus  
,'1' as Segment  
,ti.airlinePNR as 'GDSPNR'  
from tblBookMaster tb  
left join tblPassengerBookDetails tp on tp.fkBookMaster=tb.pkId  
 left join mCountryCurrency c on c.CountryCode=tb.Country  
  inner join tblBookItenary ti on ti.orderId=tb.orderId  
where tb.riyaPNR=@RiyaPNR and (tp.BookingStatus is null or tp.BookingStatus=6) --and tb.totalFare>0 and tp.totalFare>0  
group by title,paxFName,paxLName,paxType,pid,CurrencyCode,isReturn,ticketNum,tp.BookingStatus,tb.pkid ,ti.airlinePNR order by tp.pid  
  
--status To be cancelled  
Declare @TotalPasscount int  
Declare @TobeCancelledPasscount int  
Declare @CancelledPasscount int  
  
set @TotalPasscount=(select count(*) FROM    tblPassengerBookDetails t1   
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster  
WHERE   t2.riyaPNR=@RiyaPNR)  
  
set @TobeCancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1   
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster  
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=6)  
  
set @CancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1   
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster  
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=4)  
  
if(@TotalPasscount=@CancelledPasscount)  
begin  
select top 1 BookingStatus,VendorName from tblBookMaster where riyapnr=@RiyaPNR  
end  
else  
begin  
select top 1 BookingStatus,VendorName from tblBookMaster where riyapnr=@RiyaPNR  
end  
  
  
--Total passenger count  
select count(*) as TotalPassCount from tblPassengerBookDetails tp   
left join tblBookMaster tb on tb.pkid=tp.fkBookMaster  
where riyapnr=@RiyaPNR and tp.isreturn=0  
  
End  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_CancellationTabData_backup] TO [rt_read]
    AS [dbo];

