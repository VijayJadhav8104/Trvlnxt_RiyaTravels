      
CREATE proc GetHotelComission      
@Pkid int      
AS      
Begin      
   select * from Hotel_BookMaster  WITH (NOLOCK) where pkId=@Pkid      
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelComission] TO [rt_read]
    AS [dbo];

