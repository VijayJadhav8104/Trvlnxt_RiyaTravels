-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>   
-- [Hotel].[getVccMappingCode]   'THB'
-- =============================================    
CREATE PROCEDURE [Hotel].[getVccMappingCode]    
@currency varchar(100)    
AS    
BEGIN    
IF EXISTS(    
 select * from Hotel.VccCardCurrenyMapping where currencyCode = @currency    
 ) begin    
 select vm.cardType, vccm.currencyCodeNum,vccm.currencyCode,vm.Issuer,vm.firstName,vm.middleName,vm.lastName,
 @currency as 'SupplierCurrency' 
 from Hotel.VccCardMapping vm     
 left join Hotel.VccCardCurrenyMapping vccm on vm.pkId = vccm.fk_vccmappingId    
 where vccm.currencyCode = @currency    
 end    
    
 ELSE    
    
 begin    
 select 
  vm.cardType, vccm.currencyCodeNum,vccm.currencyCode,
  vm.Issuer,vm.firstName,vm.middleName,vm.lastName,
  @currency as 'SupplierCurrency' 
  from Hotel.VccCardMapping vm     
 left join Hotel.VccCardCurrenyMapping vccm on vm.pkId = vccm.fk_vccmappingId    
 where vccm.currencyCode = 'INR'    
 end    
END 