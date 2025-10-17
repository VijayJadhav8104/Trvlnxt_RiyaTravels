CREATE Procedure [dbo].[GetPaymentModeByPGName]   
@PGName  varchar(20)=''  
AS  
  
BEGIN  
  
Select pg.Mode Mode,pg.Charges Charges from   
PaymentGatewayMode pg inner join PaymentGatewayMaster pm  
on pg.PGID=pm.PG_Id where pm.Name= @PGName  
     
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentModeByPGName] TO [rt_read]
    AS [dbo];

