create proc [dbo].[ServiceFeeMapping_CreateHistory]
@AgentID int,
@Id int,
@HistoryBy varchar(20)
As
Begin

if @HistoryBy='Agent' 
begin
	insert into tblAgentServiceFeeMappingHistory( 
	AgentID,
	AirportType,
	AirlineCategory,
	AirlineName,
	AirlineCode,
	AdultServiceFee,
	ChildServiceFee,
	InfantServiceFee,
	InsertedDate,
	UpdatedDate)

	select AgentID,
	AirportType,
	AirlineCategory,
	AirlineName,
	AirlineCode,
	AdultServiceFee,
	ChildServiceFee,
	InfantServiceFee,
	InsertedDate,GETDATE()
	  FROM tblAgentServiceFeeMapping where AgentID=@AgentID

	  delete from tblAgentServiceFeeMapping where AgentID=@AgentID
end	
else
begin
	insert into tblAgentServiceFeeMappingHistory( 
	AgentID,
	AirportType,
	AirlineCategory,
	AirlineName,
	AirlineCode,
	AdultServiceFee,
	ChildServiceFee,
	InfantServiceFee,
	InsertedDate,
	UpdatedDate)

	select AgentID,
	AirportType,
	AirlineCategory,
	AirlineName,
	AirlineCode,
	AdultServiceFee,
	ChildServiceFee,
	InfantServiceFee,
	InsertedDate,GETDATE()
	  FROM tblAgentServiceFeeMapping where Id=@Id

	  delete from tblAgentServiceFeeMapping where Id=@Id
end
END