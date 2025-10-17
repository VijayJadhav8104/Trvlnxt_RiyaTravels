
CREATE PROC GetSupplierProfile_List       
      
@AgentId nvarchar(20) = NULL   
    
AS      
BEGIN      
 SELECT sm.Id      
  ,sm.SupplierName      
  ,'' AS CancellationHour      
  ,apm.PriceOptimizationOn      
 FROM B2BHotelSupplierMaster sm      
 LEFT JOIN AgentSupplierProfileMapper APM ON SM.Id = APM.SupplierId      
 WHERE sm.IsActive = 1      
  AND sm.Action = 1     
      
       
  AND APM.AgentId = @AgentId      
 ORDER BY SupplierName ASC      
END