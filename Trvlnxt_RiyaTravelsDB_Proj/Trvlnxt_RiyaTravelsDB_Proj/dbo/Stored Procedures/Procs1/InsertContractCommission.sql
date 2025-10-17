CREATE procedure [dbo].[InsertContractCommission]
@userid int,
@country varchar(10),
@AgentID Varchar(max),--ContractCommissionAgents READONLY,
@filename nvarchar(max),
@UserType  varchar(50),
@pkid int=null
AS
BEGIN

if(@pkid>0)
BEGIN
	update tblContractCommission
	set UserID=@userid,Country=@country,AgentID=@AgentID,FileName=@filename,UserType=@UserType
	where pkid=@pkid
END
ELSE
BEGIN

INSERT INTO [dbo].[tblContractCommission]
            ([UserID],
           [Country],
           [AgentID],
           [FileName],
		   UserType)
         
     SELECT @userid,
		@country,
		@AgentID,
		@filename,@UserType --FROM @AgentID 
		END
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertContractCommission] TO [rt_read]
    AS [dbo];

