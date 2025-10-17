--- Created Date : 1 July 2024 --  
---- Created By : Aman Wagde --  
--- Purpose : For pagination --  
CREATE Procedure Hotel.Sp_Hotel_BookingCount  
as   
  
begin  
   Select Count(Pkid) as TotalBookingCount  from Hotel_BookMaster   
end