CREATE PROCEDURE [dbo].[USP_UserEmailSendRecords]  
@fk_pkid BIGINT,  
@RefId VARCHAR(500),
@EmailId varchar(400)=''
AS  
BEGIN  
  
INSERT INTO UserEmaildReminder_Data (fk_pkid,EmailRefId,EmailID) VALUES (@fk_pkid,@RefId,@EmailId)  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_UserEmailSendRecords] TO [rt_read]
    AS [dbo];

