CREATE Proc [dbo].[sp_GetProducts]  
AS  
BEGIN  
 SELECT * FROM mProducts  where IsActive=1 order by ItemOrder  
END