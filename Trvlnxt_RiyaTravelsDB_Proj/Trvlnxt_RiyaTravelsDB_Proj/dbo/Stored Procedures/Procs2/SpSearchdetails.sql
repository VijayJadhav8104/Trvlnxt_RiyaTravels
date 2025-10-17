

CREATE proc [dbo].[SpSearchdetails] -- [dbo].[SpSearchdetails] '2017-09-23 13:53:57.547','2017-09-27 18:27:18.077','','','','','',''
(
@frmdt varchar(50)=null,
@todt varchar(50)=null,
@paymentOrdId varchar(50)=null,
@mobNo varchar(50)=null,
@name varchar(50)=null,
@emailId varchar(50)=null,
@bookingId varchar(50)=null,
@bookingRef varchar(50)=null
)
as
begin
select bkmstr.riyaPNR,inserteddate as bookingdt,LeaderFirstName as PassengerName ,PassengerPhone,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus 
 From Hotel_BookMaster bkmstr 
 left join [Paymentmaster] payment
 ON bkmstr.orderId=payment.order_id
 where (convert(date,inserteddate) between convert(date,@frmdt) and convert(date,@todt) )
 and (PassengerPhone=@mobNo or @mobNo='')
 and (LeaderFirstName=@name or @name='')
 and (PassengerEmail=@emailId or @emailId='')
 and(bkmstr.riyaPNR=@bookingId or @bookingId='')
 and (BookingReference=@bookingRef or @bookingRef='')
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpSearchdetails] TO [rt_read]
    AS [dbo];

