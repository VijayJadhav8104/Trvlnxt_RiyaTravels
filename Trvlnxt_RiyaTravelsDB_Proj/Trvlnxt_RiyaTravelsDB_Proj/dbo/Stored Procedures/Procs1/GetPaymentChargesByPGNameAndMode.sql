CREATE Procedure [dbo].[GetPaymentChargesByPGNameAndMode]   
@PGName  varchar(20)='',  
@Mode varchar(20)=''  
AS  
  
BEGIN  
Select pg.Charges Charges from   
PaymentGatewayMode pg inner join PaymentGatewayMaster pm  
on pg.PGID=pm.PG_Id where pm.Name= @PGName and pg.Mode= @Mode  
     
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaymentChargesByPGNameAndMode] TO [rt_read]
    AS [dbo];

