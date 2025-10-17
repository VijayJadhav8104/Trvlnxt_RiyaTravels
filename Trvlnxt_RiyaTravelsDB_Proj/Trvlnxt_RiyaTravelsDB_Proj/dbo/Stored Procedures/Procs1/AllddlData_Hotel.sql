                
                
--sp_helptext AllddlData-- =============================================                          
-- Author:  <Author,,Name>                          
-- Create date: <Create Date,,>                          
-- Description: <Description,,>                          
-- =============================================                          
CREATE PROCEDURE [dbo].[AllddlData_Hotel]                          
 -- Add the parameters for the stored procedure here                          
                           
AS                          
BEGIN                          
                       
 SET NOCOUNT ON;                          
           
   -- for status                          
   select Id,[Status] from Hotel_Status_Master  WITH (NOLOCK) where id not in (1,2,6,8,14)                          
   order by Id asc                          
                             
   --for suppliyer                           
    select Id,(case when  PayAtHotel=1 then Upper(SupplierName +' (PayAtHotel)') else Upper(SupplierName) end) as SupplierName   
 from B2BHotelSupplierMaster  WITH (NOLOCK) where IsDelete=0 and SupplierType='Hotel'                                      
          
                        
END 