-- =============================================  
-- Author:  Danish Sarang
-- Create date: 11 dec 2021  
-- =============================================  
CREATE PROCEDURE [dbo].[trvlnxtdailyreport_bkp]   
  @fromDate DATETIME2(7) =null
 
AS  
BEGIN 

set nocount on

Select top 500 HB.RiyaAgentID,HB.pkId, B.AgencyName, B.BranchCode, MS.StateName, HSH.FkStatusId, HB.DisplayDiscountRate,HB.inserteddate
,case when  HSH.FkStatusId = 4 then 'V' else 'C' end as StatusName,
case when  HSH.FkStatusId = 4 then 'VA' else 'CA' end as StatusNameA
INTO #trans
from Hotel_BookMaster HB
LEFT JOIN B2BRegistration B ON HB.RiyaAgentID = B.FKUserID
LEFT JOIN Hotel_Status_History HSH ON HSH.FKHotelBookingId = HB.pkId 
LEFT JOIN mState MS ON MS.ID = B.StateID 
where AgencyName not in  ('HOTELTEST IND','DEMOHOTELID') and HSH.FkStatusId in (4,7) and HSH.IsActive = 1 and MS.StateName is not null
and Convert(date, HB.inserteddate) > Convert(date, GETDATE()-5);

WITH CTE as (
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName , StatusNameA  from #trans where FkStatusId = 4
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA
Union
Select count(pkId) as Cnt,  SUM(cast(DisplayDiscountRate as decimal)) as 'amt', RiyaAgentID,  AgencyName, StateName, StatusName , StatusNameA  from #trans  where FkStatusId = 7
Group by RiyaAgentID, AgencyName, StateName, StatusName, StatusNameA
)
Select * INTO #FN  from CTE order by 4 asc
--
 

select * INTO #CNTR
from 
(
  select Cnt, AgencyName,StateName,StatusName
  from #FN 
) src
pivot
(
  sum(Cnt)  for StatusName in ([C],[V])
) piv



select * INTO #AMTR
from 
(
  select amt, AgencyName,StateName,StatusNameA
  from #FN 
) src
pivot
(
  sum(amt)  for StatusNameA in ([CA],[VA])
) piv2


Select  ROW_NUMBER() OVER(ORDER BY C.AgencyName ASC) AS [Sr.No], C.StateName as [State Name], C.AgencyName as [Agency Name],
ISNULL(C.V,0) as [Voucher Count], ISNULL(C.C,0) as [Cancellation Count], 
ISNULL(A.VA,0) as [Voucher Amount],ISNULL(A.CA,0) as [Cancellation Amount],
(ISNULL(A.VA,0) - ISNULL(A.CA,0)) as [Net Total] from #CNTR C
LEFT JOIN #AMTR A ON C.AgencyName = A.AgencyName 
order by 1 asc
Drop table #trans
Drop table #FN
Drop table #CNTR
Drop table #AMTR

set nocount off


end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[trvlnxtdailyreport_bkp] TO [rt_read]
    AS [dbo];

