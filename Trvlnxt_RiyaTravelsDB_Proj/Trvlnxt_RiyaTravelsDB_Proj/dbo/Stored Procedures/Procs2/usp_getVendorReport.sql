                        
CREATE  proc usp_getVendorReport                              
@StartDate varchar(20),                                
 @EndDate varchar(20),                              
 @SearchBy Varchar(50)                              
 as                                
 begin                              
                           
 IF @SearchBy='0'                          
 BEGIN                          
select                               
 SM.SupplierName  as [Vendor_Name],              
SM.supplierGroup as Vendor_Group,              
COALESCE(HB.SupplierCurrencyCode,'-') AS [Vendor_Billing_Currency],                              
case  COALESCE(HB.BookingCountry,'-') when 'IN' THEN 'INDIA' WHEN 'AE ' THEN 'UAE' WHEN 'CA' THEN 'CANADA'                            
WHEN 'US' THEN 'USA' when 'TH' then 'Thailand' ELSE COALESCE(HB.BookingCountry,'-') END                            
AS [Selling_Market],                              
COALESCE(SUM(HB.SupplierRate),0) AS [Total_Booking_foriegn_Currency],                              
  cast(COALESCE(SUM(COALESCE (HB.SupplierRate * HB.SupplierINRROEValue,HB.DisplayDiscountRate)),0) as decimal(18,2))  as [Total_Booking_Amount],        -- now taking roe new column for india market                      
                    
COALESCE( count(HB.pkId),0) as [Booking_count],                              
cast(count(HB.pkId)*100.0 / NULLIF(SUM(count(HB.pkId)) over (),0) as decimal(18,2))  as [Percentage_share] ,                            
            
case   SM.IsActive when 1 then 'Active' else 'Deactivate' end  AS [Vendor_Status],        
        
 cast(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) * 100.0         
 / NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate))) OVER (), 0)        
 as decimal(18,2))AS [BookingPercentage]        
        
from                               
B2BHotelSupplierMaster SM WITH (NOLOCK)                             
left  outer join Hotel_BookMaster HB  WITH (NOLOCK)                            
ON SM.Id=HB.SupplierPkId                         
                              
AND HB.CurrentStatus in ('Vouchered','Confirmed')                              
and cast(HB.inserteddate as date) between @StartDate and  @EndDate   
group by                              
SM.SupplierName,              
SM.SupplierGroup,              
SM.IsActive,                              
HB.BookingCountry,                              
HB.SupplierCurrencyCode , 
SM.SupplierType
having SM.SupplierType='Hotel'
order by SM.SupplierName Asc , [Booking_count] desc                       
                          
END                          
                             
 ELSE IF                           
 @SearchBy='1'                          
                          
 BEGIN                          
                          
 select                               
 SM.SupplierName  as [Vendor_Name],              
SM.supplierGroup as Vendor_Group,              
COALESCE(HB.SupplierCurrencyCode,'-') AS [Vendor_Billing_Currency],                              
case  COALESCE(HB.BookingCountry,'-') when 'IN' THEN 'INDIA' WHEN 'AE ' THEN 'UAE' WHEN 'CA' THEN 'CANADA'                            
WHEN 'US' THEN 'USA' ELSE COALESCE(HB.BookingCountry,'NA') END                            
AS [Selling_Market],                              
COALESCE(SUM(HB.SupplierRate),0) AS [Total_Booking_foriegn_Currency],                               
--Concat(cast(COALESCE(SUM(COALESCE (HB.SupplierRate * HB.ROEValue,HB.DisplayDiscountRate)),0) as decimal(18,2)),+' '+ 'INR')  as [Total_Booking_Amount],                              
cast(COALESCE(SUM(COALESCE (HB.SupplierRate * HB.SupplierINRROEValue,HB.DisplayDiscountRate)),0) as decimal(18,2))  as [Total_Booking_Amount],        -- now taking roe new column for india market                      
COALESCE( count(HB.pkId),0) as [Booking_count],                              
--CONCAT(cast(count(HB.pkId)*100.0 / NULLIF(SUM(count(HB.pkId)) over (),0) as decimal(18,2)),'%')  as [Percentage_share] ,            
cast(count(HB.pkId)*100.0 / NULLIF(SUM(count(HB.pkId)) over (),0) as decimal(18,2))  as [Percentage_share] ,                            
            
case   SM.IsActive when 1 then 'Active' else 'Deactivate' end  AS [Vendor_Status],        
cast( ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) * 100.0         
 / NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate))) OVER (), 0)        
  as decimal(18,2))AS [BookingPercentage]        
        
        
        
from                               
B2BHotelSupplierMaster SM  WITH (NOLOCK)                            
left  outer join Hotel_BookMaster HB WITH (NOLOCK)                             
ON SM.Id=HB.SupplierPkId  and SM.SupplierType='Hotel'                         
                              
AND HB.CurrentStatus in ('Vouchered','Confirmed')                              
and cast(HB.CheckInDate as date) between @StartDate and  @EndDate
and SM.SupplierType='Hotel'
group by                              
SM.SupplierName,              
SM.SupplierGroup,              
SM.IsActive,                              
HB.BookingCountry,                              
HB.SupplierCurrencyCode,
SM.SupplierType
having SM.SupplierType='Hotel'
order by SM.SupplierName Asc , [Booking_count] desc                 
                          
END                          
                          
End 