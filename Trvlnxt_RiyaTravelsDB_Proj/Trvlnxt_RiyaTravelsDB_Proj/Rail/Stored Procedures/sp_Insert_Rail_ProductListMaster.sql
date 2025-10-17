CREATE PROCEDURE [Rail].[sp_Insert_Rail_ProductListMaster] 
(   
 @Id int NULL,  
 @Fk_SupplierMasterId int NULL,
 @Name varchar(50) NULL,
 @ProductType varchar(50) NULL
 )  
 as  
  BEGIN
 insert into ProductListMaster (Id,Fk_SupplierMasterId,Name,ProductType) values(@Id,@Fk_SupplierMasterId,@Name,@ProductType) 
  END
