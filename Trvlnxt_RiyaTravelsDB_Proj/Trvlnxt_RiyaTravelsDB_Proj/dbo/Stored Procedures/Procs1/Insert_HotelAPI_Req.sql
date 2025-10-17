CREATE PROCEDURE Insert_HotelAPI_Req      
@APIController nvarchar(50),      
@Request nvarchar(max),      
@Domain nvarchar(10)=null,    
@BookingPkId varchar(200)=null    
    
AS      
BEGIN      
      
Insert into [AllAppLogs].[Dbo].HotelAPI_RequestResponsetbl (APIController,Request,Domain,InsertedDate,BookingPkId)     
values (@APIController,@Request,@Domain,SWITCHOFFSET(SYSDATETIMEOFFSET(),'+05:30'),@BookingPkId)      
      
select @@IDENTITY as ID      
      
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Insert_HotelAPI_Req] TO [rt_read]
    AS [dbo];

