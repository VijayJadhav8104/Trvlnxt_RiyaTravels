

-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
          
          
          
-- =============================================            
CREATE PROCEDURE HotelConfirmationUpdate_1             
 -- Add the parameters for the stored procedure here            
             
 @Id int = 0,            
 @HotelConfirmationNo varchar(max)='',            
 --@DateofConfirmation nvarchar(200)='',            
 @HotelStaffName nvarchar(200)='',            
 @HotelConfirmationRemarks nvarchar(500)='',        
 @HotelConfirmationDate datetime=null,  
 @PaxConfirmation varchar(10),  
 @MealPlanConfirmation varchar(10),  
 @RoomTypeConfirmation varchar(10),  
 @ExtrabedConfirmation varchar(10),  
 @PaymentConfirmation varchar(10),  
 @ConfByEmailConfirmation bit ,  
 @ModifiedBy int=0            
             
            
AS            
BEGIN            
             
 update Hotel_BookMaster            
 set HotelConfNumber=@HotelConfirmationNo,            
  HotelStaffName=@HotelStaffName,            
  ConfirmationRemark=@HotelConfirmationRemarks,        
 ConfirmationDate =@HotelConfirmationDate,  
 PassengerConfirmation =@PaxConfirmation,  
 MealPlanConfirmation =@MealPlanConfirmation,  
 RoomTypeConfirmation =@RoomTypeConfirmation,  
 ExtrabedConfirmation =@ExtrabedConfirmation,  
 PaymentConfirmation =@PaymentConfirmation,  
 ConfByEmailConfirmation =@ConfByEmailConfirmation   
            
 where pkId=@Id            
            
    
  insert into Hotel_UpdatedHistory         
  (fkbookid,FieldName ,FieldValue,InsertedDate,InsertedBy,UpdatedType)        
  select @Id,'ConfirmationNo. Added',HotelConfNumber,GETDATE(),@ModifiedBy,'ConfNumber' from Hotel_BookMaster where pkId = @Id            
      SELECT SCOPE_IDENTITY();                                  
    
  insert into Hotel_UpdatedHistory         
  (fkbookid,FieldName ,FieldValue,InsertedDate,InsertedBy,UpdatedType)        
  select @Id,'Passenger Confirmation',@PaxConfirmation+','+@RoomTypeConfirmation+','+@MealPlanConfirmation+','+@ExtrabedConfirmation+','+@PaymentConfirmation+','+cast(@ConfByEmailConfirmation as varchar(10)),  
    
  GETDATE(),@ModifiedBy,'PassengerDetailsConf' from Hotel_BookMaster where pkId = @Id            
      SELECT SCOPE_IDENTITY();    
      
END     
