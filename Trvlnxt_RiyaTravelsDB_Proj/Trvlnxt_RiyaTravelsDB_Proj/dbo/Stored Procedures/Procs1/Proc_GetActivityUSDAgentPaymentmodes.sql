  
 Create Procedure Proc_GetActivityUSDAgentPaymentmodes  
 as  
 Begin  
   Select Mode, Charges  
  From PaymentGatewayMode  
  Where PGID=8  
 END