create procedure Hotel.Sp_InsertHotelPreferenceException

@Channel varchar(200),
@DyanamoResponse varchar(Max),
@ApiResponse varchar(Max),
@ApiName varchar(500),
@HotelId varchar(200),
@LoginUser int


as 

begin

insert into  HOTEL.HotelPrefrence_ErrorLog (Exception,DyanmoDbException,createdDate,ApiName,LoginUserId,HotelId)
values (@ApiResponse,@DyanamoResponse,GETDATE(),@ApiName,@LoginUser,@HotelId)

end




