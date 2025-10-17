CREATE PROCEDURE Update_HotelAPI_Res    -- Update_HotelAPI_Res 211,'Test'  
@ID int=0,      
@Response nvarchar(max)      
      
AS      
BEGIN      
      
      
 IF EXISTS(SELECT ID FROM [AllAppLogs].[dbo].HotelAPI_RequestResponsetbl WHERE ID=@ID)      
  BEGIN      
   UPDATE [AllAppLogs].[dbo].HotelAPI_RequestResponsetbl SET Response=@Response  WHERE ID=@ID      
   SELECT 'Success'      
  END      
      
      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_HotelAPI_Res] TO [rt_read]
    AS [dbo];

