CREATE procedure Proc_SupplierBalanceUpdate
@SchedulerName Varchar(100)=null,
@SupplierName Varchar(100)=null
As
Begin
	insert into SedularWorkingUpdate(InsertedDate,SchedulerName,SupplierName)values(GETDATE(),@SchedulerName,@SupplierName)
End