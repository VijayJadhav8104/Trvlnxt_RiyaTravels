CREATE proc [dbo].[Transfer_GetServiceFeeMapping]  
@AgentID int  
As  
Begin  
   select   
   AgentID,  
   ISNULL(ServiceFeeTypeDomestic,0) ServiceFeeTypeDomestic,   
   ISNULL(ServiceFeeDomestic,0) ServiceFeeDomestic,  
   --ISNULL(ChildServiceFeeDomestic,0) ChildServiceFeeDomestic,  
   ISNULL(ServiceFeeTypeInternational,0) ServiceFeeTypeInternational,  
   ISNULL(ServiceFeeInternational,0) ServiceFeeInternational  
   --ISNULL(ChildServiceFeeInternational,0) ChildServiceFeeInternational    
  FROM   
   [Transfer_AgentServiceFeeMapping] where AgentID=@AgentID  
END