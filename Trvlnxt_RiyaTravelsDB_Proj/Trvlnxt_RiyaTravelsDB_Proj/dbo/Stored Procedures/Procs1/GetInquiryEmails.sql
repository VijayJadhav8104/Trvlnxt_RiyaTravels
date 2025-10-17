
       
 --exec GetInquiryEmails     
 CREATE PROCEDURE [dbo].[GetInquiryEmails]       
    
 AS       
 BEGIN      
      
  SELECT top 1 EmailTO,EmailCC  FROM InquiryEmails      
      
 END 
