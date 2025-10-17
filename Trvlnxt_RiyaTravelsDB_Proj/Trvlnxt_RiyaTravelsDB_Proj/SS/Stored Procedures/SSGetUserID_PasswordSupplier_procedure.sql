-- =============================================    
-- Author:Shivkumar Prajapati    
-- Create date: 23-Nov-2019    
-- Description: Procedure is created for Get UserID and Password    
-- [dbo].[GetUserID_PasswordSupplier_procedure] 'expedia'    
-- =============================================    
CREATE PROCEDURE [SS].[SSGetUserID_PasswordSupplier_procedure]    
 -- Add the parameters for the stored procedure here    
 @SupplierName nvarchar(50)    
AS    
BEGIN    
    
 IF EXISTS(select top 1 (SupplierName) from B2BHotelSupplierMaster where SupplierName  like'%'+@SupplierName+'%'  and  SupplierType='Activity')    
 BEGIN    
   --select Top 1 SupplierName,UserID,[Password] from APIUserIDPassword where  ltrim(rtrim(SupplierName))=ltrim(rtrim(@SupplierName))    
   select Top 1 SupplierName,Username,Password from B2BHotelSupplierMaster where  SupplierName like'%'+@SupplierName+'%'  and SupplierType='Activity'   
    
 END    
 ELSE    
 BEGIN    
  SELECT 'SupplierName Name IS BLANK'    
 END    
    
 
     
END    
    
    