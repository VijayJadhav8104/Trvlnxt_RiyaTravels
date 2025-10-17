CREATE Procedure Proc_BookHotelCheckinAndCheckOutDiff      
As      
Begin      
 Select   
 HM.BookingReference,  
 HM.CheckInDate,  
 HM.CheckOutDate,  
 HM.SupplierCheckInDate,  
 HM.SupplierCheckOutDate       
 from       
 Hotel_BookMaster HM      
 INNER JOIN      
 Hotel_Status_History HSH      
  ON HM.pkId=HSH.FKHotelBookingId   
  and HSH.IsActive=1    
  AND HSH.FkStatusId in(4,3)      
 LEFT JOIN   
  Hotel_UpdatedHistory hh    
  ON HM.pkId = HH.fkbookid   
    
 Where       
  (CAST(HM.CheckInDate AS DATE) != CAST(HM.SupplierCheckInDate AS DATE) or       
  CAST(HM.CheckOutDate AS DATE) != CAST(HM.SupplierCheckOutDate AS DATE))     
  AND HM.B2BPaymentMode in(1,2,3,4)       
  AND hh.fkbookid IS NULL 
  AND hh.FieldValue = 'ModifiedBooking'
  AND CAST(HM.CheckInDate AS DATE) > CAST(GETDATE() AS DATE)    
END      