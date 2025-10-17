 CREATE PROCEDURE [dbo].[GetBecomePartnerInquiryEmails]             
          
 AS             
 BEGIN         
            
  SELECT top 1 EmailTO,EmailBCC  FROM InquiryBecomePartnerEmails            
            
 END 

