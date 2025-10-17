CREATE FUNCTION [dbo].[ConcatenateSupplier](@SupplierId VARCHAR(MAX))    
RETURNS VARCHAR(MAX)AS     
 BEGIN         
      
  DECLARE @RtnStr VARCHAR(MAX)        
      
  SELECT @RtnStr = COALESCE(@RtnStr + ',', '') + (dt.SupplierName)       
  FROM     
  (SELECT SupplierName FROM B2BHotelSupplierMaster WHERE id IN (SELECT item FROM dbo.SplitString(@SupplierId,',')) AND IsActive=1)dt    
       
  RETURN @RtnStr     
 END    
        

 --select dbo.ConcatenateSupplier('13,3,1,2')  
 --Qtech (LocalSystem),Sharib Supplier,Inspiron,Dell


