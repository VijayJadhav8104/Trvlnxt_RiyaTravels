

CREATE proc [dbo].[SpIteneryCancelDetails] --'L3G4V6'

@RiyaPNR varchar(50)=null
as
begin

select * into #temp
from(
select bkmstr.pkId, bkmstr.riyaPNR,inserteddate as bookingdt,LeaderTitle,LeaderFirstName as PassengerName,LeaderLastName, PassengerPhone,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus 
 From Hotel_BookMaster bkmstr 
 inner join [Paymentmaster] payment
 ON bkmstr.orderId=payment.order_id
 where bkmstr.riyaPNR=@RiyaPNR)p

 select * from #temp

 select room_fk_id,Salutation,FirstName,LastName,PassengerType,Age from Hotel_Pax_master pax
 join  #temp  t on pax.book_fk_id=t.pkId

 drop table #temp



end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpIteneryCancelDetails] TO [rt_read]
    AS [dbo];

