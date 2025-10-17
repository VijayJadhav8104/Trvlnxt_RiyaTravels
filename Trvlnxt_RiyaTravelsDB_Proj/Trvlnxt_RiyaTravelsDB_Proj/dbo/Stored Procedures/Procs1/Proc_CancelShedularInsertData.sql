CREATE Procedure Proc_CancelShedularInsertData--'2022-06-06 12:55:50.967','CancelTicketSchedular',null
@StartDate datetime='',
@MethodName varchar(200),
@Id varchar(50)=null
As
Begin
	if(@StartDate != '' AND @Id IS NULL)
	Begin
	insert into SchedularCancelUpdated values(GETDATE(),Null,@MethodName)
	select SCOPE_IDENTITY() as ID;
	End
	if(@Id !=0)
	Begin
	update SchedularCancelUpdated set EndDate=GETDATE() WHERE id=@Id
	select 0;
	End
End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_CancelShedularInsertData] TO [rt_read]
    AS [dbo];

