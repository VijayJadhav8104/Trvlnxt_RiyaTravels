CREATE procedure [dbo].[RPT_APITicketCount_GroupWise]                        
@FromDate Datetime,                                              
@Todate Datetime                        
as                                              
begin    
--Table 1
select 
br.AgencyName,
br.Icast Cust,
COUNT(pb.TicketNumber) Count
from tblBookMaster bm inner join tblPassengerBookDetails pb
on bm.pkId=pb.fkBookMaster
left join B2BRegistration br on bm.AgentID=br.FKUserID
where 
br.FKUserID in (select distinct AgentID from APIAuthenticationMaster)
and bm.BookingSource='API'
and bm.IsBooked=1
 AND BM.totalFare > 0
and bm.BookingStatus=1
and CONVERT(date,bm.inserteddate) >= CONVERT(date, @FromDate) and CONVERT(date,bm.inserteddate) <= CONVERT(date, @Todate) 
group by 
br.AgencyName ,br.Icast

--Table 2
select 
br.AgencyName,
bm.VendorName API,
COUNT(pb.TicketNumber) Count
from tblBookMaster bm inner join tblPassengerBookDetails pb
on bm.pkId=pb.fkBookMaster
LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
left join B2BRegistration br on bm.AgentID=br.FKUserID
where 
br.FKUserID in (select distinct AgentID from APIAuthenticationMaster)
and bm.BookingSource='API'
and bm.IsBooked=1
 AND BM.totalFare > 0
and bm.BookingStatus=1
and CONVERT(date,bm.inserteddate) >= CONVERT(date, @FromDate) and CONVERT(date,bm.inserteddate) <= CONVERT(date, @Todate) 
group by 
br.AgencyName, bm.VendorName,CC.CurrencyCode

--Table 3
select 
br.AgencyName,
bm.VendorName API,
COUNT(case when len(APITrackID)>10 then 1 end) [Booking Count],
COUNT(case when  subbookingsource ='PNR Accounting'  then 1 end) [PNR Accounting Count],
COUNT(case when  subbookingsource ='Retrieve PNR'  then 1 end) [Retrieve PNR Count]
from tblBookMaster bm inner join tblPassengerBookDetails pb
on bm.pkId=pb.fkBookMaster
LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
left join B2BRegistration br on bm.AgentID=br.FKUserID
where 
br.FKUserID in (select distinct AgentID from APIAuthenticationMaster)
and bm.BookingSource='API'
and bm.IsBooked=1
 AND BM.totalFare > 0
and bm.BookingStatus=1
and CONVERT(date,bm.inserteddate) >= CONVERT(date, @FromDate) and CONVERT(date,bm.inserteddate) <= CONVERT(date, @Todate) 
group by 
br.AgencyName, bm.VendorName,CC.CurrencyCode


--DECLARE @USExcRate DECIMAL(18, 2)  
-- SET @USExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='USD' AND ToCur='INR' ORDER BY Id DESC)  
-- DECLARE @CanadaExcRate DECIMAL(18, 2)  
-- SET @CanadaExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='CAD' AND ToCur='INR' ORDER BY Id DESC)  
-- DECLARE @UAEExcRate DECIMAL(18, 2)  
-- SET @UAEExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='AED' AND ToCur='INR' ORDER BY Id DESC)  
-- DECLARE @GBPExcRate DECIMAL(18, 2)  
-- SET @GBPExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='GBP' AND ToCur='INR' ORDER BY Id DESC)  
-- declare @LimitValue decimal(18,2)
-- set @LimitValue =10000

-- select 
--   vw.VendorName as [Vendor Name],
--sum(vw.SuccessTicketCount)  as [Success TicketCount],
--sum(vw.FailureTicketCount) as [Failure TicketCount],
--sum(vw.TotalSales)   AS [Total Sales] 
--from (
--select  bm.VendorName,
--COUNT(case when IsBooked=1 then 1 end) SuccessTicketCount,
--COUNT(case when IsBooked!=1 then 1 end) FailureTicketCount,
--CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS TotalSales  
----CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS TotalSales 
--from tblBookMaster bm inner join tblPassengerBookDetails pb
--on bm.pkId=pb.fkBookMaster
--LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
--where 
--bm.BookingSource='API'
--and CONVERT(date,bm.IssueDate) >= CONVERT(date, @FromDate) and CONVERT(date,bm.IssueDate) <= CONVERT(date, @Todate) 
--group by 
--bm.VendorName,CC.CurrencyCode)   as vw   
--group by  vw.VendorName 
                                              
end 