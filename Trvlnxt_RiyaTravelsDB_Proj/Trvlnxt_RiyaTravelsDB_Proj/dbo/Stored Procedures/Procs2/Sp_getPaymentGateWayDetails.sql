      
-- =============================================      
-- Author:  <Akash>      
-- Create date: <23-June-2022 >      
-- Description: <To get PaymentGateway Info for Console Api  >      
-- =============================================      
CREATE PROCEDURE Sp_getPaymentGateWayDetails      
AS      
BEGIN      
  --select      
  --name as 'PaymentGatewayName'      
  --,Mode as 'PaymentMode'       
  --,Charges as 'PaymentCharges'      
  --,vat      
  --from  PaymentGatewayMaster PM       
  --join PaymentGatewayMode MO on PM.PG_Id=MO.PGID       
  --where PM.PG_Id=2 and MO.IsActive=1 and PM.IsActive=1       
  select * from PaymentGatewayMaster where PG_Id=2    
  Select * from PaymentGatewayMode where PGID=2    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_getPaymentGateWayDetails] TO [rt_read]
    AS [dbo];

