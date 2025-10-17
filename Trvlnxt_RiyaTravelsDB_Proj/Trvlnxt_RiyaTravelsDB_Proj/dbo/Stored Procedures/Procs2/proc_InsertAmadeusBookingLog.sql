CREATE PROCEDURE proc_InsertAmadeusBookingLog    
 @AmadeusPNR VARCHAR(50)=NULL,    
 @AmadeusCity VARCHAR(500)=NULL,    
 @CheckInDate VARCHAR(50)=NULL,    
 @CheckOutDate VARCHAR(50)=NULL,    
 @PaxName varchar(500)=NULL,    
 @Request nvarchar(MAX)=NULL,    
 @Response nvarchar(MAX)=NULL,    
 @SessionId VARCHAR(100)=NULL, 
 @MethodName VARCHAR(100)=NULL,
 @CreatedBy INT    
AS    
BEGIN    
 INSERT INTO AmadeusBookingLog(AmadeusPNR,AmadeusCity,CheckInDate,CheckOutDate,PaxName,Request,Response,CreatedBy,SessionId,MethodName)    
 VALUES(@AmadeusPNR,@AmadeusCity,Convert(Datetime,@CheckInDate,111),Convert(Datetime,@CheckOutDate,111),@PaxName,@Request,@Response,@CreatedBy,@SessionId,@MethodName)    
END 

--select convert(datetime,NULL,111)
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[proc_InsertAmadeusBookingLog] TO [rt_read]
    AS [dbo];

