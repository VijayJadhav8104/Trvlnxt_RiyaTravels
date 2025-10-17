-- ================================================    
-- Author:  Akash    
-- Create date: 20 May 2025    
-- Description: This proc is used to store Prefrence Hotel details records.      
-- =============================================    
CREATE PROCEDURE Hotel.InsertPrefrenceDetails     
    
@RoomName varchar(max)=null,    
@CanPolicy varchar(max)=null,    
@Refundable bit=0,    
@Meal Varchar(max)=null,    
@inclusion varchar(max)=null,    
@SupplierName varchar(300)=null,    
@SupplierRhId varchAR(300)=NULL,    
@BookingId Varchar(200)=null,    
@ExpiryDate varchar(200)=null,    
@Refundability varchar(200)=null,  
@Rate decimal(18,2)=0,  
@RoomNumber varchar(200)=null    
AS    
 BEGIN    
    
    Insert into HOtel.PrefranceBookDetails(RoomName,CancellationPolicy,Refundable,Meal,Inclusion,InsertDate,SupplierName,SupplierRHID,BookingId,Refundability,ExpiryDate,Rate,RoomNumber) values    
 (@RoomName,@CanPolicy,@Refundable,@Meal,@inclusion,GETDATE(),@SupplierName,@SupplierRhId,@BookingId,@Refundability,@ExpiryDate,@Rate,@RoomNumber)    
    
 END 