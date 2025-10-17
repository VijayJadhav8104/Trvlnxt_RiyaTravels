

CREATE proc [dbo].[SpIteneryDetails_hotelconfno]-- '2KP49K'

@RiyaPNR varchar(50)=null,
@hotelconfno varchar(50)=null

as
begin

update Hotel_BookMaster set HotelConfNumber=@hotelconfno
where  riyaPNR=@RiyaPNR

select * into #temp
from(
select bkmstr.pkId, bkmstr.riyaPNR,inserteddate as bookingdt,bkmstr.BookingReference,
LeaderTitle,LeaderFirstName as PassengerName,LeaderLastName,
 PassengerPhone,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus ,
 bkmstr.CancellationPolicy,bkmstr.ExpirationDate,bkmstr.CancelDate,
 payment.order_id as orderid,payment.tracking_id as trackingid,payment.payment_mode as Paymentmode,
 payment.card_name as cardname,payment.mer_amount as merchantamount,
 case when payment.order_status='Success' and IsBooked is null then 1 else 0 end as IsRefund,isnull(payment.amount,0) TotalCharges,isnull(HotelConfNumber,0)
  HotelConfNumber,ISNULL(CONVERT(varchar,SupplierRate),'NA')+' '+(SupplierCurrencyCode) as SupplierRate,ISNULL(CONVERT(varchar,ROEValue),'NA') as ROEValue,Expirydate,bkmstr.PassengerEmail
 From Hotel_BookMaster bkmstr 
 left join [Paymentmaster] payment
 ON bkmstr.riyaPNR=payment.riyaPNR
 where bkmstr.riyaPNR=@RiyaPNR)p

 select * from #temp

 select room_fk_id,Salutation,FirstName,LastName,PassengerType,Age,PassportNum,IssueDate,t.Expirydate,Nationality from Hotel_Pax_master pax
 join  #temp  t on pax.book_fk_id=t.pkId

 drop table #temp
 end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpIteneryDetails_hotelconfno] TO [rt_read]
    AS [dbo];

