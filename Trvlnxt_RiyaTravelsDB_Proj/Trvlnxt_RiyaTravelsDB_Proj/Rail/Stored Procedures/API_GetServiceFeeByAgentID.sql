--exec [Rail].[API_GetServiceFeeByAgentID] 'all'      
      
CREATE PROCEDURE [Rail].[API_GetServiceFeeByAgentID]                  
 @AgencyID varchar(20)=Null          
 AS           
 BEGIN         
 Declare @MarkentPoint varchar(5)              
  Declare @UserType int              
  Declare @isExist int            
  Set @MarkentPoint = (Select BookingCountry from AgentLogin where  CONVERT(varchar(20),UserID)=@AgencyID)              
  Set @UserType = (Select UserTypeID from AgentLogin where  CONVERT(varchar(20),UserID)=@AgencyID)             
  Set @isExist =(Select COUNT(Id) from Rail.Service_AgentMapping where AgentId=@AgencyID)           
          
          
            
  Set @UserType = 2  
              
  SELECT *, SM.Id as ServiceFeesAppliedId FROM [Rail].[tbl_ServiceFee] SF            
  LEFT JOIN Rail.Agent_ServiceFee_Mapper SM on SM.FK_ServiceFeeId = SF.Id  ----Multiple pass data i.e 'EuRailPass & GermanPass & SwissPAss'           
  --LEFT JOIN Rail.Service_AgentMapping AM ON AM.ServiceId=SF.Id          
  left join rail.ProductListMaster PM ON PM.Id = SM.Fk_ProductListMasterId        
  Where       
  ((@isExist=0 and SF.AgentId='all') or (@isExist!= 0 and SF.Id in (Select ServiceId from Rail.Service_AgentMapping where AgentId=@AgencyID)))             
  AND        
  SF.isActive = 1 --AND  AM.AgentId = @AgencyID                
  
 END 
