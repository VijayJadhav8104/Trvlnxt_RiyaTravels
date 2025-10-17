CREATE procedure Proc_GetAgencyPanRequired  
@AgentID INT=0  
AS  
Begin  
Select isnull(IsPanRequiredForHotel,0) as IsPanRequiredForHotel from B2BRegistration wHERE FKUserID=@AgentID  
End  
  