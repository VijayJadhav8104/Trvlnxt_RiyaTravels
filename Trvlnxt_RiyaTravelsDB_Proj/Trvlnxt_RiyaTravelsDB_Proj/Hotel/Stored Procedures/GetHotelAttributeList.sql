CREATE Proc [Hotel].GetHotelAttributeList    
@AgentId int=0    
as    
begin    
select * from Hotel.mHotelAgentAttributeMapping with (Nolock) where AgenId=@AgentId and IsActive=1    
end