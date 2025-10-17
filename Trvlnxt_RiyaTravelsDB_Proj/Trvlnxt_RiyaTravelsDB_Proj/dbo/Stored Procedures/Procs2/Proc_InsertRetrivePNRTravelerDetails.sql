               
CREATE procedure Proc_InsertRetrivePNRTravelerDetails                    
@Salutation varchar(30)='',                    
@FirstName varchar(500)='',                    
@Middlename varchar(300)='',                    
@LastName varchar(300)='',                    
@PassengerType varchar(30)='',                    
@book_fk_id int=0,                    
@orderId varchar(200)='',                    
@room_fk_id int=0,                    
@Nationality int=0,                    
@Contact varchar(50)='',                    
@Email varchar(300)='',                    
@RoomNo varchar(200)='',                    
@RoomType varchar(max)='',                    
@MealBasis varchar(300)='',                    
@PassportNo varchar(20)='',                    
@IssueDate datetime =null,                    
@ExpiryDate datetime=null,                    
@PancardNo varchar(30)='',               
@PancardName varchar(200)='',              
@IsLeadPax bit=null ,                
@PaxAge int = 0 ,        
@PassPortDOB datetime=null        
As                    
Begin    
If NOT Exists(Select book_fk_id, * from Hotel_Pax_master where book_fk_id=@book_fk_id)      
 Begin 
	insert into Hotel_Pax_master(                    
 Salutation,                    
 FirstName,                    
 LastName,                    
 PassengerType,                    
 book_fk_id,                    
 orderId,                    
 room_fk_id,                    
 Nationality,                    
 Contact,                    
 Email,                    
 RoomNo,                    
 RoomType,                    
 MealBasis,                    
 PassportNum,                    
 IssueDate,                    
 Expirydate,                    
 Pancard,               
 PanCardName,              
 IsLeadPax,                
 Age,        
 inserteddate,        
 PassPortDOB)                    
 values(                    
 @Salutation,                    
 @FirstName,                    
 @LastName,                    
 @PassengerType,                    
 @book_fk_id,                    
 @orderId,                    
 @room_fk_id,                    
 @Nationality,                    
 @Contact,                    
 @Email,                    
 @RoomNo,                    
 @RoomType,                    
 @MealBasis,                    
 @PassportNo,                    
 @IssueDate,                    
 @ExpiryDate,                    
 @PancardNo,                
 @PancardName,              
 @IsLeadPax,                
 @PaxAge,        
 GETDATE(),        
 @PassPortDOB)                    
	select  SCOPE_IDENTITY()  
 END
 Else
 Begin
	Select book_fk_id, * from Hotel_Pax_master where book_fk_id=@book_fk_id
 END
END 