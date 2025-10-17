



CREATE proc [dbo].[Update_HotelBooking_Records]

@HotelName varchar(100),
@CheckInDate datetime,
@CheckOutDate datetime,
@cityName varchar(100),
@OfflineRemark varchar(max),
@RiyaPNR varchar(50)

as
begin

if exists(select * from Hotel_BookMaster where riyaPNR= @RiyaPNR)
begin

Insert into HotelBookMaster_UpdateHistory
(
FKID,
RiyaPNR,
HotelName,
CheckInDate,
CheckOutDate,
cityName,
OfflineRemark,
CurrentStatus
)

select 
pkId,
riyaPNR,
HotelName,
CheckInDate,
CheckOutDate,
cityName,
@OfflineRemark,
CurrentStatus
 from Hotel_BookMaster where riyaPNR=@RiyaPNR
end




update Hotel_BookMaster
set
HotelName=@HotelName,
CheckInDate=@CheckInDate,
CheckOutDate=@CheckOutDate,
cityName=@cityName,
OfflineRemark=@OfflineRemark,
CurrentStatus='OffLine'

where riyaPNR = @RiyaPNR

End



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_HotelBooking_Records] TO [rt_read]
    AS [dbo];

