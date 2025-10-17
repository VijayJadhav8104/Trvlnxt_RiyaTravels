
CREATE FUNCTION [dbo].[ConcatenateSupplierId](@Promotion VARCHAR(MAX))    
RETURNS VARCHAR(MAX)AS     
 BEGIN         
      
  DECLARE @RtnStr VARCHAR(MAX)        
      
  SELECT @RtnStr = COALESCE(@RtnStr + ',', '') + (CAST(dt.Supplier AS VARCHAR(50)))       
  FROM     
  (SELECT Supplier FROM B2B_Promotion WHERE PromotionName = @Promotion AND IsActive=1 AND IsSupplier=1)dt    
       
  RETURN @RtnStr     
 END    
        
