Create Procedure Proc_InsrtListingLogs
@URLTR varchar(500)=null,
@Request varchar(max)=null,
@Response varchar(max)=null,
@MethodName varchar(200)=null,
@Token varchar(300)=null,
@CorrelationId varchar(300)=null,
@AgentId int=0,
@Timmer varchar(200)=null
As
Begin
Insert into [AllAppLogs].[dbo].HotelApiLogs
(URL,
Request,
Response,
MethodName,
InsertedDate,
Token,
CorrelationId,
AgentId,
Timmer)
Values(@URLTR,@Request,@Response,@MethodName,GETDATE(),@Token,@CorrelationId,@AgentId,@Timmer)
End
