            
            
CREATE Procedure USP_Get_Email_Reminder_SightSeeingDataNew                           
AS                            
BEGIN                            
                            
  SELECT  DATEDIFF(HOUR, getdate(), convert(datetime,CancellationDeadLine,103)) as TotalHourLeft,                    
    EmailID as    MainAgentEmailId,            
  CancellationDeadLine,                    
                      
  TripStartDate,                           
  HB.*                          
     ,BR.*                          
     --,RM.RoomTypeDescription                          
FROM SS.SS_BookingMaster HB                          
INNER JOIN B2BRegistration BR ON HB.AgentId = BR.FKUserID                          
--inner join Hotel_Room_master RM on HB.pkId=RM.book_fk_id              
inner join SS.SS_Status_History HS on HB.BookingId = HS.BookingId and hs.IsActive=1            
inner Join Hotel_Status_Master HSM ON HSM.Id=HS.FkStatusId            
left Join mUser ON hb.MainAgentID=mUser.ID            
WHERE    
--HB.B2BPaymentMode = 1                          
 HSM.Status in('Confirmed')                     
 and TripStartDate>=GETDATE()            
 and HS.FkStatusId <> 11            
  --and (HB.BookingPortal ='TNH' or HB.BookingPortal ='TNHAPI')                
 and DATEDIFF(HOUR, getdate(), convert(datetime,CancellationDeadLine,103)) <=36                   
  and CancellationDeadLine is not null and CancellationDeadLine!=''                  
 AND HB.BookingRefId NOT IN (                           
  SELECT EmailRefId                          
  FROM UserEmaildReminder_Data                          
  )                          
--ORDER BY HB.pkid                          
                          
ORDER BY HB.BookingId desc                          
                          
                          
                          
--select * from Hotel_BookMaster where B2BPaymentMode=1 and book_message ='vouchered'                             
--BookingReference,CancellationDeadLine,CancelHours,inserteddate,                            
END 