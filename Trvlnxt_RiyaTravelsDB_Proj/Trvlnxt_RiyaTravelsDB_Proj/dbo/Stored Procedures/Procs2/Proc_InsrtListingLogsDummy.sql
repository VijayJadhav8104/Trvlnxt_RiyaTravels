CREATE Procedure Proc_InsrtListingLogsDummy  
@URLTR varchar(500)=null,  
@Request varchar(max)=null,  
@Response varchar(max)=null,  
@MethodName varchar(200)=null,  
@Token varchar(300)=null,  
@CorrelationId varchar(300)=null,  
@AgentId int=0,  
@Timmer varchar(200)=null,
@SearchType varchar(50)=null,
@ResumeKey varchar(50)=null
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
Timmer,
SearchType,
ResumeKey)  
Values(@URLTR,@Request,@Response,@MethodName,GETDATE(),@Token,@CorrelationId,@AgentId,@Timmer,@SearchType,@ResumeKey)  
End  