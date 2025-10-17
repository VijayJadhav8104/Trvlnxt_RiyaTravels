CREATE proc GetHotelDetailsResponse  
@id int  
As  
BEGIN  
  select Api_Response from HotelB2BRequestResponseLogs where id=@id  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelDetailsResponse] TO [rt_read]
    AS [dbo];

