--USE [RiyaTravels]


CREATE proc [dbo].[TrvlNxt_hotel_Daily_sales_report]          
as           
begin          
          
   
   
   ---- new with hotel with activities  and transfer


   CREATE TABLE #trans (
    RiyaAgentID NVARCHAR(50),
    pkId INT,
    AgencyName NVARCHAR(100),
    BranchCode NVARCHAR(50),
    StateName NVARCHAR(100),
    FkStatusId INT,
    Branch NVARCHAR(100),
    BD NVARCHAR(50),
    DisplayDiscountRate DECIMAL(18,2),
    inserteddate DATETIME,
    StatusName NVARCHAR(10),
    StatusNameA NVARCHAR(10),
	Product NVARCHAR(30),
	orderby int
);

-- Insert the first part of the query into #trans

---------- insert Hotel query -------------------------

INSERT INTO #trans
SELECT DISTINCT TOP 5000
    HB.RiyaAgentID,          
    HB.pkId,          
    B.AgencyName,          
    B.BranchCode,           
    CASE 
        WHEN B.country = 'INDIA' THEN ISNULL(MS.StateName, B.country)  
        ELSE B.country 
    END AS StateName,          
    HSH.FkStatusId,          
    CASE 
        WHEN B.country = 'India' THEN mybranch.[Name] 
        ELSE mbs.[Name] 
    END AS Branch,
    B.BranchCode AS BD,            
    CAST((HB.DisplayDiscountRate * ISNULL(HB.FinalROE, 1)) AS DECIMAL(18, 2)) AS DisplayDiscountRate,          
    HB.inserteddate,            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'V'  
        WHEN HSH.FkStatusId = 3 THEN 'V'  
        ELSE 'C' 
    END AS StatusName,            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'VA'  
        WHEN HSH.FkStatusId = 3 THEN 'VA'  
        ELSE 'CA' 
    END AS StatusNameA,
	'Hotel' as Product,
	100 as orderby
FROM Hotel_BookMaster HB WITH (NOLOCK)            
LEFT JOIN B2BRegistration B WITH (NOLOCK) ON HB.RiyaAgentID = B.FKUserID 
LEFT JOIN agentLogin al WITH (NOLOCK) ON B.FKUserID = al.UserID
LEFT JOIN Hotel_Status_History HSH WITH (NOLOCK) ON HSH.FKHotelBookingId = HB.pkId            
LEFT JOIN mState MS WITH (NOLOCK) ON MS.ID = B.StateID             
LEFT JOIN mbranch mbs WITH (NOLOCK) ON B.BranchCode = mbs.BranchCode AND B.country = mbs.branch_country
LEFT JOIN (
    SELECT 
        mbr.BranchCode,
        MAX(mbr.[Name]) AS 'Name',
        MAX(mbr.Division) AS 'Division',
        MAX(mbr.id) AS maxid 
    FROM mBranch mbr
    GROUP BY mbr.BranchCode
) AS mybranch
ON B.BranchCode = mybranch.BranchCode
--WHERE AgencyName NOT IN ('HOTELTEST IND', 'UAETESTID HOTEL') 
WHERE B.PKID NOT IN (34715,34752,29212,51037,52245) 
AND HSH.FkStatusId IN (3, 4, 7) 
AND HSH.IsActive = 1            
AND CONVERT(DATE, HB.inserteddate) = CONVERT(DATE, GETDATE() - 1);



---Activities ------------

-- Insert the second part of the query into #trans
INSERT INTO #trans
SELECT DISTINCT TOP 2000
    BM.AgentID AS 'RiyaAgentID',
    BM.BookingId AS 'pkId',
    B.AgencyName,          
    B.BranchCode,
    CASE 
        WHEN B.country = 'INDIA' THEN ISNULL(MS.StateName, B.country)  
        ELSE B.country 
    END AS StateName,          
    HSH.FkStatusId,          
    CASE 
        WHEN B.country = 'India' THEN mybranch.[Name] 
        ELSE mbs.[Name] 
    END AS Branch,
    B.BranchCode AS BD,
    CAST((BM.BookingRate * ISNULL(BM.FinalROE, 1)) AS DECIMAL(18, 2)) AS DisplayDiscountRate,          
    BM.creationDate AS 'inserteddate',            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'V'  
        WHEN HSH.FkStatusId = 3 THEN 'V'  
        ELSE 'C' 
    END AS StatusName,            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'VA'  
        WHEN HSH.FkStatusId = 3 THEN 'VA'  
        ELSE 'CA' 
    END AS StatusNameA,
	'Activities' as Product,
	200 as orderby
FROM SS.SS_BookingMaster BM WITH (NOLOCK)            
LEFT JOIN B2BRegistration B WITH (NOLOCK) ON BM.AgentID = B.FKUserID
LEFT JOIN SS.SS_Status_History HSH WITH (NOLOCK) ON HSH.BookingId = BM.BookingId            
LEFT JOIN mState MS WITH (NOLOCK) ON MS.ID = B.StateID             
LEFT JOIN mbranch mbs WITH (NOLOCK) ON B.BranchCode = mbs.BranchCode AND B.country = mbs.branch_country
LEFT JOIN (
    SELECT 
        mbr.BranchCode,
        MAX(mbr.[Name]) AS 'Name',
        MAX(mbr.Division) AS 'Division',
        MAX(mbr.id) AS maxid 
    FROM mBranch mbr
    GROUP BY mbr.BranchCode
) AS mybranch
ON B.BranchCode = mybranch.BranchCode
WHERE B.PKID NOT IN (34715,34752,29212,51037,52245) 
AND HSH.FkStatusId IN (3, 4, 7) 
AND HSH.IsActive = 1            
AND CONVERT(DATE, BM.creationDate) = CONVERT(DATE, GETDATE() - 1);

--- Insert transfer part in query into #trans  ----

INSERT INTO #trans
SELECT DISTINCT TOP 2000
    BM.AgentID AS 'RiyaAgentID',
    BM.BookingId AS 'pkId',
    B.AgencyName,          
    B.BranchCode,
    CASE 
        WHEN B.country = 'INDIA' THEN ISNULL(MS.StateName, B.country)  
        ELSE B.country 
    END AS StateName,          
    HSH.FkStatusId,          
    CASE 
        WHEN B.country = 'India' THEN mybranch.[Name] 
        ELSE mbs.[Name] 
    END AS Branch,
    B.BranchCode AS BD,
    CAST(BM.AmountBeforePgCommission AS DECIMAL(18, 2)) AS DisplayDiscountRate,          
    BM.creationDate AS 'inserteddate',            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'V'  
        WHEN HSH.FkStatusId = 3 THEN 'V'  
        ELSE 'C' 
    END AS StatusName,            
    CASE 
        WHEN HSH.FkStatusId = 4 THEN 'VA'  
        WHEN HSH.FkStatusId = 3 THEN 'VA'  
        ELSE 'CA' 
    END AS StatusNameA,
	'Transfer' as Product,
	300 as orderby 
FROM  TR.TR_BookingMaster BM WITH (NOLOCK)            
LEFT JOIN B2BRegistration B WITH (NOLOCK) ON BM.AgentID = B.FKUserID
LEFT JOIN TR.TR_Status_History  HSH WITH (NOLOCK) ON HSH.BookingId = BM.BookingId            
LEFT JOIN mState MS WITH (NOLOCK) ON MS.ID = B.StateID             
LEFT JOIN mbranch mbs WITH (NOLOCK) ON B.BranchCode = mbs.BranchCode AND B.country = mbs.branch_country
LEFT JOIN (
    SELECT 
        mbr.BranchCode,
        MAX(mbr.[Name]) AS 'Name',
        MAX(mbr.Division) AS 'Division',
        MAX(mbr.id) AS maxid 
    FROM mBranch mbr
    GROUP BY mbr.BranchCode
) AS mybranch
ON B.BranchCode = mybranch.BranchCode
WHERE B.PKID NOT IN (34715,34752,29212,51037,52245) 
AND HSH.FkStatusId IN (3, 4, 7) 
AND HSH.IsActive = 1            
AND CONVERT(DATE, BM.creationDate) = CONVERT(DATE, GETDATE() - 1);


      
          
WITH CTE as (          
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName ,branch,          
 StatusNameA,Product,orderby  from #trans where FkStatusId in (3, 4)          
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA, branch,Product ,orderby         
Union          
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName ,branch,          
 StatusNameA,Product,orderby  from #trans  where FkStatusId = 7          
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA, branch,Product, orderby        
)          
Select * INTO #FN  from CTE order by 4 asc          
          

           
          
select * INTO #CNTR          
from          
(          
  select Cnt, AgencyName,StateName,StatusName,Branch,Product,orderby          
  from #FN          
) src          
pivot          
(          
  sum(Cnt)  for StatusName in ([C],[V])          
) piv          
        

          
          
select * INTO #AMTR          
from          
(          
  select amt, AgencyName,StateName,StatusNameA,Branch,Product,orderby          
  from #FN          
) src          
pivot          
(          
  sum(amt)  for StatusNameA in ([CA],[VA])          
) piv2        


-----------------------------------------------------------------          
          
select * into #temp5 from (          
Select  ROW_NUMBER() OVER(ORDER BY C.StateName ASC) AS [Sr.No], C.StateName as [State Name], C.AgencyName as [Agency Name],          
ISNULL(C.V,0) as [Voucher Count], ISNULL(C.C,0) as [Cancellation Count],          
ISNULL(A.VA,0) as [Voucher Amount],ISNULL(A.CA,0) as [Cancellation Amount],ISNULL(C.Branch,'') as [Branch],          
(ISNULL(A.VA,0) - ISNULL(A.CA,0)) as [Net Total]
,c.Product as [Product], c.orderby as [orderby]
from #CNTR C          
LEFT JOIN #AMTR A ON C.AgencyName = A.AgencyName and c.Product=a.Product 

) as t          
          
select * into #temp6 from #temp5 order by [orderby] , [State Name],[Agency Name],[Product] asc;            
          
          
          
          
          
Select * INTO #finaltable from (       
          
select * from #temp6          
          
UNION ALL          
          
select '-' AS [Sr.No], '' as [State Name], 'TOTAL' as [Agency Name],          
SUM(ISNULL(C.V,0)) as [Voucher Count], SUM(ISNULL(C.C,0)) as [Cancellation Count],          
SUM(ISNULL(A.VA,0)) as [Voucher Amount], SUM(ISNULL(A.CA,0)) as [Cancellation Amount],'' as [Branch],          
SUM(ISNULL(A.VA,0) - ISNULL(A.CA,0)) as [Net Total] 
,'-' as [Product], 9999 as [orderby]
from #CNTR C          
LEFT JOIN #AMTR A ON C.AgencyName = A.AgencyName          
) as ft;          
          

Select * from #finaltable order by  [orderby] asc,Product desc,[Agency Name] asc


DECLARE @xml NVARCHAR(MAX)          
DECLARE @xml1 NVARCHAR(MAX)          
DECLARE @body NVARCHAR(MAX)          
DECLARE @body1 NVARCHAR(MAX)          
          

          
--SET @xml = CAST((          
--Select [Sr.No] AS 'td','',ISNULL([State Name],'') AS 'td','' ,[Agency Name] AS 'td','' ,ISNULL([branch],'') AS 'td','' ,[Voucher Count] AS 'td','',[Cancellation Count] AS 'td','',          
--[Voucher Amount] AS 'td','',[Cancellation Amount] AS 'td','',[Net Total] AS 'td','',[Product] AS 'td','' 
--from #finaltable A  order by [orderby] asc, [Agency Name] asc     
----order by 6 asc          
--FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))          
---as per request changing value to amount need in money format -- above is old code..
SET @xml = CAST((
    SELECT 
        [Sr.No] AS 'td','',
        ISNULL([State Name],'') AS 'td','',
        [Agency Name] AS 'td','',
        ISNULL([branch],'') AS 'td','',
        ISNULL([Voucher Count],0) AS 'td','',
        ISNULL([Cancellation Count],0) AS 'td','',

        -- Voucher Amount with comma + 2 decimals
        FORMAT(ISNULL([Voucher Amount],0), 'N2') AS 'td','',

        -- Cancellation Amount with comma + 2 decimals
        FORMAT(ISNULL([Cancellation Amount],0), 'N2') AS 'td','',

        -- Net Total with comma + 2 decimals
        FORMAT(ISNULL([Net Total],0), 'N2') AS 'td','',

        [Product] AS 'td',''
    FROM #finaltable A  
    ORDER BY [orderby] ASC, [Agency Name] ASC     
    FOR XML PATH('tr'), ELEMENTS 
) AS NVARCHAR(MAX));

          
          
          
Drop table #trans          
Drop table #FN          
Drop table #CNTR          
Drop table #AMTR          
Drop table #finaltable          
drop table #temp5          
drop table #temp6          
DECLARE @s VARCHAR(max)          
          
SET @body ='<html>          
<head> <style type="text/css">.styled-table { border-collapse: collapse; margin: 25px 0; font-size: 0.9em; font-family: sans-serif; min-width: 400px; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15); }          
.styled-table thead tr { background-color: #009879; color: #ffffff; text-align: left; }           
.styled-table th, .styled-table td { padding: 12px 15px; } .styled-table tbody tr { border-bottom: 1px solid #dddddd; }           
.styled-table tbody tr:nth-of-type(even) { background-color: #f3f3f3; } .styled-table tbody tr:last-of-type { border-bottom: 2px solid #009879; }          
.styled-table tbody tr.active-row { font-weight: bold; color: #009879; } table tr:last-child {font-weight: bold;} </style> </head>          
<body><H3>TrvlNxt Hotel And Activities Daily sales report '+CONVERT(VARCHAR(12),GETDATE()-1,107)+'</H3>          
<table class="styled-table"> <thead>          
<tr>          
<th> Sr.No </th> <th> State Name </th> <th> Agency Name </th> <th> Branch </th> <th> Voucher Count </th><th> Cancellation Count </th>          
<th> Voucher Amount </th> <th> Cancellation Amount </th> <th> Net Total  </th>  <th> Product  </th>        
</tr>          
</thead> <tbody>'           
          
SET @body1 = 'TrvlNxt Hotel, Activities and Transfer Daily sales report '+CONVERT(VARCHAR(12),GETDATE()-1,107)            
          
SET @body = @body + @xml +'</tbody></table></body></html>'          
SET @s = 'TrvlNxt Hotel, Activities and Transfer Daily sales report '+CONVERT(VARCHAR(12),GETDATE()-1,107);          
          
          
EXEC msdb.dbo.sp_send_dbmail          
@profile_name = 'dba_automations',           
--@from_address = 'noreply@riya.travel',           
@from_address = 'noreply@riya.travel',            
  @recipients = 'nitin@riya.travel;priti.kadam@riya.travel;ashley.paul@riya.travel;fahad.anwar@riya.travel;purav.modi@riya.travel;amol.patil@riya.travel;    
  Harshit.gor@riya.travel;faizan.shaikh@riya.travel;shraddha.achrekar@riya.travel;kapil.sharma@riya.travel;    
  sarfaraz.siddique@riya.travel;tnsupport.hotels@riya.travel;jagruti.patel@riya.travel;ashish.patil@riya.travel;rajat.panwar@riya.travel', 
--@recipients ='gary.fernandes@riya.travel;bhushan.developers@riya.travel',
@blind_copy_recipients='aman.developers@riya.travel;gary.fernandes@riya.travel;aman.wagde@oneriya.com',          
          
@subject=@s,          
@body = @body,          
@body_format ='HTML',          
          
@execute_query_database = 'Riyatravels';          
          
end