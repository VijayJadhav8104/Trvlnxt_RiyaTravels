CREATE procedure USP_Get_AutoCancellMiss_Data    
As    
BEGIN    
 Select BookingReference,  
 CancellationDeadLine,  
 CurrentStatus,  
 HSM.Status,  
 CurrentDateSchedular,  
 B2BPaymentMode,  
 CheckInDate, * from   
 Hotel_BookMaster HB  
 inner join Hotel_Status_History HS on HB.pkId = HS.FKHotelBookingId and hs.IsActive=1    
inner Join Hotel_Status_Master HSM ON HSM.Id=HS.FkStatusId    
 Where   
 convert(datetime,HB.CancellationDeadLine,103) <=getdate()   
 and HSM.Status in('Confirmed')  
 and convert(datetime,HB.CancellationDeadLine,103) >'Feb  14 2023  12:00AM' 
 And HB.BookingPortal='Qtech'
END  