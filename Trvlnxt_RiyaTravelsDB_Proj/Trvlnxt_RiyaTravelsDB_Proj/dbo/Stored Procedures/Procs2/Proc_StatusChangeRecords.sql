CREATE Procedure Proc_StatusChangeRecords
@fk_pkid int,
@emailSendFlag int,
@RefId varchar(300)=null,
@EmailID varchar(600)=null,
@CurrentStatus varchar(500)=null
As
Begin
	if NOT EXISTS (select * from useremailstatuschange_data Where fk_pkid=@fk_pkid and EmailRefId=@RefId and CurrentStatus=@CurrentStatus)
	Begin
		INSERT INTO useremailstatuschange_data(fk_pkid,emailSendFlag,inserted_Date,EmailRefId,EmailID,CurrentStatus) 
		values(@fk_pkid,@emailSendFlag,Getdate(),@RefId,@EmailID,@CurrentStatus)
		Select * FROM useremailstatuschange_data Where fk_pkid=@fk_pkid and EmailRefId=@RefId and CurrentStatus=@CurrentStatus
	End
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Proc_StatusChangeRecords] TO [rt_read]
    AS [dbo];

