-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- =============================================            
CREATE PROCEDURE [Hotel].[Api_BBHotelCommissionInsert]            
             
 @Fk_BookId int=0,            
 @Commission varchar(500)=null,            
 @GST varchar(500)=null,            
 @TDS varchar(500)=null,            
 @SupplierCommission varchar(500)=null,            
 @RiyaCommission varchar(500)=null,            
 @TotalEarningAmount varchar(500)=null,            
 @FinalEarningAmount varchar(500)=null,            
 @TDSDeductedAmount varchar(500)=null,            
 @Payment varchar(500)=null ,           
 @GstAmount varchar(500)=null,    
 @Discounts varchar(500)=null    
AS            
BEGIN            
             
 insert into B2BHotel_Commission (Fk_BookId            
         ,Commission            
         ,GST            
         ,TDS            
         ,SupplierCommission            
         ,RiyaCommission            
         ,EarningAmount            
         ,TDSDeductedAmount            
         ,Payment        
   ,GSTAmount          
   ,TotalEaringAmount    
   ,Discounts)             
                    
        values(@Fk_BookId,            
           @Commission,            
           @GST,            
           @TDS,            
           @SupplierCommission,            
           @RiyaCommission,            
           @FinalEarningAmount,            
           @TDSDeductedAmount,            
           @Payment,        
     @GstAmount,          
           @TotalEarningAmount,    
     @Discounts)            
            
            
END 