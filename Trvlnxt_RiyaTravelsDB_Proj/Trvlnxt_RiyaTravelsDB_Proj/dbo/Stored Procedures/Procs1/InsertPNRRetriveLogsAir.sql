CREATE PROCEDURE InsertPNRRetriveLogsAir      
 @Request varchar(max)=null,      
 @Response varchar(max)=null,      
 @MethodName varchar(200)=null,      
 @GDSPNR varchar(50)=null      
      
AS      
BEGIN      
 Insert into [AllAppLogs].[dbo].[PNRRetriveLogsAir](Request,Response,MethodName,GDSPNR)    
 values(@Request,@Response,@MethodName,@GDSPNR)      
END 