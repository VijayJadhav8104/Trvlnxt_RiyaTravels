create proc [Visa].[Insert_ErrorLog]
(
   @CreatedBy [bigint] NULL,

	@AgentID [int] NULL,
	@MethodName [nvarchar](50) NULL,
	@ErrorDesc nvarchar(max) NULL
	)
	as
	begin

	insert into [Visa].[ErrorLog](CreatedBy,CreatedDate,AgentID,MethodName,ErrorDesc)
	values(@CreatedBy,getdate(),@AgentID,@MethodName,@ErrorDesc);
	
	end
