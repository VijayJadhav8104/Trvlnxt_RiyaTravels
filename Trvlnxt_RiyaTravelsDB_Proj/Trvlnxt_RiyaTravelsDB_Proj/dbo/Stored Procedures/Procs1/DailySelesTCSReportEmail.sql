  
  
CREATE procedure DailySelesTCSReportEmail  
AS  
Begin  
    Select distinct top 500 HB.RiyaAgentID,            
HB.pkId,            
B.AgencyName,            
B.BranchCode,             
case when  B.country='INDIA' or B.country like '%INDIA%' then Isnull(MS.StateName,b.country)  else b.country end as StateName,            
HSH.FkStatusId,            
Isnull(mybranch.Name,al.City) as [Branch],               
B.BranchCode as BD,              
            
cast((HB.DisplayDiscountRate * isnull(HB.FinalROE,1)) as decimal(18,2)) as DisplayDiscountRate,            
HB.inserteddate              
,case when (HSH.FkStatusId = 4 ) then 'V'  when (HSH.FkStatusId = 3) then 'V'  else 'C' end as StatusName,              
case when (HSH.FkStatusId = 4) then 'VA' when (HSH.FkStatusId = 3) then 'VA' else 'CA' end as StatusNameA              
INTO #trans              
from Hotel_BookMaster HB WITH (NOLOCK)              
LEFT JOIN B2BRegistration B WITH (NOLOCK) ON HB.RiyaAgentID = B.FKUserID   
left join agentLogin al WITH (NOLOCK) ON B.FKUserID=al.UserID  
LEFT JOIN Hotel_Status_History HSH WITH (NOLOCK) ON HSH.FKHotelBookingId = HB.pkId         
left join mUser mu on mu.ID=HB.MainAgentID       
left join mAgentGroup MAG on MAG.Id=AL.GroupId     
LEFT JOIN mState MS WITH (NOLOCK) ON MS.ID = B.StateID              
left join(                                                                  
  select [Name],Code,BranchCode from mBranch as mbr  group by BranchCode,Code,[Name]                                                                                                                                                                           
           
   )  as mybranch                                                                                                                     
 on b.LocationCode=mybranch.Code   
        
where AgencyName not in ('HOTELTEST IND','UAETESTID HOTEL') and HSH.FkStatusId in (3,4,7) and HSH.IsActive = 1              
--and Convert(date, HB.inserteddate) = Convert(date, GETDATE()-1);   
  and AL.userTypeID=5  and B.EntityName='TATA CONSULTANCY SERVICES LIMITED'   
  --and B.EntityName='HCL TECHNOLOGIES LIMITED'                                                  
  and HB.BookingPortal in('TNH','TNHAPI')                                 
  and HB.RiyaAgentID is not null                                                                                                                                                           
  --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')     
  and (Convert(date,HSH.CreateDate) >= Convert(date,getdate()));         
            
           
            
WITH CTE as (            
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName ,branch,            
 StatusNameA  from #trans where FkStatusId in (3, 4)            
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA, branch            
Union            
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName ,branch,            
 StatusNameA  from #trans  where FkStatusId = 7            
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA, branch            
)            
Select * INTO #FN  from CTE order by 4 asc            
            
       
select * INTO #CNTR            
from            
(            
  select Cnt, AgencyName,StateName,StatusName,Branch            
  from #FN            
) src            
pivot            
(            
  sum(Cnt)  for StatusName in ([C],[V])            
) piv            
            
            
            
select * INTO #AMTR            
from            
(            
  select amt, AgencyName,StateName,StatusNameA,Branch            
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
(ISNULL(A.VA,0) - ISNULL(A.CA,0)) as [Net Total] from #CNTR C            
LEFT JOIN #AMTR A ON C.AgencyName = A.AgencyName            
            
) as t            
            
select * into #temp6 from #temp5 order by [State Name],[Agency Name] asc            
           
Select * INTO #finaltable from (         
            
select * from #temp6            
            
UNION ALL            
            
select '-' AS [Sr.No], '' as [State Name], 'TOTAL' as [Agency Name],            
SUM(ISNULL(C.V,0)) as [Voucher Count], SUM(ISNULL(C.C,0)) as [Cancellation Count],            
SUM(ISNULL(A.VA,0)) as [Voucher Amount], SUM(ISNULL(A.CA,0)) as [Cancellation Amount],'' as [Branch],            
SUM(ISNULL(A.VA,0) - ISNULL(A.CA,0)) as [Net Total] from #CNTR C            
LEFT JOIN #AMTR A ON C.AgencyName = A.AgencyName            
) as ft;            
            
            
Select * from #finaltable            
            
DECLARE @xml NVARCHAR(MAX)            
DECLARE @xml1 NVARCHAR(MAX)            
DECLARE @body NVARCHAR(MAX)            
DECLARE @body1 NVARCHAR(MAX)            
                  
            
            
SET @xml = CAST((            
Select [Sr.No] AS 'td','',ISNULL([State Name],'') AS 'td','' ,[Agency Name] AS 'td','' ,ISNULL([branch],'') AS 'td','' ,[Voucher Count] AS 'td','',[Cancellation Count] AS 'td','',            
[Voucher Amount] AS 'td','',[Cancellation Amount] AS 'td','',[Net Total] AS 'td','' from #finaltable A            
--order by 6 asc            
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))            
        
Drop table #trans            
Drop table #FN            
Drop table #CNTR            
Drop table #AMTR            
Drop table #finaltable            
drop table #temp5            
drop table #temp6     
END  