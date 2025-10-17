CREATE proc [dbo].[CreateMappingHistory]
@OrderId	nvarchar(50)
,@RiyaPNR	nvarchar(10)
,@Remark	varchar(500)
,@ReportBug	bit
,@UpdatedBy	varchar(10)

As
Begin

insert into MappingHistory values(@OrderId,@RiyaPNR,@Remark,@ReportBug,@UpdatedBy,GETDATE())
select SCOPE_IDENTITY()

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CreateMappingHistory] TO [rt_read]
    AS [dbo];

