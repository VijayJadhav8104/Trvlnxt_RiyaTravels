-- =============================================                                        
-- Author:  <Author,,Name>                                        
-- Create date: <Create Date,,>                                        
-- Description: <Description,,>                                        
-- =============================================                                        
CREATE PROCEDURE [dbo].[SupplierHistory]                                        
@Id int=0,  
@SupplierName varchar(500)=null,  
@SupplierType varchar(50)=null,  
@Username varchar(500)=null,   
@Password varchar(500)=null,  
@FirstName varchar(500)=null,  
@LastName varchar(500)=null,  
@Address varchar(500)=null,  
@PinCode varchar(500)=null,   
@ModifiedBy int=0,  
@CommissionNet int=0,  
@PayAtHotel bit=0,  
@RhSupplierId varchar(500)=null,  
@SupplierCurrency varchar(500)=null,  
@BillingCountry varchar(500)=null,  
@SupplierCharges varchar(500)=0,  
@VccCharges float=0,  
@VirtualBalance float=0,  
@IsDomesticPanReq bit=0 ,  
@IsInternationalPanReq bit=0,  
@RateDisplay varchar(500)=null  
  
as  
  
begin  
  
insert into B2BHotelSupplierMaster_History  
(Pkid,SupplierName,SupplierType,Username,[Password],FirstName,LastName,[Address],PinCode,Commission_Net,CreateDate,CreatedBy,  
RhSupplierId,VccCharges,PayAtHotel,SupplierCharges,SupplierCurrency,BillingCountry,VirtualBalance,  
Is_Req_Domestic_Pan,Is_Req_International_Pan,RateDisplay)  
  
values  
  
(@Id,@SupplierName,@SupplierType,@Username,@Password,@FirstName,@LastName,@Address,@PinCode,@CommissionNet,GETDATE(),@ModifiedBy,  
 @RhSupplierId,@VccCharges,@PayAtHotel,@SupplierCharges,@SupplierCurrency,@BillingCountry,  
 @VirtualBalance,@IsDomesticPanReq,@IsInternationalPanReq,@RateDisplay)  
  
  select SCOPE_IDENTITY();
end  
  
