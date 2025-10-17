        
CREATE Procedure [dbo].[Sp_CancellationTabData]          
@RiyaPNR nvarchar(20)=null          
,@Currency varchar(10)=null          
as          
begin        
 --passenger          
 DECLARE @tbl_total TABLE(totalamt DECIMAL) INSERT INTO @tbl_total         
 SELECT totalFare FROM tblBookMaster WHERE riyaPNR = @RiyaPNR          
          
--declare @BasicB2BMARKUP decimal=0          
--declare @TaxB2BMARKUP decimal=0          
--if exists(select top 1 * from tblBookMaster where riyaPNR=@RiyaPNR and B2bFareType=1)          
--begin          
--set @BasicB2BMARKUP=(select top 1 B2BMarkup from tblBookMaster where riyaPNR=@RiyaPNR)          
--end          
--else if exists(select top 1 * from tblBookMaster where riyaPNR=@RiyaPNR and (B2bFareType=2 or B2bFareType=3))          
--begin          
--set @TaxB2BMARKUP=(select top 1 B2BMarkup from tblBookMaster where riyaPNR=@RiyaPNR)          
--end          
          
          
 SELECT @RiyaPNR AS BookingId        
   , t1.paxType        
   , t2.Country        
   , t1.title + '.' + ' ' + t1.paxFName + ' ' + t1.paxLName + ' ' + '(' + paxType + ')' AS FullName        
   , (CASE WHEN CHARINDEX('/',ticketNum) > 0        
      THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum) + 1, LEN(ticketNum)), 0, CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))             
     ELSE ticketNum END) AS TicketNumber        
   , (CASE WHEN t1.BookingStatus = 6         
      THEN 'To Be Cancelled'         
     ELSE 'Confirmed' END) AS Status             
   , t2.pkid as PassngerpkId        
   , t1.pid        
   , t1.isReturn        
   , (SELECT SUM(totalamt) FROM @tbl_total ) AS TotalPassengerFare        
   , (CASE WHEN c.CurrencyCode != @Currency         
      THEN SUM(cast((t1.basicFare * t2.AgentROE * t2.ROE + isnull(t2.AgentMarkup, 0)) AS DECIMAL(10,2)))        
     ELSE sum(cast((t1.basicFare * t2.ROE + isnull(t2.AgentMarkup, 0)) as decimal(10, 2))) END) AS basicFare        
   , (CASE WHEN c.CurrencyCode != @Currency         
      THEN sum(cast((t2.totalTax * t2.AgentROE * t2.ROE) + isnull(t2.B2BMarkup,0) * t2.AgentROE as decimal(10,2)))          
     ELSE sum(cast(t1.totalTax * t2.ROE + isnull(t2.B2BMarkup,0) as decimal(10,2))) END) AS totalTax              
   , CASE WHEN c.CurrencyCode !=@Currency         
      THEN sum(cast((t1.totalFare) * t2.AgentROE * t2.ROE as decimal(10,2))) + isnull(t2.MCOAmount,0) +  isnull(t2.AgentMarkup,0)  + isnull(t2.ServiceFee,0)             
       + isnull(t2.GST,0) + isnull(t2.BFC,0)         
      ELSE sum(cast((t1.totalFare) * t2.ROE as decimal(10,2)))             
       +   isnull(t2.MCOAmount,0) +  isnull(t2.AgentMarkup,0) + isnull(t2.ServiceFee,0) + isnull(t2.GST,0) + isnull(t2.BFC,0) end totalFare        
   , t1.BookingStatus        
   , t2.OfficeID           
          
 from tblBookMaster t2            
 INNER join tblPassengerBookDetails  t1 on t1.fkBookMaster=t2.pkId            
 --left join mCountryCurrency c on c.CountryCode=t2.Country            
 --left join AirlinesName a2 on a2._CODE=t2.airCode            
  inner join mCountryCurrency c on c.CountryCode=t2.Country            
where  t2.riyaPNR=@RiyaPNR and (t1.BookingStatus is null or t1.BookingStatus=6  or t1.BookingStatus=1) and t2.BookingStatus != 18 --and t1.isReturn=0            
group by paxFName,paxType,title,country,paxFName,t1.paxLName,paxType,t1.BookingStatus,ticketNum,pkId,pid,isReturn,t1.basicFare,t1.totalTax,t1.totalFare,CurrencyCode,t2.MCOAmount            
,AgentMarkup,t2.ServiceFee,t2.GST,t2.BFC,t2.totalFare,t2.OfficeID            
            
          
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
        
where t1.riyaPNR=@RiyaPNR and t1.BookingStatus != 18 --and  t1.deptTime>=getdate()          
order by t1.pkId asc          
          
          
--filter          
--if exists(select top 1 * from tblBookMaster where riyaPNR=@RiyaPNR and B2bFareType=1)          
--begin          
--set @BasicB2BMARKUP=(select top 1 B2BMarkup from tblBookMaster where riyaPNR=@RiyaPNR)          
--end          
--else if exists(select top 1 * from tblBookMaster where riyaPNR=@RiyaPNR and (B2bFareType=2 or B2bFareType=3))          
--begin          
--set @TaxB2BMARKUP=(select top 1 B2BMarkup from tblBookMaster where riyaPNR=@RiyaPNR)          
--end          
          
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
            
case when c.CurrencyCode !=@Currency then sum(cast((tP.basicFare *tb.AgentROE* tb.ROE+isnull(tb.AgentMarkup,0)) as decimal(10,2))) else sum(cast((tp.basicFare * tb.ROE+ isnull(tb.AgentMarkup,0)) as decimal(10,2))) end basicFare  ,          
case when c.CurrencyCode !=@Currency then            
sum(cast((tp.totalTax *tb.AgentROE * tb.ROE)+ isnull(tb.B2BMarkup,0) *tb.AgentROE  as decimal(10,2))) else sum(cast(tp.totalTax * tb.ROE + isnull(tb.B2BMarkup,0) as decimal(10,2))) end  totalTax             
,case when c.CurrencyCode !=@Currency then sum(cast(tp.totalFare * tb.AgentROE * tb.ROE as decimal(10,2))) else sum(cast(tp.totalFare * tb.ROE as decimal(10,2)))  end totalfare            
            
,@RiyaPNR as RiyaPNR,
-- c.CurrencyCode   
CASE WHEN tb.AgentROE <> 1 THEN MC.Value
		ELSE c.CurrencyCode
	END AS CurrencyCode
            
 ,tb.pkid as PassngerpkId ,tp.pid            
,tp.isReturn            
,isnull(tp.BookingStatus,0) BookingStatus            
,'1' as Segment            
,ti.airlinePNR as 'GDSPNR'             
from tblBookMaster tb            
left join tblPassengerBookDetails tp on tp.fkBookMaster=tb.pkId            
 left join mCountryCurrency c on c.CountryCode=tb.Country            
 inner join tblBookItenary ti on ti.fkBookMaster=tb.pkId    
 	LEFT JOIN agentLogin agentLogin ON cast(agentLogin.UserID as nvarchar(30))=cast(tb.AgentID as nvarchar(30))
  LEFT JOIN mcommon MC WITH(NOLOCK) ON agentLogin.NewCurrency = MC.ID  
where tb.riyaPNR=@RiyaPNR and tb.BookingStatus != 18 and  (tp.BookingStatus is null or tp.BookingStatus=6  or tp.BookingStatus=1) --and tb.totalFare>0 --and tp.totalFare>0            
group by title,paxFName,paxLName,paxType,pid,CurrencyCode,isReturn,ticketNum,tp.BookingStatus,tb.pkid,ti.airlinePNR,tb.AgentROE,MC.Value  order by tp.pid            
          
--status To be cancelled          
Declare @TotalPasscount int          
Declare @TobeCancelledPasscount int          
Declare @CancelledPasscount int          
          
set @TotalPasscount=(select count(*) FROM    tblPassengerBookDetails t1           
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster          
WHERE   t2.riyaPNR=@RiyaPNR and t2.BookingStatus != 18)          
          
set @TobeCancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1           
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster          
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=6)          
          
set @CancelledPasscount=(select count(*) FROM    tblPassengerBookDetails t1           
LEFT JOIN tblBookMaster t2 ON t2.pkId=t1.fkBookMaster          
WHERE   t2.riyaPNR=@RiyaPNR and t1.BookingStatus=4)          
          
if(@TotalPasscount=@CancelledPasscount)          
begin          
select top 1 BookingStatus,      
case when VendorName IN ('EKNDC','WYNDC','Verteil','VerteilNDC','Indigo','Spicejet','FlyDubai','AIExpress','AkasaAir','ETNDC') Then 'API' else VendorName end as VendorName ,      
t1.ROE,isnull(AgentROE ,1) AS AgentROE,        
    Format(cast(IssueDate as datetime),'dd/MM/yyyy','en-us')  as IssueDate,        
    t1.Country,OfficeID,userTypeID        
    from tblBookMaster t1  left join AgentLogin ag on ag.UserID=t1.AgentID where riyapnr=@RiyaPNR          
end          
else          
begin          
 select top 1 BookingStatus,      
 case when VendorName IN ('EKNDC','WYNDC','Verteil','VerteilNDC','Indigo','Spicejet','FlyDubai','AIExpress','AkasaAir','ETNDC') Then 'API' else VendorName end as VendorName,      
 t1.ROE ,isnull(AgentROE ,1) AS AgentROE ,        
       Format(cast(IssueDate as datetime),'dd/MM/yyyy','en-us')  as IssueDate,        
      t1.Country,OfficeID,userTypeID        
      from tblBookMaster t1  left join AgentLogin ag on ag.UserID=t1.AgentID where riyapnr=@RiyaPNR          
end          
          
      --Total passenger count          
select count(*) as TotalPassCount from tblPassengerBookDetails tp           
left join tblBookMaster tb on tb.pkid=tp.fkBookMaster          
where riyapnr=@RiyaPNR and tp.isreturn=0          
          
----Bookmaster Booking Status          
--select BookingStatus as TblBookmasterBookingStatus from tblBookMaster where riyaPNR=  @RiyaPNR          
          
----Booking PNR dept date          
--select top 1 depDate from tblBookMaster where riyapnr=@RiyaPNR          
          
--Baggage fare SSR          
SELECT   tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,ssr.SSR_Type
--,sum(isnull(SSR_Amount,0)) SSR_Amount  
,(CASE 
    WHEN TB.AgentROE <> 1  
        THEN CAST(SUM(ISNULL(SSR_Amount,0) * ISNULL(TB.AgentROE,1)) AS DECIMAL(10,2))
    ELSE CAST(SUM(ISNULL(SSR_Amount,0)) AS DECIMAL(10,2))
 END) AS SSR_Amount
FROM tblPassengerBookDetails TP           
LEFT JOIN tblSSRDetails SSR ON SSR.fkPassengerid=TP.pid          
LEFT JOIN tblBookMaster TB ON TB.PKID=TP.fkBookMaster 
LEFT JOIN agentLogin agentLogin ON cast(agentLogin.UserID as nvarchar(30))=cast(TB.AgentID as nvarchar(30))
LEFT JOIN mcommon mcommon WITH(NOLOCK) ON agentLogin.NewCurrency = mcommon.ID
WHERE RIYAPNR=@RiyaPNR AND SSR_Type='Baggage'           
group by title,paxFName,paxLName,paxType,SSR_Type ,TB.AgentROE        
          
--Meal fare SSR          
SELECT  tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,ssr.SSR_Type,
--sum(isnull(SSR_Amount,0)) SSR_Amount 
(CASE 
    WHEN TB.AgentROE <> 1  
        THEN CAST(SUM(ISNULL(SSR_Amount,0) * ISNULL(TB.AgentROE,1)) AS DECIMAL(10,2))
    ELSE CAST(SUM(ISNULL(SSR_Amount,0)) AS DECIMAL(10,2))
 END) AS SSR_Amount
FROM tblPassengerBookDetails TP           
LEFT JOIN tblSSRDetails SSR ON SSR.fkPassengerid=TP.pid          
LEFT JOIN tblBookMaster TB ON TB.PKID=TP.fkBookMaster   
LEFT JOIN agentLogin agentLogin ON cast(agentLogin.UserID as nvarchar(30))=cast(TB.AgentID as nvarchar(30))
LEFT JOIN mcommon mcommon WITH(NOLOCK) ON agentLogin.NewCurrency = mcommon.ID
WHERE RIYAPNR=@RiyaPNR AND SSR_Type='Meals'           
group by title,paxFName,paxLName,paxType,SSR_Type ,TB.AgentROE         
        
--Seat fare SSR          
SELECT  tp.title +'.'+ +' '+tp.paxFName +' '+tp.paxLName +' '+'('+paxType+')' as FullName,ssr.SSR_Type
--,sum(isnull(SSR_Amount,0)) SSR_Amount 
,(CASE 
    WHEN TB.AgentROE <> 1  
        THEN CAST(SUM(ISNULL(SSR_Amount,0) * ISNULL(TB.AgentROE,1)) AS DECIMAL(10,2))
    ELSE CAST(SUM(ISNULL(SSR_Amount,0)) AS DECIMAL(10,2))
 END) AS SSR_Amount
FROM tblPassengerBookDetails TP           
LEFT JOIN tblSSRDetails SSR ON SSR.fkPassengerid=TP.pid          
LEFT JOIN tblBookMaster TB ON TB.PKID=TP.fkBookMaster  
LEFT JOIN agentLogin agentLogin ON cast(agentLogin.UserID as nvarchar(30))=cast(TB.AgentID as nvarchar(30))
LEFT JOIN mcommon mcommon WITH(NOLOCK) ON agentLogin.NewCurrency = mcommon.ID
WHERE RIYAPNR=@RiyaPNR AND SSR_Type='Seat'           
group by title,paxFName,paxLName,paxType,SSR_Type ,TB.AgentROE         
          
End   
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_CancellationTabData] TO [rt_read]
    AS [dbo];

