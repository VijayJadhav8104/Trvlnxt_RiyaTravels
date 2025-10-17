create Procedure [dbo].[GetPaymentModeByPGNameB2C]   
@PGName  varchar(20)=''  
AS  
  
BEGIN  
  
Select pg.Mode Mode,pg.Charges Charges from   
PaymentGatewayModeB2C pg inner join PaymentGatewayMaster pm  
on pg.PGID=pm.PG_Id where pm.Name= @PGName  
     
END  