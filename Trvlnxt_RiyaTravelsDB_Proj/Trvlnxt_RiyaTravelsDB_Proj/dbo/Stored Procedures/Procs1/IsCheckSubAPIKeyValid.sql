CREATE procedure IsCheckSubAPIKeyValid              
@APIKey varchar(255) = ''              
as              
begin              
              
Select AgentID,AccessCarrier,AllBlock From APISubAgentAccessCarriers where APIKey = @APIKey and [Status] = 1    
         
End


