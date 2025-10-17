CREATE procedure IsCheckAPIKeyValid            
@APIKey varchar(255) = ''            
as            
begin            
            
Select IPAddress,AgentID,Availability,Sell,Booking,AllBlock From APIAuthenticationMaster where APIKey = @APIKey and [Status] = 1  
  
union     
    
Select IPAddress,AgentID,Availability,Sell,Booking,AllBlock From APIAuthenticationMaster_Internal where APIKey = @APIKey and [Status] = 1     
            
End