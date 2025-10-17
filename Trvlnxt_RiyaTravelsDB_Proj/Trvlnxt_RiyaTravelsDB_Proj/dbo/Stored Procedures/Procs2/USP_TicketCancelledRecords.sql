CREATE PROCEDURE [dbo].[USP_TicketCancelledRecords]      
@fk_pkid BIGINT,      
@cancelledFlag INT,    
@RefId VARCHAR(500),  
@EmailID VARCHAR(400)='',  
@MethodName VARCHAR(200)=''  
AS      
BEGIN      
    
INSERT INTO SS.SS_UserCancelData (fk_pkid,cancelledFlag,CancelledRefId,EmailID,MethodName) VALUES (@fk_pkid,@cancelledFlag,@RefId,@EmailID,@MethodName)      
END   
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_TicketCancelledRecords] TO [rt_read]
    AS [dbo];

