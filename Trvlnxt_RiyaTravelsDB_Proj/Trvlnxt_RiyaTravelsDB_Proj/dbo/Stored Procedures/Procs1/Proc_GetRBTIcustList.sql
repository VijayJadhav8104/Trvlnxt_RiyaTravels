CREATE Procedure Proc_GetRBTIcustList    
As    
Begin    
 Select BR.CustomerCOde as RBTIcust, BR.AgencyName,BR.FKUserID as RBTAgentID,BR.EntityName from     
 B2BRegistration BR    
 join    
 agentLogin AL    
 on BR.FKUserID=AL.UserID    
 WHERE AL.userTypeID=5     
 --and AL.IsActive=0    
End    
  