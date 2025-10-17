  --CreatedBy: Ketan Marade     
  --Date:- 20/03/2024     
  --Proc_GetHotelAgentMapAttributes 51379     
  CREATE Procedure Proc_GetHotelAgentMapAttributes     
  @AgentId int=0     
  As     
  Begin     
 Select HAM.AttributeId,HAM.IsMandate,HAM.CreatedDate,HAM.IsActive,HA.Attributes,  
  HA.Value   
  from     hotel.mHotelAgentAttributeMapping HAM      
  left join      
  hotel.mAttributes_Hotel HA      
  on HAM.AttributeId=HA.ID      
  where HAM.AgenId=@AgentId     
 End