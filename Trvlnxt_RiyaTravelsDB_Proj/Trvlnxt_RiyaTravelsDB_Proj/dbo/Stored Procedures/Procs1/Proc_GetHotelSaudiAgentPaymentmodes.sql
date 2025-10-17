 Create Procedure Proc_GetHotelSaudiAgentPaymentmodes  
 as  
 Begin  
   Select Mode, Charges  
  From PaymentGatewayMode  
  Where PGID=11  
 END