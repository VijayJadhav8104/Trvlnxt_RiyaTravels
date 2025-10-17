CREATE PROCEDURE GetHotelSearchResponse   
@Id int   
AS  
BEGIN  
 select Api_Response from HotelB2BRequestResponseLogs where Id=@Id  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelSearchResponse] TO [rt_read]
    AS [dbo];

