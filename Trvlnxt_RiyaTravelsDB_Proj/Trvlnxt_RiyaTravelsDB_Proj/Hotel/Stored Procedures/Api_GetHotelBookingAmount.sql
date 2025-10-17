Create Proc [Hotel].Api_GetHotelBookingAmount  
@BookingId varchar(100)=null  
  
AS  
BEGIN  
   select DisplayDiscountRate from Hotel_BookMaster where BookingReference=@BookingId   
END