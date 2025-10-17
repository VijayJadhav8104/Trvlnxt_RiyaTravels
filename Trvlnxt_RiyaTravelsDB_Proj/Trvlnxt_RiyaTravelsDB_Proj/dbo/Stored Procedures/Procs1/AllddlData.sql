            
            
--sp_helptext AllddlData-- =============================================                      
-- Author:  <Author,,Name>                      
-- Create date: <Create Date,,>                      
-- Description: <Description,,>                      
-- =============================================                      
CREATE PROCEDURE [dbo].[AllddlData]                      
 -- Add the parameters for the stored procedure here                      
                       
AS                      
BEGIN                      
 -- SET NOCOUNT ON added to prevent extra result sets from                      
 -- interfering with SELECT statements.                      
 SET NOCOUNT ON;                      
                      
   --- for Consultant                      
   --select ID,UserName from mUser                      
    select ID,UserName +' - '+ FullName as 'UserName' from mUser  WITH (NOLOCK)                      
                      
                      
   -- for status                      
   select * from Hotel_Status_Master  WITH (NOLOCK) where id not in (1,2,6,8,14)                      
   order by Id asc                      
                         
   --for suppliyer                       
   select distinct  SupplierName from Hotel_BookMaster  WITH (NOLOCK)  where SupplierName is not null                      
    select Id,(case when  PayAtHotel=1 then Upper(SupplierName +' (PayAtHotel)') else Upper(SupplierName) end) as SupplierName from B2BHotelSupplierMaster  WITH (NOLOCK) where IsDelete=0                                   
                  
   --select Id,SupplierName from B2BHotelSupplierMaster where IsActive=1                       
                      
 ---- for pending status                      
 --select * from Hotel_Status_Master where Id in (1,2)A                      
                      
 ---- for Country                      
 select CountryCode as 'id',CountryName from Hotel_CountryMaster  WITH (NOLOCK) order by CountryName asc                      
                      
 ----for City                      
 select top 100 ID,CityName from Hotel_City_Master  WITH (NOLOCK) order by CityName asc                      
                      
 --- for Branch                      
 --select Id,BranchName from B2BHotelBranch where IsActive=1 order by BranchName asc                      
-- select distinct BranchCode as Id,Name as BranchName  from mBranch order by BranchName asc                      
  select distinct BranchCode as Id,Name as BranchName  from mBranch  WITH (NOLOCK)                  
 where Division = 'RTT' and BranchCode like 'BRH%'                  
 order by BranchName asc                   
                   
                  
  --SupplierName                      
    select  RhSupplierId as Id,(case when  SupplierName='Rayna Tours' then Upper('RaynaTours') else Upper(SupplierName) end) as SupplierName                      
     from B2BHotelSupplierMaster  WITH (NOLOCK) where IsActive=1  and SupplierType='Activity'                   
                        
    --for status cruise                      
  select * from  CruiseStatus   WITH (NOLOCK)                               
   order by Id asc                        
            --transfer          
       --SupplierName                      
    select  RhSupplierId as Id,(case when  SupplierName='Rayna Tours' then Upper('RaynaTours') else Upper(SupplierName) end) as SupplierName                      
     from B2BHotelSupplierMaster  WITH (NOLOCK) where IsActive=1 and IsDelete=0 and SupplierType='Transfer'             
                    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AllddlData] TO [rt_read]
    AS [dbo];

