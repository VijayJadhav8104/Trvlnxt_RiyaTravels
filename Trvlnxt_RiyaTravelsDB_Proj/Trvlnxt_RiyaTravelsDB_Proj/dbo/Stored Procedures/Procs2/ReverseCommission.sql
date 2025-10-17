CREATE Proc ReverseCommission   
@Pkid varchar(40)  
AS  
BEGIN  
insert into B2BHotel_Commission  
select Fk_BookId, Commission, GST, TDS, SupplierCommission, RiyaCommission, TDSDeductedAmount, EarningAmount, 'Debit' as Payment, GSTAmount, TotalEaringAmount  
from B2BHotel_Commission   
where Fk_BookId = @Pkid and Payment = 'Credit'  
  
END  
