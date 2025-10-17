CREATE procedure InsertAPILogs
@APIName varchar(50)=null, 
@RequestTime datetime=null,
@ResponseTime datetime=null, 
@SearchID varchar(50)=null,
@IP varchar(50)=null,
@Device varchar(50)=null,
@AgentID varchar(50)=null,
@StaffAgentID varchar(50)=null,
@FromSector varchar(50)=null,
@ToSector varchar(50)=null,
@DepDate datetime=null,
@ReturnDate datetime=null,
@APIError varchar(max)=null,
@action int=null,
@id bigint=null
as
begin
	if(@action=1)
		begin
		insert into tblAPILogs
		(APIName, RequestTime, ResponseTime, SearchID, IP, Device, 
		AgentID, StaffAgentID, FromSector, ToSector, DepDate, ReturnDate, CreationDate, APIError)
		values(@APIName, @RequestTime, @ResponseTime,@SearchID, @IP, @Device, 
		@AgentID, @StaffAgentID, @FromSector, @ToSector, @DepDate, @ReturnDate, getdate(), @APIError)
		select SCOPE_IDENTITY();
		end
		else if(@action=2)
		begin
		update tblAPILogs
		set ResponseTime=@ResponseTime
		where id=@id
		end
		else if(@action=3)
		begin
		update tblAPILogs
		set APIError=@APIError
		where id=@id
		end
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertAPILogs] TO [rt_read]
    AS [dbo];

