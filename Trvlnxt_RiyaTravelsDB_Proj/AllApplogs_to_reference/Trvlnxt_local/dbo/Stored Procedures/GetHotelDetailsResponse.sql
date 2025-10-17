  
  
create proc [dbo].[GetHotelDetailsResponse]  
@id int  
As  
BEGIN  
  select Api_Response from [StoreLogs].HotelB2BRequestResponseLogs where id=@id  
END  

