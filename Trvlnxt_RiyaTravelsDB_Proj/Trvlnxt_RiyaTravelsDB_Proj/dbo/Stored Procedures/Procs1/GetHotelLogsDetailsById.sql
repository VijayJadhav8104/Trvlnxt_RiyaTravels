                                      
CREATE PROCEDURE GetHotelLogsDetailsById                                                                                                                   
                                                                                                                  
 @Id int                                                                                            
                                                                                                                
AS                                                                                                                
BEGIN        
    
SELECT ID,Request,Response FROM AllAppLogs.dbo.HotelApiLogs WHERE Id=@Id   
                                                             
END   
--GetHotelLogsDetailsById 1