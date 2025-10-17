CREATE PROCEDURE [dbo].[AgentBalanceDiscrepancyScheduler]  --AgentBalanceDiscrepancyScheduler '2025-04-20','Check','AE'           
 @TodayDate varchar(50) = ''          
 ,@PaymentMode varchar(50) = ''          
 ,@Country varchar(50) = ''          
AS          
BEGIN           
          
--Ticket issued but payment master and agent balance amount mismatch        
select (select top 1 AgencyName +' ( ' + CustomerCOde +' )'  from B2BRegistration where FKUserID = ab.AgentNo) as AgencyName         
,Convert(decimal(18,2),p.amount) as PaymentMasterAmount         
,ab.TranscationAmount as AgentTranscationAmount         
,ab.CloseBalance as AgentCloseBalance         
,(select top 1 AgentBalance From agentLogin WITH (NOLOCK) where UserID = ab.AgentNo) as AgentBalance         
,b.GDSPNR         
,b.riyaPNR  as RiyaPNR       
,b.orderId  as OrderID        
from tblBookMaster b WITH (NOLOCK) 
inner join Paymentmaster p WITH (NOLOCK) on p.order_id=b.orderId     
inner join agentLogin A WITH (NOLOCK) on A.UserID=b.AgentID AND B.AgentID !='B2C'   
left join tblAgentBalance ab WITH (NOLOCK) on ab.BookingRef=p.order_id         
where b.IsBooked=1         
and b.BookingStatus=1         
and b.totalFare > 0         
and p.payment_mode=@PaymentMode         
--and b.Country=@Country  
and (b.Country ='AE' OR (b.Country='IN' AND A.userTypeID=2 and a.BalanceFetch='Console'))
and CONVERT(date,b.inserteddate) >= CONVERT(date,@TodayDate)         
and (CONVERT(decimal(18,2), p.amount) != CONVERT(decimal(18,2), ab.TranscationAmount)              
OR (ab.TranscationAmount is null  or ab.TranscationAmount=0 or CONVERT(decimal(18,2), p.amount) is null or p.amount = 'null' or CONVERT(decimal(18,2), p.amount) =0))           
order by b.PKID desc          
          
--Console agency balance close balance less than zero and country UAE      
select           
          
(select top 1 AgencyName +' ( ' + CustomerCOde +' )'  from B2BRegistration where FKUserID = AgentNo) as AgencyName          
,TranscationAmount as AgentTranscationAmount          
,CloseBalance as AgentCloseBalance          
,(select top 1 AgentBalance From agentLogin WITH (NOLOCK) where UserID = AgentNo) as AgentBalance          
          
from tblAgentBalance as ab WITH (NOLOCK) inner join AgentLogin as al WITH (NOLOCK) on ab.AgentNo = al.UserID          
where CloseBalance < 0          
--and al.Country in ( 'UAE') 
and (al.Country ='UAE' OR (al.Country='INDIA' AND al.userTypeID=2 and al.BalanceFetch='Console'))
and  CONVERT(date,CreatedOn) >= CONVERT(date,@TodayDate)          
            
--agent balance tally amount and opening balance mismatch       
        
CREATE table #tmp(        
AgencyName varchar(255) ,OpenBalance money ,TranscationAmount money ,CloseBalance money ,TransactionType varchar(20) ,tally money ,DiscrepancyAmount money )  INSERT INTO #tmp select c.AgencyName ,OpenBalance ,TranscationAmount ,CloseBalance ,TransactionType       
,(case when TransactionType='Debit' then OpenBalance-TranscationAmount else OpenBalance+TranscationAmount end) as tally ,(CloseBalance-(( case when TransactionType='Debit' then OpenBalance-TranscationAmount else OpenBalance+TranscationAmount end)))  as   
  
   
 'DiscrepancyAmount' from tblAgentBalance a WITH (NOLOCK) inner join agentLogin b WITH (NOLOCK) on b.UserID=a.AgentNo inner join B2BRegistration c WITH (NOLOCK) on c.FKUserID=a.AgentNo where CONVERT(date,CreatedOn) >= CONVERT(date,@TodayDate) 
-- and b.Country IN ( 'UAE') 
 and (b.Country ='UAE' OR (b.Country='INDIA' AND b.userTypeID=2 and b.BalanceFetch='Console'))
 order by AgentNo,a.PKID desc        
 select * From #tmp where DiscrepancyAmount != 0        
 drop table #tmp        
        
--Confirmed booking status failed or ticket no not updatated track        
        
select b.AgentID      
, b.IsBooked       
,b.BookingStatus       
,p.ticketNum as TicketNum      
,p.TicketNumber       
,bookingsource       
,vendorname as VendorName      
,Country       
,GDSPNR       
,riyaPNR as RiyaPNR      
from tblBookMaster b WITH (NOLOCK) inner join tblPassengerBookDetails p WITH (NOLOCK) on p.fkBookMaster=b.pkId       
where CONVERT(date,inserteddate_old) >= CONVERT(date,@TodayDate)       
and ((IsBooked=1 and b.BookingStatus=0) or (IsBooked=0 and b.BookingStatus=1)       
or ((p.ticketNum is null or p.TicketNumber is null  or p.ticketNum='' or p.TicketNumber=''  )       
and (IsBooked=1 or b.BookingStatus=1))) and BookingSource!='Desktop' order       
by pkId desc         
        
--payment master amount is not inserted tracks   
  
select p.mer_amount ,(select top 1 AgencyName +' ( ' + CustomerCOde +' )'  from B2BRegistration where FKUserID = b.AgentID) as AgencyName   ,b.AgentID ,b.vendorname  ,b.AgentCurrency  ,b.GDSPNR  ,b.riyaPNR asRiyaPNR  from tblBookMaster b WITH (NOLOCK) left join Paymentmaster p WITH (NOLOCK) on p.order_id=b.orderId where IsBooked=1  and BookingStatus=1  and totalFare > 0 and CONVERT(date,inserteddate_old) >= CONVERT(date,@TodayDate) and p.mer_amount is null     
   
      
--agent id not saved tracks      
select b.AgentID ,b.MainAgentId ,b.vendorname as VendorName ,b.AgentCurrency  ,b.GDSPNR  ,b.riyaPNR as RiyaPNR from tblBookMaster b WITH (NOLOCK) where IsBooked=1 and BookingStatus=1 and CONVERT(date,inserteddate_old) >= CONVERT(date,@TodayDate) and AgentID != 'B2C' AND AgentID='0'        
      
--Booking confirmed but status failed tracks      
      
select b.AgentID ,b.MainAgentId ,b.vendorname as VendorName ,b.AgentCurrency  ,b.GDSPNR  ,b.riyaPNR as RiyaPNR      
,b.orderId as OrderID      
,b.BookingSource      
,b.Country      
from tblBookMaster b WITH (NOLOCK)      
inner join tblPassengerBookDetails p WITH (NOLOCK) on p.fkBookMaster=b.pkId      
where CONVERT(date,inserteddate_old) >= CONVERT(date,@TodayDate)      
and ((IsBooked=1 and b.BookingStatus=0) or (IsBooked=0 and b.BookingStatus=1)      
or ((p.ticketNum is null or p.TicketNumber is null      
or p.ticketNum='' or p.TicketNumber=''  ) and (IsBooked=1 or b.BookingStatus=1)))      
and BookingSource!='Desktop'      
and AgentID != 'B2C'      
order by pkId desc      
      
--agent account statement mismatched agents      
      
select j.AgencyName,(select  CustomerCOde from B2BRegistration where AgencyName like '%'+j.AgencyName+'%') as CustID      
,count(j.AgencyName)-1 as [Transaction] from (select top 1000 c.AgencyName,OpenBalance,TranscationAmount,CloseBalance,TransactionType,agentno,a.PKID       
from tblAgentBalance  a with (nolock)      
inner join agentLogin b with (nolock)on b.UserID=a.AgentNo      
inner join B2BRegistration c with (nolock)on c.FKUserID=a.AgentNo      
where CONVERT(date,CreatedOn) >= CONVERT(date,@TodayDate)
--and b.Country IN ( 'UAE')       
and (b.Country ='UAE' OR (b.Country='INDIA' AND b.userTypeID=2 and b.BalanceFetch='Console'))
and OpenBalance != (select CloseBalance from (      
(select top 1 CloseBalance,CreatedOn from      
(select top 2 CloseBalance,CreatedOn from tblAgentBalance d      
where agentno=a.AgentNo and CONVERT(date,CreatedOn) >= CONVERT(date,@TodayDate)      
and CreatedOn<=a.CreatedOn      
order by CreatedOn desc) e order by e.CreatedOn asc)) i)      
order by AgentNo,a.CreatedOn desc ) j      
group by j.AgencyName      
having count(AgencyName)>1      
      
      
-- Issue date is wrong riya pnr
CREATE table #tmp1(          
inserteddate datetime ,issuedate datetime2 ,bookingsource varchar(50) ,vendorname varchar(50) ,riyapnr varchar(20) ,inserteddate_old datetime)   

INSERT INTO #tmp1  
select  inserteddate,issuedate,bookingsource,vendorname,riyapnr,inserteddate_old from tblbookmaster  with (nolock)
where year(issuedate)=2024 and year(inserteddate)=2023 and issuedate > DATEADD(DAY, -5, GETDATE()) 
order by pkid desc  

INSERT INTO #tmp1  
select  inserteddate,issuedate,bookingsource,vendorname,riyapnr,inserteddate_old from tblbookmaster  with (nolock) 
where year(issuedate)=2024 and year(inserteddate)=2022 and issuedate > DATEADD(DAY, -5, GETDATE()) 
order by pkid desc  

INSERT INTO #tmp1  
select  inserteddate,issuedate,bookingsource,vendorname,riyapnr,inserteddate_old from tblbookmaster  with (nolock) 
where year(issuedate)=2024 and year(inserteddate)=2021 and issuedate > DATEADD(DAY, -5, GETDATE()) 
order by pkid desc  

select * From #tmp1     
drop table #tmp1;     
   
--close balance and agent balance mismatch   

WITH RankedAgents AS (
    SELECT 
        AgentNo,
        CloseBalance,
        ROW_NUMBER() OVER (PARTITION BY AgentNo ORDER BY createdon DESC) AS rn
    FROM 
        tblAgentBalance WITH (NOLOCK)
)
SELECT 
    br.Icast ICUST, 
    CloseBalance,al.AgentBalance
FROM 
    RankedAgents r inner join agentLogin al  WITH (NOLOCK) on al.UserID=r.AgentNo
	inner join B2BRegistration br  WITH (NOLOCK)  on  br.FKUserID =al.UserID
WHERE 
    rn = 1 and CloseBalance=0 and CloseBalance !=AgentBalance and al.userTypeID !=3

-- ServiceFee_GST TravelValidityTo, SaleValidityTo check
select UserType,MarketPoint,AirportType,AirlineType,AgencyNames,TravelValidityTo,SaleValidityTo 
from tbl_ServiceFee_GST_QuatationDetails  WITH (NOLOCK)            
where (CONVERT(date,TravelValidityTo) <= CONVERT(date,GETDATE()) 
or CONVERT(date,SaleValidityTo) <= CONVERT(date,GETDATE())) and Flag=1


--Markup  TravelValidityTo, SaleValidityTo check
select UserType,MarketPoint,AirportType,AirlineType,CRSType, AvailabilityPCC,TransactionType, AgencyNames,TravelValidityTo,SaleValidityTo 
from Flight_MarkupType  WITH (NOLOCK)            
where (CONVERT(date,TravelValidityTo) <= CONVERT(date,GETDATE()) 
or CONVERT(date,SaleValidityTo) <= CONVERT(date,GETDATE())) and Flag=1

--FlightCommission  TravelValidityTo, SaleValidityTo check

select UserType,MarketPoint,AirportType,AirlineType,c.CRSName, AvailabilityPCC, ConfigurationType,AgencyNames,TravelValidityTo,SaleValidityTo 
from FlightCommission  f WITH (NOLOCK)   
LEFT join tbl_commonmaster c with (nolock)on f.CRSType=c.pkid  
where (CONVERT(date,TravelValidityTo) <= CONVERT(date,GETDATE()) 
or CONVERT(date,SaleValidityTo) <= CONVERT(date,GETDATE())) and Flag=1
      
END