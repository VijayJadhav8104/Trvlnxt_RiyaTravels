CREATE  Proc [Hotel].GetRateCodeLabel --46999    
@Agent int =0    
AS    
BEGIN    
  
Select HM.RateCode as'rateCode',HM.Label as 'label',ACM.AgentId as 'agentId',SM.RhSupplierId as 'providerId',SM.SupplierName as 'supplierName',HM.Id as RateId
from  Hotel.AgentSupplierRateCodeMapping ACM   
left join Hotel_RateCode_Master HM on ACM.RateCodeId=HM.Id  
left join B2BHotelSupplierMaster SM on SM.Id=ACM.SupplierId  
where AgentId=@Agent    
END