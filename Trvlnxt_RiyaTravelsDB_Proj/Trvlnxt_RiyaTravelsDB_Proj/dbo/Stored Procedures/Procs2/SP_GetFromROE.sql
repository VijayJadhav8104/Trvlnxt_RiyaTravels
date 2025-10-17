-- =============================================  
-- Author:  <Jitendra Nakum>  
-- Create date: <09.12.2022>  
-- Description: <This procedure is used to get top 1 ROE Data through From Currency and To Currency>  
-- =============================================  
--exec SP_GetFromROE  
CREATE PROCEDURE [dbo].[SP_GetFromROE]   
 @FromCur Varchar(10),  
 @ToCur Varchar(10)  
AS  
BEGIN  
 SELECT TOP 1 * FROM ROE  
 WHERE FromCur=@FromCur   
 AND ToCur=@ToCur   and IsActive=1
 ORDER BY InserDate DESC  
END