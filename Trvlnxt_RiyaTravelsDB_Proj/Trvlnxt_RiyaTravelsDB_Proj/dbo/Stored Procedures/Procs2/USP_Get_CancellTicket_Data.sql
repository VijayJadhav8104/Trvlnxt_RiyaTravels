CREATE Procedure [dbo].[USP_Get_CancellTicket_Data]                           
AS                          
BEGIN                          
                                             
SELECT  CancellationCharge,CancellationDeadLine,      
 EmailID as    MainAgentEmailId,      
HB.*                      
 ,BR.*                      
FROM Hotel_BookMaster HB                      
INNER JOIN B2BRegistration BR ON HB.RiyaAgentID = BR.FKUserID        
left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HB.pkId and hsh.IsActive=1      
Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id      
left Join mUser ON hb.MainAgentID=mUser.ID      
WHERE HB.B2BPaymentMode = 1                      
                 
 AND HSM.Status in('On Request','Confirmed')                 
              
 and CheckInDate>=GETDATE()       
       
 and HB.BookingPortal='Qtech'             
 and convert(datetime,CancellationDeadLine,103) <=getdate()              
             
 and CancellationDeadLine is not null and CancellationDeadLine!=''        
            
 --AND HB.pkId NOT IN (                       
 -- SELECT fk_pkid                      
 -- FROM UserCancelledTicket_Data                      
 -- )               
              
ORDER BY HB.pkid desc                      
                      
                       
--select * from Hotel_BookMaster where B2BPaymentMode=1 and book_message ='vouchered'                           
--BookingReference,CancellationDeadLine,CancelHours,inserteddate,                          
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_Get_CancellTicket_Data] TO [rt_read]
    AS [dbo];

