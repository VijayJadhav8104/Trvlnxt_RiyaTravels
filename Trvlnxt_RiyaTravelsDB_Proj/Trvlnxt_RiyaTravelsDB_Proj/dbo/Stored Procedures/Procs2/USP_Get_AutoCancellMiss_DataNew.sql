CREATE procedure USP_Get_AutoCancellMiss_DataNew            
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
 --convert(datetime,HB.CancellationDeadLine,103) <=getdate()      
 FORMAT(  
    CASE   
        -- If already IST (either marked as +05:30 or +00:00 in your system)  
        WHEN HB.HotelOffsetGMT = '+05:30' OR HB.HotelOffsetGMT = '+00:00'  
        THEN HB.CancellationDeadLine  
  
        -- If positive offset (e.g., +09:00 for Japan)  
        WHEN LEFT(HB.HotelOffsetGMT, 1) = '+'   
        THEN DATEADD(MINUTE, 330 - ((CAST(SUBSTRING(HB.HotelOffsetGMT, 2, 2) AS INT) * 60) + CAST(SUBSTRING(HB.HotelOffsetGMT, 5, 2) AS INT)), HB.CancellationDeadLine)  
  
        -- If negative offset (e.g., -04:00 for New York)  
        WHEN LEFT(HB.HotelOffsetGMT, 1) = '-'   
        THEN DATEADD(MINUTE, 330 + ((CAST(SUBSTRING(HB.HotelOffsetGMT, 2, 2) AS INT) * 60) + CAST(SUBSTRING(HB.HotelOffsetGMT, 5, 2) AS INT)), HB.CancellationDeadLine)  
  
        ELSE HB.CancellationDeadLine  
    END,  
    'dd MMM yyyy hh:mm tt'  
) <=getdate() 
 and HSM.Status in('Confirmed')            
 and convert(datetime,HB.CancellationDeadLine,103) >'Feb  14 2023  12:00AM'           
 And (HB.BookingPortal='TNH' or HB.BookingPortal='TNHAPI')          
 and HB.pkId!=9596        
 and HB.pkId!=9597        
  and HB.pkId!=9456       
  and HB.pkId NOT IN (                           
  SELECT BookingPkid                          
  FROM MissCancelleSendMailCount                          
  )       
END 