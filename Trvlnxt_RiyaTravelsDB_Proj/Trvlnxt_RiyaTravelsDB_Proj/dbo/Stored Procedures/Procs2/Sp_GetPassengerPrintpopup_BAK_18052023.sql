--exec Sp_GetPassengerPrintpopup '1HQK29','677423,677425,677424', 'CAD' 
CREATE Procedure [dbo].[Sp_GetPassengerPrintpopup_BAK_18052023]  
@RiyaPNR varchar(20)=null,  
@Pid1 varchar(500)=null  
,@Currency varchar(8)=null    
, @SectorID Varchar(20) = null
as  
begin  
  
  declare @NewOrderID varchar(50)=null
select top 1 @NewOrderID=orderId from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR and BookingStatus != 18 order by pkId desc;
--passenger details  
select  
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,  
  
case   
WHEN t1.BookingStatus=6  THEN 'To Be Cancelled'   
WHEN t1.BookingStatus=4  THEN 'Cancelled'   
--when t1.BookingStatus is null then 'Confirmed'  
when t2.BookingStatus=0 then 'Failed'  
 when t2.BookingStatus=1 then 'Confirmed'  
when t2.BookingStatus=2 then 'Hold'  
when t2.BookingStatus=3 then 'Pending'  
when t2.BookingStatus=4 then 'Cancelled'  
when t2.BookingStatus=5 then 'Close'  
when t2.BookingStatus=7 then 'To be Rescheduled'  
when t2.BookingStatus=8 then 'Rescheduled'  
WHEN t2.BookingStatus=13 THEN 'TJQ Pending'
when t1.BookingStatus is null then 'Confirmed'  
End Status,  
  
  
(CASE WHEN CHARINDEX('/',ticketNum)>0   
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
ELSE ticketNum END )as 'TicketNumber',  
  
STUFF((SELECT '/' + t1.baggage FROM tblBookMaster s WITH(NOLOCK) 
WHERE t1.fkBookMaster = s.pkId FOR XML PATH('')),1,1,'') AS baggage  
,T1.paxType  
,isReturn
,Journey
,pid
,cast(t1.basicFare as decimal(10,2)) basicFare
,cast(t1.totalTax as decimal(10,2)) totalTax
,cast(t1.totalFare as decimal(10,2)) totalFare
--,cast(t1.JNTax as decimal(10,2)) JNTax
, case when c.CurrencyCode !=@currency then cast((t1.JNTax * t2.AgentROE * t2.ROE) as decimal(10,2)) else cast((t1.JNTax * t2.ROE) as decimal(10,2)) end JNTax --Added By JD 26.12.2022
,isnull(FrequentFlyNo,'') FrequentFlyNo 
,ag.userTypeID
, ISNULL(ag.GroupId, '') AS GroupId
, ISNULL(t2.Country,'') as agencyCountry
, ISNULL(airCode, '') AS airCode
, CASE WHEN BarCode IS NULL THEN '' 
		ELSE (SELECT STUFF((SELECT '^' + BarCode 
					FROM tblPassengerBookDetails PB WITH(NOLOCK)
					LEFT JOIN tblBookMaster t2 WITH(NOLOCK) ON t2.pkId=PB.fkBookMaster 
					WHERE t2.riyaPNR = @RiyaPNR AND (PB.paxFName + ' ' + PB.paxLName) = (t1.paxFName + ' ' + t1.paxLName)
					FOR XML PATH('')
				), 1, 1, ''))
		END AS BarCode
, ISNULL(PassengerID, '') AS PassengerID -- Added By JD 20.01.2022
, ISNULL(t1.ServiceFee, 0) AS ServiceFee
, ISNULL(t1.GST, 0) AS GST	
,ISNULL(t2.IsBooked,0) AS IsBooked

 from tblPassengerBookDetails t1 WITH(NOLOCK)
 left join tblBookMaster t2 WITH(NOLOCK) on t2.pkId=t1.fkBookMaster  
  --left join AirlinesName a2 WITH(NOLOCK) on a2._CODE=t2.airCode  
  left join  agentLogin ag WITH(NOLOCK) on ag.UserID=t2.AgentID
  left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t2.Country
  where t2.riyaPNR=@RiyaPNR and t2.BookingStatus != 18 AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
  and t1.pid in(select DATA from sample_split(@Pid1,',')) 
  and t2.returnFlag=0  and t2.BookingStatus != 18
  order by pid  asc   
 
  

--Payment details 

declare @BasicB2BMARKUP decimal(18,2)=0
declare @TaxB2BMARKUP decimal(18,2)=0
if exists(select top 1 * from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR and B2bFareType=1 and BookingStatus != 18)
begin
set @BasicB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp WITH(NOLOCK) inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR and tbm.BookingStatus != 18)
end
else if exists(select top 1 * from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR and BookingStatus != 18 and (B2bFareType=2 or B2bFareType=3))
begin
set @TaxB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp WITH(NOLOCK) inner join tblBookMaster tbm on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR and tbm.BookingStatus != 18)
end

select
case when c.CurrencyCode !=@Currency then
sum(cast((tP.basicFare *tb.AgentROE* tb.ROE+isnull(tp.Markup,0)) as decimal(10,2))
+CASE WHEN ISNULL(tP.basicFare, 0) != 0 THEN @BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0)ELSE 0 END) 
else sum(cast((tp.basicFare * tb.ROE+ isnull(tp.Markup,0)) as decimal(10,2)
)+CASE WHEN ISNULL(tP.basicFare, 0) != 0 THEN @BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0)ELSE 0 END) end basicFare

,case when c.CurrencyCode!=@Currency then
sum(cast(((tp.totalTax+ISNULL(tp.VendorServiceFee,0) + ISNULL(tp.AirlineFee,0)) *tb.AgentROE * tb.ROE)
+ CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP + isnull(tp.HupAmount,0) --+ isnull(tp.ServiceFee,0) + isnull(tp.gst,0) 
+ isnull(tp.BFC,0)) ELSE 0 END *tb.AgentROE  as decimal(10,2))) 
else sum(cast((tp.totalTax+ISNULL(tp.VendorServiceFee,0)+ ISNULL(tp.AirlineFee,0)) * tb.ROE 
+ CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP + isnull(tp.HupAmount,0) --+ isnull(tp.ServiceFee,0) + isnull(tp.gst,0) 
+ isnull(tp.BFC,0))ELSE 0 END  as decimal(10,2))) end totalTax

,case when c.CurrencyCode !=@Currency then
sum(cast((tp.totalFare+ISNULL(tp.VendorServiceFee,0) + ISNULL(tp.AirlineFee,0)) * tb.AgentROE * tb.ROE as decimal(10,2))) --+   isnull(tp.MCOAmount,0) 
+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN isnull(tp.Markup,0) + isnull(tp.BFC,0) +@TaxB2BMARKUP+@BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0) 
+ isnull(tp.ServiceFee,0) + isnull(tp.gst,0) + isnull(tp.HupAmount,0)
-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0)) ELSE 0 END--+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0) 
else sum(cast((tp.totalFare+ISNULL(tp.VendorServiceFee,0) + ISNULL(tp.AirlineFee,0)) * tb.ROE as decimal(10,2))) --+   isnull(tp.MCOAmount,0) 
+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN isnull(tp.Markup,0)  + isnull(tp.HupAmount,0)+ isnull(tp.BFC,0) +@TaxB2BMARKUP +ISNULL(tp.LonServiceFee,0) 
+@BasicB2BMARKUP + isnull(tp.ServiceFee,0) + isnull(tp.gst,0)  
-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0)) ELSE 0 END--+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0) 
end totalFare 

,case when c.CurrencyCode!=@Currency then
sum(cast(((tp.totalTax+ISNULL(tp.VendorServiceFee,0)+ ISNULL(tp.AirlineFee,0) + ISNULL(tp.MCOAmount,0)) *tb.AgentROE * tb.ROE)
+  CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP + isnull(tp.HupAmount,0) 
+ isnull(tp.BFC,0) ) *tb.AgentROE  ELSE 0 END as decimal(10,2)) ) 
else sum(cast((tp.totalTax+ISNULL(tp.VendorServiceFee,0) + ISNULL(tp.AirlineFee,0)) * tb.ROE + 
CASE WHEN ISNULL(tP.totalTax, 0) != 0 THEN (@TaxB2BMARKUP  + isnull(tp.HupAmount,0)
+ isnull(tp.BFC,0)) ELSE 0 END  as decimal(10,2))) end TotalTaxWithoutServiceFee

,case when c.CurrencyCode !=@Currency then
sum(cast((tp.totalFare +ISNULL(tp.VendorServiceFee,0)+ ISNULL(tp.AirlineFee,0) ) * tb.AgentROE * tb.ROE as decimal(10,2))) --+   isnull(tp.MCOAmount,0) 
+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN isnull(tp.Markup,0) + isnull(tp.BFC,0) +@TaxB2BMARKUP+@BasicB2BMARKUP+ISNULL(tp.LonServiceFee,0) + isnull(tp.HupAmount,0) 
-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0)) ELSE 0 END--+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0) 
 else sum(cast((tp.totalFare+ISNULL(tp.VendorServiceFee,0) + ISNULL(tp.AirlineFee,0)) * tb.ROE as decimal(10,2))) --+   isnull(tp.MCOAmount,0) 
+ CASE WHEN ISNULL(tP.totalFare, 0) != 0 THEN isnull(tp.Markup,0)  + isnull(tp.HupAmount,0)+ isnull(tp.BFC,0) +@TaxB2BMARKUP +@BasicB2BMARKUP  +ISNULL(tp.VendorServiceFee,0)
+ISNULL(tp.LonServiceFee,0)-(ISNULL(tp.PLBCommission,0)+ISNULL(tp.IATACommission,0)+ISNULL(tp.DropnetCommission,0))  ELSE 0 END --+ isnull(tb.ServiceFee,0) + isnull(tb.GST,0) 
end TotalFareWithoutServiceFee 

,tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName 
,c.CurrencyCode

--,tp.YQ as YQTax
--,tp.JNTax
, case when c.CurrencyCode !=@currency then cast((tp.JNTax * tb.AgentROE * tb.ROE) as decimal(10,2)) else cast((tp.JNTax * tb.ROE) as decimal(10,2)) end JNTax --Added By JD 26.12.2022
,tb.isReturnJourney
--Bnasi 17-01-2023
,ISNULL(tp.BFC, 0) AS BFC

--Bansi 01-02-2023
,case when c.CurrencyCode !=@currency then 
sum(cast((tp.JNTax *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.JNTax * tb.ROE) as decimal(10,2))) end JNTax
 ,case when c.CurrencyCode !=@currency then 
sum(cast((tp.YQ *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.YQ * tb.ROE) as decimal(10,2))) end YQTax
,case when c.CurrencyCode !=@currency then 
sum(cast((tp.ServiceCharge *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.ServiceCharge * tb.ROE) as decimal(10,2))) end ServiceCharge
,case when c.CurrencyCode !=@currency then 
sum(cast((tp.YRTax *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.YRTax * tb.ROE) as decimal(10,2))) end YRTax
,case when c.CurrencyCode !=@currency then 
sum(cast((tp.INTax *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.INTax * tb.ROE) as decimal(10,2))) end INTax
,case when c.CurrencyCode !=@currency then 
sum(cast((tp.OCTax *tb.AgentROE* tb.ROE) as decimal(10,2))) else sum(cast((tp.OCTax * tb.ROE) as decimal(10,2))) end OCTax
,Case when c.CurrencyCode !=@Currency then
sum(cast(((isnull(tp.ExtraTax ,0) *tb.AgentROE * tb.ROE)+(ISNULL(tp.VendorServiceFee,0) * tb.ROE) +(ISNULL(tp.AirlineFee,0) * tb.ROE)) as decimal(10,2)))
else
sum(cast(((isnull(tp.ExtraTax ,0) * tb.ROE )+(ISNULL(tp.VendorServiceFee,0) * tb.ROE) +(ISNULL(tp.AirlineFee,0) * tb.ROE)) as decimal(10,2))) End ExtraTax

,ISNULL(case when c.CurrencyCode !=@currency then 
sum(cast((tp.WOTax) as decimal(10,2))) else sum(cast((tp.WOTax) as decimal(10,2))) end, 0) AS WOTax
,ISNULL(case when c.CurrencyCode !=@currency then 
sum(cast((tp.B2BMarkup *tb.AgentROE) as decimal(10,2))) else sum(cast((tp.B2BMarkup) as decimal(10,2))) end, 0) AS SC
,ISNULL(tp.RFTax, 0) AS RFTax

from tblPassengerBookDetails tp  WITH(NOLOCK)
left join tblBookMaster tb on tb.pkid=tp.fkbookmaster  
left join mCountryCurrency c on c.CountryCode=tb.Country  
where tp.pid in(select DATA from sample_split(@Pid1,',')) and tb.BookingStatus != 18 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) --and (tb.totalFare>0 or (ISNULL(tb.PreviousRiyaPNR,'')!=''))
group by CurrencyCode,tp.markup,tp.bfc,tp.B2bMarkup,tp.ServiceFee,tp.gst,tp.HupAmount,tp.paxFName,tp.paxLName,tp.paxType,tp.pid,YQ,tp.JNTax,tb.isReturnJourney  
,  tb.AgentROE, tb.ROE --Added By JD 26.12.2022
,tp.BFC --Bnasi 17-01-2023
, tp.JNTax,tb.isReturnJourney ,tp.BFC,tb.AgentROE,tb.ROE,tp.serviceCharge, tp.YRTax,tp.INTax,tp.OCTax,
tp.ExtraTax,tp.WOTax,tp.B2BMarkup,tp.RFTax,tp.LonServiceFee,tp.VendorServiceFee	,tp.PLBCommission,tp.IATACommission,tp.DropnetCommission,tP.totalFare

order by pid asc  

  
--return journy calculation  
--select tp.isReturn,  
--c.CurrencyCode,cast(tp.basicFare as decimal(10,2)) basicFare,cast(tp.totalTax as decimal(10,2)) totalTax, cast(tp.totalFare as decimal(10,2)) totalFare  
--,TB.VendorName  
-- from tblPassengerBookDetails tp  
--left join tblBookMaster tb on tb.pkid=tp.fkbookmaster  
--left join mCountryCurrency c on c.CountryCode=tb.Country  
--where tb.riyaPNR=@RiyaPNR and isReturn=1  
  
 
  
--BAGGEGE DETAILS FROM SSR TABLE           
if((select top 1 bookingsource from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR)='Retrive PNR Accounting')      
begin      
      print('IF')
select      
tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,tp.baggage --,'' as SSR_Type,'' as SSR_Name,'0' as SSR_Amount      
,tp.paxType      
,Replace(ssr.SSR_Name,' kg','') as PassengerBaggageTotal      
,tp.isreturn
--,SSR_Amount -- Commentd By JD 10.02.2023
,SUM(
         CASE 
         WHEN ISNULL(SSR.ROE,0) = 0 
         THEN 
            CASE WHEN c.CurrencyCode != @Currency
            THEN ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE
            ELSE ISNULL(SSR.SSR_Amount, 0) * tb.ROE
            END
          ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
         END) AS SSR_Amount
,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage
, ISNULL(SSR.SSR_Name, '') AS SSR_Name
from      
tblPassengerBookDetails tp  WITH(NOLOCK)    
 left join tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster      
 inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid     
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
where  tb.riyaPNR=@RiyaPNR and tb.BookingStatus != 18 and SSR_Type='baggage' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)     
group by title,paxFName,paxLName,paxType,tp.baggage,isReturn, SSR_Amount,pid, SSR_Name, tb.AgentROE, tb.ROE, CurrencyCode
order by tp.paxType      
end      
else      
begin      
if exists(select top 1 * from tblSSRDetails s1 WITH(NOLOCK) where s1.fkpassengerid in(select pid from tblPassengerBookDetails WITH(NOLOCK) where fkBookMaster in(select pkid from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR)) )      
 begin 
	print('iNNER IF')
 select distinct tp.baggage,--ssr.SSR_Type,ISNULL(ssr.SSR_Name,'') SSR_Name,      
 --ISNULL(ssr.SSR_Amount,0) SSR_Amount, -- Commentd By JD 10.02.2023
 SUM(
         CASE 
         WHEN ISNULL(SSR.ROE,0) = 0 
         THEN 
            CASE WHEN c.CurrencyCode != @Currency
            THEN ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE
            ELSE ISNULL(SSR.SSR_Amount, 0) * tb.ROE
            END
          ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
         END) AS SSR_Amount,
tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,      
tp.paxType      
--,sum(CAST(dbo.udf_GetNumeric(isnull(ssr.SSR_Name,0)) as int) + cast(dbo.udf_GetNumeric(isnull(tp.baggage,0)) as int))  as PassengerBaggageTotal      
,sum(cast(dbo.udf_GetNumeric(isnull(tp.baggage,0)) as int))  as PassengerBaggageTotal      
,tp.isreturn      
,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage      
,pid 
, ISNULL(SSR.SSR_Name, '') AS SSR_Name
from tblPassengerBookDetails tp WITH(NOLOCK)
inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid      
inner join tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
where  tb.riyaPNR=@RiyaPNR and tb.BookingStatus != 18 and SSR_Type='baggage' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)      
group by title,paxFName,paxLName,paxType,tp.baggage,isReturn, SSR_Amount,pid, SSR_Name, tb.AgentROE, tb.ROE, CurrencyCode --,SSR_Name,SSR_Type      
--and ssr.SSR_Amount>=0      
order by tp.paxType,FullName,pid  
      
end      
else      
      
begin  
	print('iNNER else')
select      
tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName, '' AS SSR_Name,tp.baggage --,'' as SSR_Type,'' as SSR_Name,'0' as SSR_Amount      
,tp.paxType      
,cast(dbo.udf_GetNumeric(isnull(REPLACE(tp.baggage,'1 Piece',''),0)) as int)  as PassengerBaggageTotal      
,tp.isreturn, 0 as SSR_Amount      
,LTRIM(RIGHT(tp.baggage, LEN(tp.baggage) - PATINDEX('%[0-9][^0-9]%', tp.baggage))) As ExtenstionBaggage      
from      
tblPassengerBookDetails tp WITH(NOLOCK)
 left join tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster      
where  tb.riyaPNR=@riyapnr and tb.BookingStatus != 18 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)      
--group by title,paxFName,paxLName,paxType,tp.baggage,isReturn      
order by tp.paxType      
end      
end      
      
--Meal details from SSR table          
select tp.baggage
		,isnull(ssr.SSR_Type,'') SSR_Type
		,isnull('Meal-'+ SSR.SSR_Code+'/','')  as SSR_Name
		, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		--,isnull(ssr.SSR_Amount,0) SSR_Amount -- Commentd By JD 10.02.2023
		,(CASE 
                 WHEN ISNULL(SSR.ROE,0) = 0 
                  THEN 
                 CASE WHEN c.CurrencyCode != @Currency
                 THEN CAST(ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE AS decimal(18, 2))
                 ELSE CAST(ISNULL(SSR.SSR_Amount, 0) * tb.ROE AS decimal(18, 2))
                END
              ELSE 
              ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
              END) AS SSR_Amount
			  --, CASE WHEN c.CurrencyCode!=@Currency THEN CAST(ISNULL(SSR.SSR_Amount,0) *(tb.AgentROE * tb.ROE)  AS DECIMAL(10,2))
		--	ELSE CAST(ISNULL(SSR.SSR_Amount,0) * tb.ROE  AS DECIMAL(10,2))
		--END SSR_Amount
		,tp.paxType             
             
   from tblPassengerBookDetails tp WITH(NOLOCK)
 inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid           
 inner join tblBookMaster tb WITH(NOLOCK) on tb.pkid=SSR.fkBookMaster 
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
where  tb.riyaPNR=@RiyaPNR and tb.BookingStatus != 18 and SSR_Type='Meals' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
--AND isReturn = 0 -- JD || 09.03.2023
     
--Baggage fare passenger wise  
 select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,  
 
 SUM(CASE 
         WHEN ISNULL(SSR.ROE,0) = 0 
         THEN 
            CASE WHEN c.CurrencyCode != tb.AgentCurrency
            THEN CAST((isnull(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) AS DECIMAL(10,2))
            ELSE CAST((isnull(SSR.SSR_Amount,0)) *(tb.ROE) AS DECIMAL(10,2))
            END
          ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
         END) AS SSR_Amount 
from tblPassengerBookDetails tp    WITH(NOLOCK)
inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid   
inner join tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster   
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country  
where  tb.riyaPNR=@RiyaPNR and SSR_Type='baggage' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)    and tb.BookingStatus != 18
group by title,paxFName,paxLName,paxType,CurrencyCode,tb.AgentCurrency,tb.AgentROE,tb.ROE   
order by tp.paxType,FullName  
  
--Meal fare passenger wise  
 select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName,  

 SUM(CASE 
         WHEN ISNULL(SSR.ROE,0) = 0 
         THEN 
            CASE WHEN c.CurrencyCode != tb.AgentCurrency
            THEN CAST((isnull(SSR.SSR_Amount,0)) *(tb.AgentROE * tb.ROE) AS DECIMAL(10,2))
            ELSE CAST((isnull(SSR.SSR_Amount,0)) *(tb.ROE) AS DECIMAL(10,2))
            END
          ELSE 
            ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
         END) AS SSR_Amount  
from tblPassengerBookDetails tp    WITH(NOLOCK)
inner JOIN tblSSRDetails SSR  WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid   
inner join tblBookMaster tb   WITH(NOLOCK) on tb.pkid=tp.fkBookMaster  
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country  
where  tb.riyaPNR=@RiyaPNR and SSR_Type='Meals' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18
--AND isReturn = 0 -- JD || 09.03.2023
group by title,paxFName,paxLName,paxType,CurrencyCode,tb.AgentCurrency,tb.AgentROE,tb.ROE    
order by tp.paxType,FullName  


 --Net fare calculation  
select tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName  
  
,case when c.CurrencyCode !=@Currency then  
sum(cast((tp.totalFare) * tb.AgentROE * tb.ROE as decimal(10,2))) +   isnull(tp.MCOAmount,0) +  isnull(tp.Markup,0)  + isnull(tp.BFC,0) +isnull(tp.B2BMarkup,0)   
else sum(cast((tp.totalFare) * tb.ROE as decimal(10,2))) +   isnull(tp.MCOAmount,0) +  isnull(tp.Markup,0) + isnull(tp.BFC,0) +isnull(tp.B2BMarkup,0)  
end totalFare  
  
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
  
from tblPassengerBookDetails tp  WITH(NOLOCK)
left join tblBookMaster tb WITH(NOLOCK) on tb.pkid=tp.fkBookMaster  
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country  
where riyapnr=@RiyaPNR AND TP.totalFare >0  AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18
GROUP BY TP.paxFName,TP.paxLName,TP.paxType,C.CurrencyCode  
,TP.MCOAmount,TP.Markup,TB.BFC,TP.B2BMarkup,tp.IATACommission,tp.PLBCommission,tp.DropnetCommission,tp.ServiceFee,TP.GST, tp.BFC,HupAmount  
 order by tP.paxType,FullName asc    

 --Passenger details for new print copy
declare @BasicB2BMARKUP1 decimal(18,2)=0
declare @TaxB2BMARKUP1 decimal(18,2)=0
if exists(select top 1 * from tblBookMaster WITH(NOLOCK) where riyaPNR='' and B2bFareType=1)
begin
set @BasicB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp WITH(NOLOCK) inner join tblBookMaster tbm WITH(NOLOCK) on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR)
end
else if exists(select top 1 * from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR and (B2bFareType=2 or B2bFareType=3))
begin
set @TaxB2BMARKUP=(select top 1 tp.B2BMarkup from tblPassengerBookDetails tp inner join tblBookMaster tbm WITH(NOLOCK) on tp.fkBookMaster=tbm.pkId where riyaPNR=@RiyaPNR)
end


select  
t1.paxFName +' '+t1.paxLName +' '+'('+paxType+')' as FullName,
case when c.CurrencyCode !=@Currency then
sum(cast((t1.basicFare *t2.AgentROE* t2.ROE+isnull(t1.Markup,0)) as decimal(10,2))+@BasicB2BMARKUP+ISNULL(t1.LonServiceFee,0)) else sum(cast((t1.basicFare * t2.ROE+ isnull(t1.Markup,0)) as decimal(10,2))+@BasicB2BMARKUP+ISNULL(t1.LonServiceFee,0)) end basicFare
,t1.GST
,case when c.CurrencyCode!=@Currency then
sum(cast(((t1.totalTax +ISNULL(t1.VendorServiceFee,0)) *t2.AgentROE * t2.ROE)+ (@TaxB2BMARKUP + isnull(t1.ServiceFee,0)--+ isnull(t1.gst,0) + isnull(t1.HupAmount,0) 
+ isnull(t1.BFC,0)) *t2.AgentROE  as decimal(10,2))) 
else sum(cast((t1.totalTax+ISNULL(t1.VendorServiceFee,0)) * t2.ROE + (@TaxB2BMARKUP + isnull(t1.HupAmount,0) --+ isnull(t1.ServiceFee,0) + isnull(t1.gst,0) 
+ isnull(t1.BFC,0))  as decimal(10,2))) end totalTax


,case when c.CurrencyCode !=@Currency then
sum(cast((t1.totalFare+ISNULL(t1.VendorServiceFee,0)) * t2.AgentROE * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0) + isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0) +ISNULL(t1.LonServiceFee,0)
+ isnull(t1.ServiceFee,0) + isnull(t1.gst,0) + isnull(t1.HupAmount,0)  
-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))--+ isnull(t2.ServiceFee,0) + isnull(t2.GST,0) 
 else sum(cast((t1.totalFare+ISNULL(t1.VendorServiceFee,0)) * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0)  + isnull(t1.HupAmount,0)+ isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0)
+ISNULL(t1.LonServiceFee,0) + isnull(t1.ServiceFee,0) + isnull(t1.gst,0) 
-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))--+ isnull(t2.ServiceFee,0) + isnull(t2.GST,0) 
end totalFare

,case when c.CurrencyCode!=@Currency then
sum(cast(((t1.totalTax+ISNULL(t1.VendorServiceFee,0)) *t2.AgentROE * t2.ROE)+ (@TaxB2BMARKUP + isnull(t1.HupAmount,0) 
+ isnull(t1.BFC,0)) *t2.AgentROE  as decimal(10,2)))
else sum(cast((t1.totalTax+ISNULL(t1.VendorServiceFee,0)) * t2.ROE + (@TaxB2BMARKUP + isnull(t1.HupAmount,0)
+ isnull(t1.BFC,0))  as decimal(10,2))) end TotalTaxWithoutServiceFee

,case when c.CurrencyCode !=@Currency then
sum(cast((t1.totalFare+ISNULL(t1.VendorServiceFee,0)) * t2.AgentROE * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0) + isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0) + isnull(t1.HupAmount,0)+ISNULL(t1.LonServiceFee,0)-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))  --+ isnull(t2.ServiceFee,0) + isnull(t2.GST,0) 
 else sum(cast((t1.totalFare+ISNULL(t1.VendorServiceFee,0)) * t2.ROE as decimal(10,2))) --+   isnull(t1.MCOAmount,0) 
+  isnull(t1.Markup,0)  + isnull(t1.HupAmount,0)+ isnull(t1.BFC,0) +isnull(t1.B2BMarkup,0) +ISNULL(t1.LonServiceFee,0)-(ISNULL(t1.PLBCommission,0)+ISNULL(t1.IATACommission,0)+ISNULL(t1.DropnetCommission,0))
end TotalFareWithoutServiceFee

,(CASE WHEN CHARINDEX('/',ticketNum)>0   
THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum)),0,CHARINDEX('/',SUBSTRING(ticketNum, CHARINDEX(' ', ticketNum)+1,LEN(ticketNum))))   
ELSE ticketNum END )as 'TicketNumber', 
CASE when t1.isReturn=0 then 'Single' else 'Return' end Journey,   
case   
when t2.BookingStatus=2 then 'Hold'  
WHEN t1.BookingStatus=6  THEN 'To Be Cancelled'   
WHEN t1.BookingStatus=4  THEN 'Cancelled'   
when t2.BookingStatus=0 then 'Failed'  
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
CASE WHEN t2.isReturnJourney=1 and t1.paxType='ADULT' then t1.baggage+'/'+t1.baggage   
 WHEN t2.isReturnJourney=1 and t1.paxType='CHILD' then t1.baggage+'/'+t1.baggage   
 --WHEN t2.isReturnJourney=1 and t1.paxType='INFANT' then t1.baggage+'/'+t1.baggage   
 WHEN t2.isReturnJourney=0 and t1.paxType='ADULT' then t1.baggage   
 WHEN t2.isReturnJourney=0 and t1.paxType='CHILD' then t1.baggage   
 WHEN t1.paxType='INFANT' then cast(dbo.udf_GetNumeric(isnull(t1.baggage,0)) as varchar(30)) +' Kg'
 end baggage,  
T1.isReturn ,  
t1.paxType,
pid,
case when c.CurrencyCode !=@currency then 
cast((t1.JNTax *t2.AgentROE* t2.ROE) as decimal(10,2)) else cast((t1.JNTax * t2.ROE) as decimal(10,2)) end JNTax

  
 from tblPassengerBookDetails t1  WITH(NOLOCK)
 left join tblBookMaster t2 WITH(NOLOCK) on t2.pkId=t1.fkBookMaster  
  --left join AirlinesName a2 WITH(NOLOCK) on a2._CODE=t2.airCode  
  left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t2.Country
where  t2.riyaPNR=@RiyaPNR AND (@SectorID IS NULL OR @SectorID = '' OR t2.pkId = @SectorID)
and (t1.isReturn=0 or (t1.isReturn=1 and (select count(pkId) from tblBookMaster WITH(NOLOCK) where riyaPNR=@RiyaPNR) =1))
--and  (t1.totalFare>0 or (isnull(t2.PreviousRiyaPNR,'')!=''))  
and t2.BookingStatus != 18
--and isReturnJourney=0
group by title,paxFName,paxLName,paxType,ticketNum,isReturn,t2.BookingStatus,t1.BookingStatus,t2.IsBooked,c.CurrencyCode
,t1.Markup,t1.bfc,t1.B2BMarkup,t1.GST,t1.ServiceFee,t1.HupAmount,t2.isReturnJourney,t1.baggage,t1.pid,t1.JNTax,t2.AgentROE,t2.ROE,
t1.LonServiceFee,t1.VendorServiceFee,t1.PLBCommission,t1.IATACommission,t1.DropnetCommission
order by t1.paxType,FullName asc    

--SSR Seats 
select ssr.SSR_Type
		, ssr.SSR_Name
		, tp.paxFName +' '+tp.paxLName+' ('+tp.paxType+')' FullName
		,(CASE  WHEN ISNULL(SSR.ROE,0) = 0 
                  THEN 
                 CASE WHEN c.CurrencyCode != @Currency
                 THEN CAST(ISNULL(SSR.SSR_Amount, 0) * tb.AgentROE * tb.ROE AS decimal(18, 2))
                 ELSE CAST(ISNULL(SSR.SSR_Amount, 0) * tb.ROE AS decimal(18, 2))
                END
              ELSE 
              ISNULL(SSR.SSR_Amount, 0) * SSR.ROE
              END) AS SSR_Amount
			  ,  tp.paxType			
 		
   from tblPassengerBookDetails tp		WITH(NOLOCK)
 inner JOIN tblSSRDetails SSR WITH(NOLOCK) ON SSR.fkpassengerid=tp.pid	
 inner join tblBookMaster tb  WITH(NOLOCK) on tb.pkid=SSR.fkBookMaster
 left join mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
where  tb.riyaPNR=@RiyaPNR and SSR_Type='Seat' AND SSR.SSR_Status =1 AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18
--AND isReturn = 0 -- JD || 09.03.2023

SELECT DISTINCT t.airCode
		, t.airName
		, t.flightNo
		, t.operatingCarrier
		, t.fromAirport
		, UPPER(FORMAT(CAST(t.deptTime AS DATETIME), 'dd/MM/yyyy HH:mm:ss tt')) AS deptTime
		, t.depDate
		, t.fromTerminal
		, t.toAirport
		, UPPER(FORMAT(CAST(t.arrivalTime AS DATETIME), 'dd/MM/yyyy HH:mm:ss tt')) AS arrivalTime
		, t.arrivalDate
		, t.toTerminal
		, t.farebasis
		, t.insertedOn
		, (CASE WHEN tb.airCode='IX' AND tb.bookingsource = 'Retrive PNR Accounting' THEN tb.FlightDuration
				ELSE CONVERT(Varchar(5), DATEADD(MINUTE, DATEDIFF(MINUTE, t.deptTime,t.arrivalTime), 0), 114) + ' ' 
		  END) AS Traveldifference
		, t.cabin
		, t.deptTime
		, tb.VendorName
		, ISNULL(tb.TotalTime, '') AS TotalTime
		, ISNULL('VIA : '+t.Via,'') AS Via
		, t.airlinePNR
		, UPPER(FORMAT(CAST(t.depDate AS DATETIME), 'dd-MMM-yyyy')) AS DepartDate
		, convert(char(5), t.deptTime, 108) AS DepartTime
		, t.frmSector
		, t.toSector
		, UPPER(FORMAT(CAST(t.arrivalDate AS DATETIME), 'dd-MMM-yyyy')) AS ArrivDate
		, CONVERT(CHAR(5), t.arrivalTime, 108) AS ArrivTime
		, SUBSTRING(t.fromAirport, 0, CHARINDEX('-', t.fromAirport, 0)) AS fromAirportNEW
		, SUBSTRING(t.toAirport, 0, CHARINDEX('-', t.toAirport, 0)) AS toAirportNEW
		,ISNULL(t.CarbonEmission,'') CarbonEmission

FROM tblBookItenary t WITH(NOLOCK)
LEFT JOIN tblBookItenary tbi WITH(NOLOCK) ON tbi.fkBookMaster=t.fkBookMaster
INNER JOIN tblBookMaster tb WITH(NOLOCK) ON tb.pkId=t.fkBookMaster
WHERE tb.orderId = (SELECT TOP 1 orderId FROM tblBookMaster WITH(NOLOCK) WHERE riyaPNR=@RiyaPNR ORDER BY pkId DESC) AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18
ORDER BY t.deptTime ASC 

	SELECT TOP 1 b.AgencyName
				, (AddrAddressLocation + ',' + AddrCity + ',' + AddrState + '-' + AddrZipOrPostCode) as AgencyAddressNW
				, (AddrAddressLocation + ',' + AddrCity + ',' + AddrZipOrPostCode) as Agencyaddress
				, (AddrLandlineNo + '/' + AddrMobileNo) as AgencyContact
				, AddrEmail as AgencyEmail
				, t.riyaPNR
				, UPPER(CONVERT(VARCHAR(20),FORMAT(t.IssueDate, 'dd-MMM-yyyy'))) as IssueDt
				, t.mobileNo as CustomerContactno
				, CASE WHEN t.airName like '%AIRASIA%' THEN 'NA' ELSE ISNULL(t.GDSPNR,'NA') END CRSpnr
				, tbi.airlinePNR
				, t.ValidatingCarrier as Issueby
				, tbi.aircode
			, convert(varchar(20), ISNULL(t.inserteddate_old,t.inserteddate), 103) AS BookingDate
			, pm.payment_mode
			, u.FullName as BookedBy
			, u.EmployeeNo as EmployeeCode
			, t.OfficeID as BookingTicketingSupplier
			, CASE WHEN t.MainAgentId>0 and t.BookingSource='Web' THEN 'Internal Booking (Web)'
					WHEN t.MainAgentId>0 and t.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
	      			WHEN t.MainAgentId>0 and t.BookingSource='ManualTicketing' THEN 'Manual Booking'	
					WHEN t.MainAgentId=0 and t.BookingSource='Web' THEN 'Agent Booking (Web)'
					WHEN t.MainAgentId=0 and t.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
				END  as BookingType
			, ISNULL(t.isReturnJourney,0) AS Isreturn
			, t.FareType
			, t.Country as agencyCountry
			, ISNULL(pm.currency,t.agentcurrency) as currency
			, t.DiscountGstTDS
			, ISNULL(BFC,0) AS BFC
			, CAST(ISNULL(MCOAmount,0) as decimal(10,2)) MCOAmount
			, CASE WHEN c.CurrencyCode != @currency 
					THEN CAST((t.JNTax * t.AgentROE * t.ROE) AS Decimal(10,2)) 
					ELSE CAST((t.JNTax * t.ROE) AS Decimal(10,2)) 
				END JNTax
			, CASE WHEN c.CurrencyCode != @currency 
					THEN CAST((t.YQTax * t.AgentROE * t.ROE) AS Decimal(10,2))
				ELSE CAST((t.YQTax * t.ROE) as decimal(10,2)) END YQTax
			, t.emailId
			, BookingSource
			, ag.UserTypeID
			, t.ROE
			, t.AgentID
			, t.VendorName
			, t.CounterCloseTime 
			, tbi.cabin
			, tbi.farebasis
			, GDSPNR
			, t.Country
			, FORMAT(t.IssueDate,'dd/MM/yyyy hh:mm:ss tt')  MarineIssueDate
			--JD24.08.2022
			, ISNULL(Logo, '') AS Logo
			, ISNULL(AgentLogoNew, '') AS AgentLogoNew
		,ISNULL(t.IsBooked,0) AS IsBooked
			, ISNULL(ag.GroupId, 0) AS GroupId -- Added BY JD 22.11.2022
			, ISNULL(t.HoldText, '') AS HoldText -- Added by JD 15.12.2022
		FROM tblBookMaster t WITH(NOLOCK)
		LEFT JOIN [AirlineCode_Console] ac WITH(NOLOCK) on ac.AirlineCode=t.airCode
		--inner JOIN tblPassengerBookDetails t1 on t1.fkBookMaster =t.pkId
		LEFT JOIN B2BRegistration b  WITH(NOLOCK) on b.FKUserID=t.AgentID
		LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=t.Country
		LEFT JOIN tblBookItenary tbi WITH(NOLOCK) on tbi.orderid=t.orderid and tbi.airlinePNR = ISNULL(tbi.airlinePNR, '')
		LEFT JOIN [dbo].[Paymentmaster] pm WITH(NOLOCK) on pm.order_id=t.orderid
		LEFT JOIN [mUser] u WITH(NOLOCK) on u.id=t.BookedBy
		LEFT JOIN AgentLogin ag WITH(NOLOCK) on ag.UserID=t.AgentID
		WHERE t.orderid=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR t.pkId = @SectorID)
		AND returnFlag = 0 
		AND t.AgentID != 'B2C' and t.BookingStatus != 18

		--Flight Details Marine ticket copy Viewpnr
		SELECT 
			tbi.flightNo
			,CONVERT(varchar(7), tbi.depDate, 106) depDateMarine
			,CONVERT(varchar(7), tbi.arrivalDate, 106) arrivalDateMarine
			,SUBSTRING(tbi.fromAirport, 0, charindex('[', tbi.fromAirport, 0)) fromAirportMarine
			,SUBSTRING(tbi.toAirport, 0, charindex('[', tbi.toAiRport, 0)) toAirportMarine
			,CONVERT(VARCHAR(5),tbi.deptTime,108) AS deptTimeMarine
			,CONVERT(VARCHAR(5),tbi.arrivalTime,108) AS arrivalTimeMarine
			,tbi.fromTerminal
			,tbi.toTerminal
			,tb.riyaPNR
			,tbi.airCode,
			tbi.airName, 
			upper(substring(DATENAME(weekday,tbi.deptTime),1,3)) +','+FORMAT(CAST(tbi.deptTime AS datetime), 'dd MMMM yyyy') WholeDateMarine,
			CASE WHEN tb.BookingStatus=1 AND tb.IsBooked=1 THEN  'Confirmed'  
				 WHEN tb.BookingStatus=2 THEN 'Hold'  
				 WHEN tb.BookingStatus=3 THEN 'Pending'  
				 WHEN tb.BookingStatus=4 THEN 'Cancelled'  
				 WHEN tb.BookingStatus=5 THEN 'Close'  
				 WHEN tb.BookingStatus=11 THEN 'Cancelled'  
				 WHEN tb.BookingStatus=12 THEN 'In-Process' 
			END Status
			,tbi.fromAirport
			,tbi.toAirport
			,tbi.cabin
			,tb.ROE, tb.AgentID, tb.VendorName, tb.CounterCloseTime 
			,CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, tbi.deptTime,tbi.arrivalTime), 0), 114) +' '+'Hrs.'  Traveldifference
			,CASE WHEN count(tb.pkid)=count(tbi.fkBookMaster) THEN 'Non-sTOP' END JourneyType
			,tbi.farebasis
			,faretype
			, tb.VendorName, tb.TotalTime
			, ISNULL('VIA : '+tbi.Via,'') AS Via
			,tbi.airlinepnr as AirlinePNR
		FROM tblBookItenary tbi WITH(NOLOCK)
		LEFT JOIN tblBookMaster tb WITH(NOLOCK) on tb.pkId=tbi.fkBookMaster
		WHERE tb.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18
		GROUP BY tbi.flightNo,tbi.depDate,tbi.arrivalDate,tbi.fromAirport,tbi.toAirport,tbi.deptTime,tbi.arrivalTime,tbi.fromTerminal,tbi.toTerminal
		,tb.riyaPNR,tbi.airCode,tbi.airName,tb.BookingStatus,tb.IsBooked,tbi.cabin,tbi.farebasis,tbi.airlinePNR, tb.VendorName, tb.TotalTime
		,tb.ROE, tb.AgentID, tb.VendorName, tb.CounterCloseTime ,FareType,tbi.Via
		ORDER BY tbi.deptTime asc 

		--booking details
		SELECT TOP 1
		Format(CAST(ISNULL(tb.inserteddate_old,tb.inserteddate) as datetime),'dd/MM/yyyy HH:mm:ss tt','en-us')  as BookingDate
		, pm.payment_mode
		, ISNULL(u.FullName,ag.UserName) FullName
		, CASE WHEN tb.MainAgentId>=0 and tb.BookingSource='Web' THEN 'Internal Booking (Web)'
					--afifa	
		      		WHEN tb.MainAgentId>0 and tb.BookingSource='ManualTicketing' THEN 'Manual Booking'	
					WHEN tb.MainAgentId>0 and tb.BookingSource='Retrieve PNR accounting' THEN 'PNR accounting'	
					WHEN tb.MainAgentId>0 and tb.BookingSource='Retrive PNR - MultiTST' THEN 'Retrive PNR - MultiTST'
					WHEN tb.MainAgentId>0 and tb.BookingSource='Retrive PNR Accounting' THEN 'Internal Booking (Retrive PNR Accounting)'
					WHEN tb.MainAgentId>=0 and tb.BookingSource='Retrive PNR' THEN 'Internal Booking (Retrive PNR)'
					WHEN tb.MainAgentId=0 and tb.BookingSource='Web' THEN 'Agent Booking (Web)'
					WHEN tb.MainAgentId=0 and tb.BookingSource='Retrive PNR' THEN 'Agent Booking (Retrive PNR)' 
					WHEN tb.MainAgentId>0 and tb.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Retrieve PNR accounting - MultiTST'	
					WHEN tb.MainAgentId=0 and tb.BookingSource='Retrive PNR Accounting' THEN  'Agent Booking (Retrive PNR Accounting)'	
					END  as BookingType 
		,CASE WHEN TicketingPCC!='' THEN TicketingPCC ELSE OfficeID END BookingTicketingSupplier
		,ISNULL(u.UserName,0) ID
		,ISNULL(U.ID,0) UserId
		,(SELECT TOP 1  
	   	   STUFF((SELECT '/' + bm.FareType 
	         	  FROM tblBookMaster bm WITH(NOLOCK)
	         	  WHERE bm.riyaPNR = b.riyaPNR order BY BM.pkId ASC
	         	  FOR XML PATH('')), 1, 1, '') [FareType]
		FROM tblBookMaster b WITH(NOLOCK)
		WHERE orderId = @NewOrderID and b.returnFlag=0
		GROUP BY b.riyaPNR,b.GDSPNR) FareType
		FROM tblBookMaster tb WITH(NOLOCK)
		LEFT JOIN [dbo].[Paymentmaster] pm WITH(NOLOCK) on pm.order_id=tb.orderid
		LEFT JOIN agentLogin ag WITH(NOLOCK) on ag.UserID=tb.AgentID
		LEFT JOIN [mUser] u WITH(NOLOCK) on u.id=tb.BookedBy
		WHERE tb.orderId=@NewOrderID AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID) and tb.BookingStatus != 18

		--Old PNR  payment details for Reschedule
	SELECT
		tp.isReturn,
		CASE WHEN c.CurrencyCode !=@Currency THEN
				--SUM
				(ISNULL(CAST((tP.basicFare *tb.AgentROE* tb.ROE+ISNULL(tp.Markup,0)) as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.basicFare * tb.ROE+ ISNULL(tp.Markup,0)) as decimal(10,2)),0)) 
			END basicFare
		, CASE WHEN c.CurrencyCode!=@Currency THEN
		 		--SUM
				(ISNULL(CAST(((tp.totalTax + ISNULL(tp.MCOAmount,0)) *tb.AgentROE * tb.ROE)+ (ISNULL(tb.B2BMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.gst,0) + ISNULL(tb.BFC,0)) *tb.AgentROE  as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.ROE + (ISNULL(tp.B2BMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.gst,0) + ISNULL(tb.BFC,0))  as decimal(10,2)),0))
			END  totalTax
		, CASE WHEN c.CurrencyCode !=@Currency THEN
				--SUM
				(ISNULL(CAST((tp.totalFare) * tb.AgentROE * tb.ROE  +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0)  + ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) as decimal(10,2)),0)) ELSE --SUM
				(ISNULL(CAST((tp.totalFare) * tb.ROE +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0) + ISNULL(tb.ServiceFee,0) + ISNULL(tb.GST,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0))  as decimal(10,2)),0))
			END totalFare
		, (CASE WHEN c.CurrencyCode != @Currency 
				THEN (ISNULL(CAST(((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.AgentROE * tb.ROE) + (ISNULL(tb.B2BMarkup,0) + ISNULL(tb.BFC,0)) * tb.AgentROE  AS DECIMAL(10,2)),0)) 
				ELSE (ISNULL(CAST((tp.totalTax + ISNULL(tp.MCOAmount,0)) * tb.ROE + (ISNULL(tp.B2BMarkup,0) + ISNULL(tb.BFC,0))  AS DECIMAL(10,2)),0)) 
			END) AS TotalTaxWithoutServiceFee
		
		, (CASE WHEN c.CurrencyCode != @Currency 
				THEN (ISNULL(CAST((tp.totalFare) * tb.AgentROE * tb.ROE  +   (ISNULL(tb.MCOAmount,0) +  ISNULL(tb.AgentMarkup,0)  + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0))
				ELSE (ISNULL(CAST((tp.totalFare) * tb.ROE + (ISNULL(tb.MCOAmount,0) + ISNULL(tb.AgentMarkup,0) + ISNULL(tb.BFC,0)  + ISNULL(tb.ReissueCharges,0)) AS DECIMAL(10,2)),0))
			END) AS TotalFareWithoutServiceFee
		, CASE WHEN c.CurrencyCode!=@Currency THEN
				(ISNULL(CAST(  (ISNULL(tp.RescheduleMarkup,0)*tb.AgentROE* tb.ROE) +  (ISNULL(tp.reScheduleCharge,0)*tb.AgentROE* tb.ROE )+ (ISNULL(tp.SupplierPenalty,0)*tb.AgentROE* tb.ROE)  as decimal(10,2)),0))
			ELSE --SUM 
				(ISNULL(CAST(  (ISNULL(tp.RescheduleMarkup,0)* tb.ROE ) +  (ISNULL(tp.reScheduleCharge,0)* tb.ROE ) + (ISNULL(tp.SupplierPenalty,0)* tb.ROE )  as decimal(10,2)),0)) 
			END ReschedulePenalty
		,CASE WHEN c.CurrencyCode !=@Currency 
				THEN CAST((ISNULL(tp.YQ ,0)*tb.AgentROE * tb.ROE) as decimal(10,2))
				ELSE CAST((ISNULL(tp.YQ ,0) * tb.ROE ) as decimal(10,2))
			END YQ
		,CASE WHEN c.CurrencyCode !=@Currency 
				THEN CAST((ISNULL(tp.JNTax ,0)*tb.AgentROE * tb.ROE ) as decimal(10,2))
				ELSE CAST((ISNULL(tp.JNTax ,0) * tb.ROE ) as decimal(10,2)) 
			END JNTax
		,CASE WHEN c.CurrencyCode !=@Currency
			THEN CAST(((ISNULL(tp.ExtraTax ,0)*tb.AgentROE * tb.ROE) +(ISNULL(tp.VendorServiceFee,0) * tb.ROE) +(ISNULL(tp.AirlineFee,0) * tb.ROE)) as decimal(10,2))
			ELSE CAST(((ISNULL(tp.ExtraTax ,0) * tb.ROE) +(ISNULL(tp.VendorServiceFee,0) * tb.ROE) +(ISNULL(tp.AirlineFee,0) * tb.ROE)) as decimal(10,2))
			END ExtraTax
	FROM tblBookMaster tb WITH(NOLOCK)
	LEFT JOIN tblPassengerBookDetails tp WITH(NOLOCK) on tp.fkBookMaster=tb.pkId
	LEFT JOIN mCountryCurrency c WITH(NOLOCK) on c.CountryCode=tb.Country
	WHERE tb.riyaPNR= (SELECT TOP 1 PreviousRiyaPNR FROM tblBookMaster WITH(NOLOCK) WHERE orderId= @NewOrderID) AND (@SectorID IS NULL OR @SectorID = '' OR tb.pkId = @SectorID)
	and ISNULL(tp.reScheduleCharge,0) = 0 and tb.totalFare>0 and tb.BookingStatus != 18
end  
  
  