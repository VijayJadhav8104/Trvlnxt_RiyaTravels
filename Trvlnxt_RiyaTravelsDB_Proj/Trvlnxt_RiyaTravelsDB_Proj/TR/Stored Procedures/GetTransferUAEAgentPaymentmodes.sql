--Select * from PaymentGatewayMode Where PGID=10     
create Proc TR.GetTransferUAEAgentPaymentmodes      
AS      
BEGIN      
    Select Mode, Charges      
 From PaymentGatewayMode      
 Where PGID=10        
END