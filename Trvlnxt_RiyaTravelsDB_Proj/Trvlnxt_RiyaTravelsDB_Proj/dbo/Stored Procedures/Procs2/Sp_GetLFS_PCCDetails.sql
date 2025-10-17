  
-- =============================================  
-- Author:  VijayaLakshmi  
-- Description: Get LFS PCC details  
-- [Sp_GetLFS_PCCDetails] 'test','','','0',''  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_GetLFS_PCCDetails]
	@PCC nvarchar(20)=null,
	@Start int=null,
	@Pagesize int=null,
	@IsPaging bit,
	@RecordCount INT OUTPUT
AS
BEGIN
set @RecordCount=0
if(@IsPaging=1)
BEGIN
		--SELECT @RecordCount = @@ROWCOUNT
		SELECT p.Id
		,(case when p.Vendor='0' then 'All' when p.Vendor='1' then 'Amadeus' when p.Vendor='2' then 'Sabre' else '' end) as Vendor
		,p.PCC
		,(case when p.TimeZone='0' then 'All' when p.TimeZone='1' then 'Day' when p.TimeZone='2' then 'Night' else '' end) as TimeZone
		,(case when p.IsRepeateEveryDay='1' then 'Yes' when p.TimeZone='0' then 'No' else '' end) as IsRepeateEveryDay
		,p.FromDate
		,p.ToDate
		,p.LFS_CCEmail
		,p.LFS_ToEmail
		,p.QueueNoLFS
		,(case when p.RunningWithoutLFS=1 then 'Yes' when p.RunningWithoutLFS=0 then 'No' else '' end) as RunningWithoutLFS
		,(case when p.DepartmentID='1' then 'Marine' when p.DepartmentID='2' then 'RBT' when p.DepartmentID='3' then 'RTT' else '' end) as DepartmentID
		,p.LFSBufferAmount
		,p.[Group]
		,p.Country
		,p.TimeSchedular
		,p.[Status]
		FROM tbl_mLFS_PCC as p where (@PCC is null or @PCC ='' or p.PCC=@PCC) and Status!=2
		ORDER BY p.Id desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
END
ELSE if(@IsPaging=0)
BEGIN
		SELECT p.Id
		,(case when p.Vendor='0' then 'All' when p.Vendor='1' then 'Amadeus' when p.Vendor='2' then 'Sabre' else '' end) as Vendor
		,p.PCC
		,(case when p.TimeZone='0' then 'All' when p.TimeZone='1' then 'Day' when p.TimeZone='2' then 'Night' else '' end) as TimeZone
		,(case when p.IsRepeateEveryDay='1' then 'Yes' when p.TimeZone='0' then 'No' else '' end) as IsRepeateEveryDay
		,p.FromDate
		,p.ToDate
		,p.LFS_CCEmail
		,p.LFS_ToEmail
		,p.QueueNoLFS
		,(case when p.RunningWithoutLFS=1 then 'Yes' when p.RunningWithoutLFS=0 then 'No' else '' end) as RunningWithoutLFS
		,(case when p.DepartmentID='1' then 'Marine' when p.DepartmentID='2' then 'RBT' when p.DepartmentID='3' then 'RTT' else '' end) as DepartmentID
		,p.LFSBufferAmount
		,p.[Group]
		,p.Country
		,p.TimeSchedular
		,p.[Status]
		FROM tbl_mLFS_PCC as p where (@PCC is null or @PCC ='' or p.PCC=@PCC) and Status!=2
		ORDER BY p.Id desc	
END
	SELECT @RecordCount = @@ROWCOUNT
END
