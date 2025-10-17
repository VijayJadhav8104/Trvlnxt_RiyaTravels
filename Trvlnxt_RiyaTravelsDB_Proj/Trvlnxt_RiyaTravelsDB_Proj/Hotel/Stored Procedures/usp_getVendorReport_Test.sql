                       
--exec Hotel.usp_getVendorReport '28-Oct-2024','28-Oct-2024','0'          
      
      
CREATE  proc [Hotel].[usp_getVendorReport_Test]                                      
@StartDate varchar(20),                                        
 @EndDate varchar(20),                                      
 @SearchBy Varchar(50)                                      
 as                                        
 begin                                      
       
 IF @SearchBy='0'                                  
 BEGIN      
 DROP TABLE IF EXISTS #temp, #temp1, #temp2, #temp3;        

DROP TABLE IF EXISTS #temp, #temp1;        
        
  Create table #temp        
(        
  Vendor_Name varchar(400),        
  Vendor_Group varchar(400),        
  Vendor_Billing_Currency varchar(20),        
     Selling_Market varchar(20),                    
    Total_Booking_Foriegn_Currency int,        
 Total_Booking_Amount decimal(18,2),        
 Booking_Count int,        
 Percentage_Share decimal(18,2),        
 Vendor_Status varchar(20),        
 BookingPercentage DECIMAL(18,2),        
 orderby INT,      
 Product varchar(20)      
)        
        
Create table #temp1        
(        
  Vendor_Name varchar(400),        
  Vendor_Group varchar(400),        
  Vendor_Billing_Currency varchar(20),        
     Selling_Market varchar(20),                    
    Total_Booking_Foriegn_Currency int,        
 Total_Booking_Amount decimal(18,2),        
 Booking_Count int,        
 Percentage_Share decimal(18,2),        
 Vendor_Status varchar(20),        
 BookingPercentage DECIMAL(18,2),        
 orderby INT,      
  Product varchar(20)      
)        
        
--SupplierData        
        
insert into #temp1         
        
        
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrencyCode, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCountry, '-')                    
        WHEN 'IN' THEN 'INDIA'                    
        WHEN 'AE' THEN 'UAE'                    
        WHEN 'CA' THEN 'CANADA'                    
        WHEN 'US' THEN 'USA'                    
        WHEN 'TH' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCountry, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
    CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18, 2)) AS Total_Booking_Amount,                    
    COALESCE(COUNT(HB.pkId), 0) AS Booking_Count,                    
    CAST(COUNT(HB.pkId) * 100.0 / NULLIF(SUM(COUNT(HB.pkId)) OVER (), 0) AS DECIMAL(18, 2)) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate))) OVER (), 0)                   
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,1 orderby      
 ,'Hotel' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join Hotel_BookMaster HB WITH (NOLOCK)                                     
ON SM.Id=HB.SupplierPkId                            
                                      
AND HB.CurrentStatus in ('Vouchered','Confirmed')                                      
 and cast(HB.inserteddate as date) between @StartDate and  @EndDate         
        
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCountry,                    
    HB.SupplierCurrencyCode,              
    SM.SupplierType,        
 SM.IsDelete        
       
 having         
  SM.SupplierType='Hotel'  and SM.IsDelete=0        
        
        
  union all        
        
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrency, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCurrency, '-')                    
        WHEN 'INR' THEN 'INDIA'                    
        WHEN 'AED' THEN 'UAE'                    
        WHEN 'CAD' THEN 'CANADA'                    
        WHEN 'USD' THEN 'USA'                   
        WHEN 'THB' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCurrency, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
   isnull(CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)), 0) AS DECIMAL(18, 2)),0) AS Total_Booking_Amount,                    
    isnull(COALESCE(COUNT(HB.bookingid), 0),0) AS Booking_Count,                    
   isnull( CAST(COUNT(HB.bookingid) * 100.0 / NULLIF(SUM(COUNT(HB.bookingid)) OVER (), 0) AS DECIMAL(18, 2)),0) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate))) OVER (), 0)                   
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,2 orderby      
 ,'Activity' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join SS.SS_BookingMaster HB WITH (NOLOCK)                                    
ON SM.RhSupplierId=HB.providerId                            
                                      
AND HB.BookingStatus in ('Vouchered','Confirmed')                                      
and cast(HB.creationDate as date) between @StartDate and  @EndDate         
        
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCurrency,                    
    HB.SupplierCurrency,              
    SM.SupplierType,       
   SM.IsDelete      
         
 having         
  SM.SupplierType='Activity'  and SM.IsDelete=0        
              
  union all
  
  
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrency, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCurrency, '-')                    
        WHEN 'INR' THEN 'INDIA'                    
        WHEN 'AED' THEN 'UAE'                    
        WHEN 'CAD' THEN 'CANADA'                    
        WHEN 'USD' THEN 'USA'                   
        WHEN 'THB' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCurrency, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
   isnull(CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)), 0) AS DECIMAL(18, 2)),0) AS Total_Booking_Amount,                    
    isnull(COALESCE(COUNT(HB.bookingid), 0),0) AS Booking_Count,                    
   isnull( CAST(COUNT(HB.bookingid) * 100.0 / NULLIF(SUM(COUNT(HB.bookingid)) OVER (), 0) AS DECIMAL(18, 2)),0) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission))) OVER (), 0)                   
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,3 orderby      
 ,'Transfer' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join TR.TR_BookingMaster HB WITH (NOLOCK)                                    
ON SM.SupplierName =HB.providerName                            
                                      
AND HB.BookingStatus in ('Vouchered','Confirmed')                                      
and cast(HB.creationDate as date) between @StartDate and  @EndDate         
        
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCurrency,                    
    HB.SupplierCurrency,              
    SM.SupplierType,       
   SM.IsDelete      
         
 having         
  SM.SupplierType='Transfer'  and SM.IsDelete=0

        
--Hotel        
insert into #TEMP        
SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)) AS Total_Booking_Amount,                    
    COUNT(HB.pkId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1000 orderby      
,'Hotel' Product      
FROM                
    Hotel_BookMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.Id =HB.SupplierPkId and SM.SupplierType = 'Hotel'  and SM.IsDelete=0            
         
WHERE            
    HB.CurrentStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.inserteddate as date) between @StartDate and  @EndDate         
        
--ACTIVITY        
        
Insert into  #TEMP        
SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)) AS Total_Booking_Amount,                    
    COUNT(HB.BookingId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1001 orderby      
,'Activity' Product      
FROM                
    SS.SS_BookingMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.RhSupplierId =HB.providerId and SM.SupplierType = 'Activity'  and SM.IsDelete=0            
         
WHERE            
    HB.BookingStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.creationDate as date) between @StartDate and  @EndDate        
	

Insert into  #TEMP        
SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)) AS Total_Booking_Amount,                    
    COUNT(HB.BookingId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1002 orderby      
,'Transfer' Product      
FROM                
    TR.TR_BookingMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.RhSupplierId =HB.providerId and SM.SupplierType = 'Activity'  and SM.IsDelete=0            
         
WHERE            
    HB.BookingStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.creationDate as date) between @StartDate and  @EndDate
        
--Combine        
SELECT       Vendor_Name,      
Vendor_Group,       
Vendor_Billing_Currency,      
Selling_Market,      
Total_Booking_Foriegn_Currency,      
Total_Booking_Amount,      
Booking_Count,Percentage_Share,      
Vendor_Status,      
BookingPercentage,      
900 AS orderby      
,Product      
FROM #temp1         
        
union all        
SELECT          
'Total' AS Vendor_Name,      
'Total' AS Vendor_Group,      
'NA' AS Vendor_Billing_Currency,      
'NA' AS Selling_Market,      
0 AS Total_Booking_Foriegn_Currency,      
SUM(Total_Booking_Amount) AS Total_Booking_Amount,      
SUM(Booking_Count) AS Booking_Count,      
100 AS Percentage_Share,                       
'-' AS Vendor_Status,                       
100 AS BookingPercentage,           
10002 AS orderby      
,Product      
FROM #temp         
  group by Product      
  order by orderby      
        
END;      
      
                                  
             
 ELSE IF                                   
 @SearchBy='1'                                  
                                  
 BEGIN                                  
                                                   
  DROP TABLE IF EXISTS #temp, #temp1;        
        
   DROP TABLE IF EXISTS #temp2, #temp3;        
        
  Create table #temp2        
(        
  Vendor_Name varchar(400),        
  Vendor_Group varchar(400),        
  Vendor_Billing_Currency varchar(20),        
     Selling_Market varchar(20),                    
    Total_Booking_Foriegn_Currency int,        
 Total_Booking_Amount decimal(18,2),        
 Booking_Count int,        
 Percentage_Share decimal(18,2),        
 Vendor_Status varchar(20),        
 BookingPercentage DECIMAL(18,2),        
 orderby INT,      
 Product varchar(20)      
)        
        
Create table #temp3        
(        
  Vendor_Name varchar(400),        
  Vendor_Group varchar(400),        
  Vendor_Billing_Currency varchar(20),        
     Selling_Market varchar(20),                    
    Total_Booking_Foriegn_Currency int,        
 Total_Booking_Amount decimal(18,2),        
 Booking_Count int,        
 Percentage_Share decimal(18,2),        
 Vendor_Status varchar(20),        
 BookingPercentage DECIMAL(18,2),        
 orderby INT,      
  Product varchar(20)      
)        
        
--SupplierData        
        
insert into #temp3         
        
        
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrencyCode, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCountry, '-')                    
        WHEN 'IN' THEN 'INDIA'                    
        WHEN 'AE' THEN 'UAE'                    
        WHEN 'CA' THEN 'CANADA'                    
        WHEN 'US' THEN 'USA'                    
        WHEN 'TH' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCountry, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
    CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18, 2)) AS Total_Booking_Amount,                    
    COALESCE(COUNT(HB.pkId), 0) AS Booking_Count,                    
    CAST(COUNT(HB.pkId) * 100.0 / NULLIF(SUM(COUNT(HB.pkId)) OVER (), 0) AS DECIMAL(18, 2)) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate))) OVER (), 0)     
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,1 orderby      
 ,'Hotel' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join Hotel_BookMaster HB WITH (NOLOCK)                                     
ON SM.Id=HB.SupplierPkId                            
                                      
AND HB.CurrentStatus in ('Vouchered','Confirmed')                                      
and cast(HB.CheckInDate as date) between @StartDate and  @EndDate         
        
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCountry,                    
    HB.SupplierCurrencyCode,              
    SM.SupplierType,        
 SM.IsDelete        
       
 having         
  SM.SupplierType='Hotel'  and SM.IsDelete=0        
        
  union all        
        
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrency, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCurrency, '-')                    
        WHEN 'INR' THEN 'INDIA'                    
        WHEN 'AED' THEN 'UAE'                    
        WHEN 'CAD' THEN 'CANADA'                    
        WHEN 'USD' THEN 'USA'                   
        WHEN 'THB' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCurrency, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
   isnull(CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)), 0) AS DECIMAL(18, 2)),0) AS Total_Booking_Amount,                    
    isnull(COALESCE(COUNT(HB.bookingid), 0),0) AS Booking_Count,                    
   isnull( CAST(COUNT(HB.bookingid) * 100.0 / NULLIF(SUM(COUNT(HB.bookingid)) OVER (), 0) AS DECIMAL(18, 2)),0) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate))) OVER (), 0)                   
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,2 orderby      
 ,'Activity' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join SS.SS_BookingMaster HB WITH (NOLOCK)                                    
ON SM.RhSupplierId=HB.providerId                            
                                      
AND HB.BookingStatus in ('Vouchered','Confirmed')                                      
and cast(HB.TripStartDate as date) between @StartDate and  @EndDate     
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCurrency,                    
    HB.SupplierCurrency,              
    SM.SupplierType,       
   SM.IsDelete      
         
 having         
  SM.SupplierType='Activity'  and SM.IsDelete=0        
  
  union all

  
 SELECT                    
    SM.SupplierName AS Vendor_Name,                    
    ISNULL(SM.SupplierGroup, SM.SupplierName) AS Vendor_Group,                    
    COALESCE(HB.SupplierCurrency, '-') AS Vendor_Billing_Currency,                    
    CASE COALESCE(HB.BookingCurrency, '-')                    
        WHEN 'INR' THEN 'INDIA'                    
        WHEN 'AED' THEN 'UAE'                    
        WHEN 'CAD' THEN 'CANADA'                    
        WHEN 'USD' THEN 'USA'                   
        WHEN 'THB' THEN 'Thailand'                    
        ELSE COALESCE(HB.BookingCurrency, '-')                    
    END AS Selling_Market,                    
    COALESCE(SUM(HB.SupplierRate), 0) AS Total_Booking_Foriegn_Currency,                    
   isnull(CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)), 0) AS DECIMAL(18, 2)),0) AS Total_Booking_Amount,                    
    isnull(COALESCE(COUNT(HB.bookingid), 0),0) AS Booking_Count,                    
   isnull( CAST(COUNT(HB.bookingid) * 100.0 / NULLIF(SUM(COUNT(HB.bookingid)) OVER (), 0) AS DECIMAL(18, 2)),0) AS Percentage_Share,                    
    CASE SM.IsActive                    
        WHEN 1 THEN 'Active'                    
        ELSE 'Deactivate'                    
    END AS Vendor_Status,                    
   isnull( CAST(ISNULL(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)), 0) * 100.0 /                  
    NULLIF(SUM(SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission))) OVER (), 0)                   
    AS DECIMAL(18, 2)),0) AS BookingPercentage          
 ,3 orderby      
 ,'Transfer' as 'Product'      
from                                       
B2BHotelSupplierMaster SM  WITH (NOLOCK)                                    
left  outer join TR.TR_BookingMaster HB WITH (NOLOCK)                                    
ON SM.SupplierName =HB.providerName                            
                                      
AND HB.BookingStatus in ('Vouchered','Confirmed')                                      
and cast(HB.TripStartDate as date) between @StartDate and  @EndDate         
        
GROUP BY                    
    SM.SupplierName,                    
    SM.SupplierGroup,                    
    SM.IsActive,                    
    HB.BookingCurrency,                    
    HB.SupplierCurrency,              
    SM.SupplierType,       
   SM.IsDelete      
         
 having         
  SM.SupplierType='Transfer'  and SM.IsDelete=0
        
        
--Hotel        
insert into #temp2        
SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)) AS Total_Booking_Amount,                    
    COUNT(HB.pkId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1000 orderby      
,'Hotel' Product      
FROM                
    Hotel_BookMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.Id =HB.SupplierPkId and SM.SupplierType = 'Hotel'  and SM.IsDelete=0            
         
WHERE            
    HB.CurrentStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.CheckInDate as date) between @StartDate and  @EndDate         
        
--ACTIVITY        
        
Insert into  #TEMP2        
SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.Roevalue, HB.BookingRate)) AS Total_Booking_Amount,                    
    COUNT(HB.BookingId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1001 orderby      
,'Activity' Product      
FROM                
    SS.SS_BookingMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.RhSupplierId =HB.providerId and SM.SupplierType = 'Activity'  and SM.IsDelete=0            
         
WHERE            
    HB.BookingStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.TripStartDate as date) between @StartDate and  @EndDate      

insert into #temp2

SELECT          
    'Total' AS Vendor_Name,                    
    'Total' AS Vendor_Group,                    
    'NA' AS Vendor_Billing_Currency,                    
    'NA' AS Selling_Market,                    
     0 AS Total_Booking_Foriegn_Currency,                    
    SUM(COALESCE(HB.SupplierRate * HB.SupplierToInrRoe, HB.AmountBeforePgCommission)) AS Total_Booking_Amount,                    
    COUNT(HB.BookingId) AS Booking_Count,                    
    100 AS Percentage_Share,                    
    '-' AS Vendor_Status,                    
    100 AS BookingPercentage          
 ,1002 orderby      
,'Transfer' Product      
FROM                
    TR.TR_BookingMaster HB WITH (NOLOCK)                    
LEFT JOIN                    
    B2BHotelSupplierMaster SM WITH (NOLOCK)                     
    ON SM.RhSupplierId =HB.providerId and SM.SupplierType = 'Transfer'  and SM.IsDelete=0            
         
WHERE            
    HB.BookingStatus IN ('Vouchered', 'Confirmed')                    
    and cast(HB.TripStartDate as date) between @StartDate and  @EndDate

        
--Combine        
SELECT       Vendor_Name,      
Vendor_Group,       
Vendor_Billing_Currency,      
Selling_Market,      
Total_Booking_Foriegn_Currency,      
Total_Booking_Amount,      
Booking_Count,Percentage_Share,      
Vendor_Status,      
BookingPercentage,      
900 AS orderby      
,Product      
FROM #temp3         
        
union all        
SELECT          
'Total' AS Vendor_Name,      
'Total' AS Vendor_Group,      
'NA' AS Vendor_Billing_Currency,      
'NA' AS Selling_Market,      
0 AS Total_Booking_Foriegn_Currency,      
SUM(Total_Booking_Amount) AS Total_Booking_Amount,      
SUM(Booking_Count) AS Booking_Count,      
100 AS Percentage_Share,                       
'-' AS Vendor_Status,                       
100 AS BookingPercentage,           
10002 AS orderby      
,Product      
FROM #temp2         
  group by Product      
  order by orderby      
        
END;    
    
End;