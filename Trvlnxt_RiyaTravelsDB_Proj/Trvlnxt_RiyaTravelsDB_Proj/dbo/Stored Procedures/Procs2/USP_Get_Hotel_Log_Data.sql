CREATE Procedure USP_Get_Hotel_Log_Data      
      
 AS                                                  
BEGIN      
 Select   lg.Id      
 from [AllAppLogs].[dbo].HotelB2BRequestResponseLogs as lg      
 left Join  Hotel_BookMaster on  UniqueSearchID COLLATE DATABASE_DEFAULT = searchApiId COLLATE DATABASE_DEFAULT      
 where Hotel_BookMaster.pkId is null and API_Name!='CancelBooking' ANd GETDATE() >= DATEADD(day, -200, getdate())      
      
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_Get_Hotel_Log_Data] TO [rt_read]
    AS [dbo];

