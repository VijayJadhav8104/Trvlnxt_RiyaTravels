CREATE PROCEDURE GetHotelLogsByBookingId                                                                                                                             
                                                                                                                            
 @bookingid varchar(200)=null,                                                                                                                                                                                                                
 @AgentId int                                                                                                      
                                                                                                                          
AS                                                                                                                          
BEGIN                  
DECLARE @CorrelationId VARCHAR(150)              
                                                                                                                           
SELECT @CorrelationId = searchApiId FROM Hotel_BookMaster WHERE BookingReference= @bookingid                
              
SELECT ID,Request,Response,MethodName,CorrelationId,AgentId,InsertedDate FROM AllAppLogs.dbo.HotelApiLogs WHERE CorrelationId=@CorrelationId AND AgentId=@AgentId AND MethodName LIKE '%client%' order by InsertedDate ASC      
                                                                       
END 