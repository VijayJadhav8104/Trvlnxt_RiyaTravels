CREATE Procedure Proc_CancelShedularTransferInsertData--'2024-11-19 12:55:50.967','CancelTicketSchedular',null        
@StartDate datetime='',        
@MethodName varchar(200),        
@Id varchar(50)=null        
As        
Begin        
 if(@StartDate != '' AND @Id IS NULL)        
 Begin        
 insert into TR.SchedularCancelUpdated values(GETDATE(),Null,@MethodName)        
 select SCOPE_IDENTITY() as ID;        
 End        
 if(@Id !=0)        
 Begin        
 update TR.SchedularCancelUpdated set EndDate=GETDATE() WHERE id=@Id        
 select 0;        
 End        
End     