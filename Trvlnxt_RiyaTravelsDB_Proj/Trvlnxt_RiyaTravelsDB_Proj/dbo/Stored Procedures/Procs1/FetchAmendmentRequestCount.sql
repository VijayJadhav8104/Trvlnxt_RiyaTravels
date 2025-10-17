
CREATE PROC [dbo].[FetchAmendmentRequestCount]  
@Riyapnr varchar(20)  

AS BEGIN   
  
SELECT COUNT(DISTINCT AmendmentRef) FROM tbl_AmendmentRequest WHERE RiyaPNR=@Riyapnr
  
END  