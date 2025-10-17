CREATE PROCEDURE GetLogCountPerMinute    
 @AgentId VARCHAR(50) NULL,    
 @IP VARCHAR(100) NULL,         
 @MethodName VARCHAR(200) NULL,  
 @StartDate VARCHAR(100) NULL,  
 @EndDate VARCHAR(100) NULL  
AS     
BEGIN    
 SELECT COUNT(methodname) AS CntMethod FROM AllAppLogs.dbo.HotelApiLogs WHERE agentid=@AgentId AND ip =@IP   
 AND InsertedDate BETWEEN @StartDate AND @EndDate AND methodname =@MethodName    
END    
--select * from AllAppLogs.dbo.HotelApiLogs where InsertedDate BETWEEN '2023-01-09 14:25:00.000' AND '2023-01-09 14:26:00.000'  
--GetLogCountPerMinute '51354','10.11.11.81','asojdn-xvxvb-svsv-1149','AvailabilityBlockingController','2023-01-09 14:25:00.000','2023-01-09 14:26:00.000'