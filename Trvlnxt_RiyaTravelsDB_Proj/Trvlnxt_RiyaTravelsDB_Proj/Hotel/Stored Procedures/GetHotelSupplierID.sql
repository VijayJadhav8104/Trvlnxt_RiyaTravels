Create proc [Hotel].GetHotelSupplierID  
@RhSupplierId Varchar(50)=''  
  
As  
BEGIN   
    select Id From B2BHotelSupplierMaster where RhSupplierId=@RhSupplierId  
END