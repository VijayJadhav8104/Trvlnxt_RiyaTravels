  
-- ================================================    
-- Author:  Akash    
-- Create date: 20 May 2025    
-- Description: This proc is used to store Prefrence Hotel details records.      
-- =============================================    
CREATE PROCEDURE Hotel.InsertPrefrenceHOTELDetails     
     
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
@NoOfRooms varchar(200)=null    
AS    
 BEGIN    
    
  Insert into HOtel.PrefrenceBookingHotelDetails (Active,InsertedDate,BookingId,ExpiryDate,Refundable,Refundability,Meal,TotalRate,SupplierName,SupplierId,Remark,CancellationPolicy,NoOfRooms)   
  values(1,GetDate(),@BookingId,@ExpiryDate,@Refundable,@Refundability,@Meal,@Rate,@SupplierName,@SupplierRhId,'',@CanPolicy,@NoOfRooms)    
    
 END 