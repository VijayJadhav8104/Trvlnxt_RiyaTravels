-- =============================================  
-- Author:Shivkumar Prajapati  
-- Create date: 23-Nov-2019  
-- Description: Procedure is created for Get UserID and Password  
-- [dbo].[GetUserID_PasswordSupplier_procedure] 'expedia'  
-- =============================================  
CREATE PROCEDURE [dbo].[GetUserID_PasswordSupplier_procedure]  
 -- Add the parameters for the stored procedure here  
 @SupplierName nvarchar(50)  
AS  
BEGIN  
  
 --IF EXISTS(select top 1 (SupplierName) from APIUserIDPassword where ltrim(rtrim(SupplierName))=ltrim(rtrim(@SupplierName)) )  
 IF EXISTS(select top 1 (SupplierName) from APIUserIDPassword where SupplierName like'%'+@SupplierName+'%' )  
 BEGIN  
   --select Top 1 SupplierName,UserID,[Password] from APIUserIDPassword where  ltrim(rtrim(SupplierName))=ltrim(rtrim(@SupplierName))  
   select Top 1 SupplierName,UserID,[Password] from APIUserIDPassword where  SupplierName like'%'+@SupplierName+'%'  
  
 END  
 ELSE  
 BEGIN  
  SELECT 'SupplierName Name IS BLANK'  
 END  
  
 --select * from Hotel_BookMaster where book_Id=2007  
 --select * from  Hotel_Pax_master where book_fk_id=5  
 --select * from  Hotel_Room_master where book_fk_id=5  
  
 --SELECT * FROM UserLogin WHERE UserName ='qa@riya.travel'  
 --SELECT * FROM Hotel_BookMaster WHERE PassengerEmail='qa@riya.travel'  
   
END  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetUserID_PasswordSupplier_procedure] TO [rt_read]
    AS [dbo];

