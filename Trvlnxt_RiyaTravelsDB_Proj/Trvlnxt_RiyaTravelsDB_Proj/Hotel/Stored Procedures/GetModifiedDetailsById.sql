-- Created Procedure : 24 Feb 2025 -- for get details against bookings--

CREATE PROCEDURE  Hotel.[GetModifiedDetailsById]                                                                                                                                                                     
 -- Add the parameters for the stored procedure here                                                                                                                                                                    
                                                                                                                                                                     
 @Id int=0
 
 AS                                                                                                                                                                    
BEGIN  

select
   HB.BookingReference as book_Id,
   SM.Status as CurrentStatus,
   HB.cityName as HotelCity,         
   HB.CountryName as HotelCountry,  
      --CONVERT(varchar,HB.CheckInDate,106) as CheckInDate,                                            
   convert(varchar,HB.CheckInDate,106)  as CheckInDate                                                                    
                                          
   --CONVERT(varchar,HB.CheckOutDate,106) as CheckOutDate,                                           
   ,convert(varchar,HB.CheckOutDate,106) as CheckOutDate,
   HB.HotelName as HotelName,                                                                                                                  
   ISNULL (HB.HotelPhone,'02522-Null Case') as HotelPhoneNo,                                                                                                                                                        
   HB.HotelAddress1 as HotelAddress,                                                                   
   HB.HotelAddress2 as HotelAddress2,
   isnull(HB.SelectedNights,'0') as NoofNights, 
     SH.FkStatusId 
   from Hotel_BookMaster HB WITH(NOLOCK)
    left join Hotel_Status_History SH WITH(NOLOCK) on HB.pkId=SH.FKHotelBookingId
    left join Hotel_Status_Master SM WITH(NOLOCK) on SH.FkStatusId=SM.Id   
	where 
  (HB.pkId = @Id or @Id=0)                                                                                                                                          
   and SH.IsActive=1                                         

End