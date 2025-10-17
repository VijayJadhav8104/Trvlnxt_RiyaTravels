    
CREATE PROCEDURE USP_Delete_LogTable_Records   
@LogID  INT = null  
 AS                                                
BEGIN    
     
 delete       
 from [AllAppLogs].[dbo].HotelB2BRequestResponseLogs where Id=@LogID   
    
END    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_Delete_LogTable_Records] TO [rt_read]
    AS [dbo];

