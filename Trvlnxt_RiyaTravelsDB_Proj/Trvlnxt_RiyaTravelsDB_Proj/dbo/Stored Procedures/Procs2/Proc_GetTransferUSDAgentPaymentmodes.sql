 Create Procedure Proc_GetTransferUSDAgentPaymentmodes  
 as  
 Begin  
   Select Mode, Charges  
  From PaymentGatewayMode  
  Where PGID=8  
 END