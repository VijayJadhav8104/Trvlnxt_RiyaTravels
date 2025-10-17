--Select * from PaymentGatewayMode Where PGID=10 
create Proc Hotel.GetHotelUAEAgentPaymentmodes  
AS  
BEGIN  
    Select Mode, Charges  
 From PaymentGatewayMode  
 Where PGID=10    
  
END