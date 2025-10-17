CREATE PROC [dbo].[sp_getAllRTTBranches]  
  AS  
  BEGIN  
   SELECT * FROM mBranch where Division='RTT'  
  END
