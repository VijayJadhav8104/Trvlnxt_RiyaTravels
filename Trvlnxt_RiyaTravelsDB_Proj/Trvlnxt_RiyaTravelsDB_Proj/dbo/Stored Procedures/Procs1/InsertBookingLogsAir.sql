CREATE PROCEDURE InsertBookingLogsAir      
 @Request varchar(max)=null,      
 @Response varchar(max)=null,      
 @MethodName varchar(200)=null,      
 @GDSPNR varchar(10)=null ,  
 @SessionId varchar(200)=null,  
 @AirlineName varchar(10)=null,  
 @DepDate varchar(50)=null  
      
AS      
BEGIN      
 Insert into [AllAppLogs].[dbo].[tblBookingLogsAir](AirlineName,GDSPNR,MethodName,Request,Response,SessionId,DepDate)    
 values(@AirlineName,@GDSPNR,@MethodName,@Request,@Response,@SessionId,@DepDate)      
END 