-- =============================================  
-- Author:  <Jitendra Nakum>  
-- Create date: <23-03-2023>  
-- Description: <This Procedure is Used to Get EmailTo and EmailCC for send Daily Sales Report>  
-- =============================================  
--exec [dbo].[Sp_GetTrvlNxtDailySalesEmailIds]  
CREATE PROCEDURE [dbo].[Sp_GetTrvlNxtDailySalesEmailIds]  
AS  
BEGIN  
 SELECT   
 (SELECT STUFF((SELECT ',' + DR.EmailTo FROM tblTrvlnxtDailyReportEmailIds AS DR WHERE DR.Status=1 FOR XML PATH ('')) , 1, 1, '')) AS EmailTo  
 , (SELECT STUFF((SELECT ',' + DR.EmailCC FROM tblTrvlnxtDailyReportEmailIds AS DR WHERE DR.Status=1 FOR XML PATH ('')) , 1, 1, '')) AS EmailCC  
  
END  