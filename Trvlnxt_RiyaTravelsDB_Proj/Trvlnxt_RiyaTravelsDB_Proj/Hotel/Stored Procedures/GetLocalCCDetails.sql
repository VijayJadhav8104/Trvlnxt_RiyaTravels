-- =============================================  
-- Author:  <Akash>  
-- Create date: <09 Feb >  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [Hotel].GetLocalCCDetails  
 @ProviderId varchar(40)=null  
  
AS  
BEGIN  
     Declare @Supplierd int  
  
     select @Supplierd=id from B2BHotelSupplierMaster where RhSupplierId=@ProviderId  
  
  
  select * from [hotel].SupplierCCDetails where Fk_SupplierID=@Supplierd  
  
  
END  