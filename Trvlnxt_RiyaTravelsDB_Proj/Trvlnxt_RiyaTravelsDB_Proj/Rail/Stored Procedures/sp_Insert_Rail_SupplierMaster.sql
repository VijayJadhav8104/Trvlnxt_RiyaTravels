CREATE PROCEDURE [Rail].[sp_Insert_Rail_SupplierMaster] 
(   
 @Id int NULL,  
 @Name varchar(50) NULL  
 )  
 as  
  BEGIN
 insert into SupplierMaster (Id,Name) values(@Id,@Name) 
  END

 
