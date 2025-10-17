-- =============================================          
-- Author:  <Author,,Name>          
-- Create date: <Create Date,,>          
-- Description: <Description,,>          
        
        
        
-- =============================================          
CREATE PROCEDURE HotelConfirmationUpdate           
 -- Add the parameters for the stored procedure here          
           
 @Id int = 0,          
 @HotelConfirmationNo varchar(max)='',                   
 @HotelStaffName nvarchar(200)='',          
 @HotelConfirmationRemarks nvarchar(500)='',      
 @HotelConfirmationDate datetime=null,       
 @ModifiedBy int=0          
           
          
AS          
BEGIN          
           
 update Hotel_BookMaster          
 set HotelConfNumber=@HotelConfirmationNo,          
  HotelStaffName=@HotelStaffName,          
  ConfirmationRemark=@HotelConfirmationRemarks,      
 ConfirmationDate =@HotelConfirmationDate      
          
 where pkId=@Id          
          
  
  insert into Hotel_UpdatedHistory       
  (fkbookid,FieldName ,FieldValue,InsertedDate,InsertedBy,UpdatedType)      
  select @Id,'ConfirmationNo. Added',HotelConfNumber,GETDATE(),@ModifiedBy,'ConfNumber' from Hotel_BookMaster where pkId = @Id          
      SELECT SCOPE_IDENTITY();                                
    
    
END   

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelConfirmationUpdate] TO [rt_read]
    AS [dbo];

