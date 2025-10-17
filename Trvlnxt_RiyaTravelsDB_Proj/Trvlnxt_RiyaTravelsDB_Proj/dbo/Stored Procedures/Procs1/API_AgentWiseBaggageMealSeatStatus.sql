create procedure [API_AgentWiseBaggageMealSeatStatus]

@AgentId varchar(50)

as                              
begin                              

select * from APIAgentWiseBaggageMealSeatStatus where AgentID = @AgentId

end