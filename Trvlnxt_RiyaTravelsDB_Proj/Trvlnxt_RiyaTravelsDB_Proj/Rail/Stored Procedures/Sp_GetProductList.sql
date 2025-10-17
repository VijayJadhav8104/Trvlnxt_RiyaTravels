CREATE PROCEDURE [Rail].[Sp_GetProductList]   
--@ProductType varchar(50)=null,  
@SupplierType varchar(50)=null    
--@Name varchar(50)   
AS  
BEGIN  
 SELECT ProductType, Name, Id
FROM rail.ProductListMaster
WHERE Fk_SupplierMasterId =@SupplierType
    --AND (UPPER(Name) LIKE '%EURAIL%' OR Name LIKE '%EuroStar%')  
    AND Id IN (1,3,4)
GROUP BY ProductType, Name, Id;

END  