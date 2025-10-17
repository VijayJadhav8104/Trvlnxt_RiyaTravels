-- =============================================  
-- Author:  <Author,,VijayaLakshmi>  
-- Create date: <Create Date,,May-30 2024>  
-- Description: <Description,, Get LFS report by dates>  
-- =============================================  
-- exec sp_GetLFSReport '2024-02-21 16:34:30.047','2024-05-30 12:35:19.047'  
CREATE PROCEDURE [dbo].[sp_GetLFSReport]  
@FromDate DateTime null,  
@ToDate DateTime null,  
 @Start int=null,  
 @Pagesize int=null,  
 @IsPaging bit,  
 @RecordCount INT OUTPUT  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
set @RecordCount=0  
if(@IsPaging=1)  
BEGIN  
  --SELECT @RecordCount = @@ROWCOUNT  
  select l.InsertedOn as [Date]  
  ,l.OfficeId as PCC  
  ,(select d.DepartmentName from mDepartment as d where d.ID=l.DepartmentID) as Depatrment  
  ,p.[Group] as [Group]  
  ,p.Country as Country  
  ,l.PnrNo as PNR  
  ,(case when l.IsTicketed=1 then 'Ticketed' else 'Non-Ticketed' end)  as TicketStatus  
  ,l.currentFare as OrginalFare  
  ,l.CancellationCharges  
  ,(l.currentFare-l.CancellationCharges ) As RefundReceivable  
  ,l.foundLowerFare as NewFare  
  ,(l.currentFare-(l.CancellationCharges+l.foundLowerFare)) as EffectiveSaving  
  ,l.FullBaggage as CurrentBaggageAllowances  
  ,l.FullBaggageLowFare as NewBaggageAllowances  
  ,l.DescriptionText  
  from [dbo].[LFS_Log] as l   
  join [dbo].[tbl_mLFS_PCC] as p on p.PCC=l.OfficeId  
  --where l.InsertedOn>=@FromDate and l.InsertedOn<=@ToDate 
   WHERE CONVERT(date, l.InsertedOn) BETWEEN CONVERT(date, @FromDate) AND CONVERT(date, @ToDate)
  and l.DescriptionText='Lower Fare Found Mail Send Successfully'  
  order by l.InsertedOn desc  
  OFFSET @Start ROWS  
  FETCH NEXT @Pagesize ROWS ONLY  
  END  
ELSE if(@IsPaging=0)  
BEGIN  
select l.InsertedOn as [Date]  
  ,l.OfficeId as PCC  
  ,(select d.DepartmentName from mDepartment as d where d.ID=l.DepartmentID) as Depatrment  
  ,p.[Group] as [Group]  
  ,p.Country as Country  
  ,l.PnrNo as PNR  
  ,(case when l.IsTicketed=1 then 'Ticketed' else 'Non-Ticketed' end)  as TicketStatus  
  ,l.currentFare as OrginalFare  
  ,l.CancellationCharges  
  ,(l.currentFare-l.CancellationCharges ) As RefundReceivable  
  ,l.foundLowerFare as NewFare  
  ,(l.currentFare-(l.CancellationCharges+l.foundLowerFare)) as EffectiveSaving  
  ,l.FullBaggage as CurrentBaggageAllowances  
  ,l.FullBaggageLowFare as NewBaggageAllowances    
  ,l.DescriptionText  
  from [dbo].[LFS_Log] as l   
  join [dbo].[tbl_mLFS_PCC] as p on p.PCC=l.OfficeId  
  --where l.InsertedOn>=@FromDate and l.InsertedOn<=@ToDate 
   WHERE CONVERT(date, l.InsertedOn) BETWEEN CONVERT(date, @FromDate) AND CONVERT(date, @ToDate)
  and l.DescriptionText='Lower Fare Found Mail Send Successfully'  
  order by l.InsertedOn desc  
END  
SELECT @RecordCount = @@ROWCOUNT
END  
  
  