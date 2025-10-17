      
      
CREATE Procedure USP_Get_Email_Reminder_DataNew                     
AS                      
BEGIN                      
                      
  SELECT  DATEDIFF(HOUR, getdate(), convert(datetime,CancellationDeadLine,103)) as TotalHourLeft,              
    EmailID as    MainAgentEmailId,      
  CancellationDeadLine,              
                
  CheckInDate,                     
  HB.*                    
     ,BR.*                    
     ,RM.RoomTypeDescription                    
FROM Hotel_BookMaster HB                    
INNER JOIN B2BRegistration BR ON HB.RiyaAgentID = BR.FKUserID                    
inner join Hotel_Room_master RM on HB.pkId=RM.book_fk_id        
inner join Hotel_Status_History HS on HB.pkId = HS.FKHotelBookingId and hs.IsActive=1      
inner Join Hotel_Status_Master HSM ON HSM.Id=HS.FkStatusId      
left Join mUser ON hb.MainAgentID=mUser.ID      
WHERE HB.B2BPaymentMode = 1                    
 AND HSM.Status in('Confirmed')               
 and CheckInDate>=GETDATE()      
 and HS.FkStatusId <> 11      
  and (HB.BookingPortal ='TNH' or HB.BookingPortal ='TNHAPI')          
 and DATEDIFF(HOUR, getdate(), convert(datetime,CancellationDeadLine,103)) <=36             
  and CancellationDeadLine is not null and CancellationDeadLine!=''            
 AND HB.pkId NOT IN (                     
  SELECT fk_pkid                    
  FROM UserEmaildReminder_Data                    
  )                    
--ORDER BY HB.pkid                    
                    
ORDER BY HB.pkid desc                    
                    
                    
                    
--select * from Hotel_BookMaster where B2BPaymentMode=1 and book_message ='vouchered'                       
--BookingReference,CancellationDeadLine,CancelHours,inserteddate,                      
END 