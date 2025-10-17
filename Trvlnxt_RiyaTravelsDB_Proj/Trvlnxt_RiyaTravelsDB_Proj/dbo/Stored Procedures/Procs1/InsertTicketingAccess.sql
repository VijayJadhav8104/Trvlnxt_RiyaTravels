        
        
CREATE PROCEDURE InsertTicketingAccess        
@OrderId   varchar(50)  = NULL,        
@GDSPNR    varchar(10)  = NULL,        
@MailId    varchar(Max) = NULL  ,      
@Queue varchar(100)=null    ,  
@OTP varchar(20)=null,  
@OfficeId varchar(50)=null,  
@RiyaPNR varchar(10)=null  
        
AS BEGIN        
        
 INSERT INTO tblAmadeusQueAndEmails (QueueNo,Emails,orderId,GDSPNR,OTP,OfficeId,BookingId,IsQueued,IsPNRUpdated)      
 VALUES(@Queue,@MailId,@OrderId,@GDSPNR,@OTP,@OfficeId,@RiyaPNR,0,0)      
      
 update tblBookMaster set BookingStatus=12 where orderId=@OrderId    
END        
      
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertTicketingAccess] TO [rt_read]
    AS [dbo];

