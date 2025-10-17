CREATE Procedure USP_Get_CancellTicket_DataNew                                                   
AS                                                  
BEGIN                                                  
                                                                     
SELECT  CancellationCharge,CancellationDeadLine,AG.UserTypeID,                               
 EmailID as    MainAgentEmailId,                              
HB.*                                              
 ,BR.*                                              
FROM Hotel_BookMaster HB                                              
INNER JOIN B2BRegistration BR ON HB.RiyaAgentID = BR.FKUserID                                
left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HB.pkId and hsh.IsActive=1                              
Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id                              
left Join mUser ON hb.MainAgentID=mUser.ID       
left Join agentLogin AG On AG.UserID=HB.RiyaAgentID       
WHERE HB.B2BPaymentMode = 1                                              
                                         
 AND HSM.Status in('Confirmed')                                         
                                      
 and CheckInDate>=GETDATE()                               
                         
 and (BookingPortal ='TNH' or BookingPortal ='TNHAPI')                       
                                        
 --and convert(datetime,CancellationDeadLine,103) <=getdate()   
 and FORMAT(
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
                                     
 and CancellationDeadLine is not null and CancellationDeadLine!=''                    
                        
                                    
 AND HB.pkId NOT IN (                                               
  SELECT fk_pkid                                              
  FROM UserCancelledTicket_Data                                              
  )                                       
                                      
ORDER BY HB.pkid desc                                              
                                              
                                               
--select * from Hotel_BookMaster where B2BPaymentMode=1 and book_message ='vouchered'                                                   
--BookingReference,CancellationDeadLine,CancelHours,inserteddate,                                                  
END 