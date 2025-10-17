

CREATE proc [dbo].[SpRefundIteneryDetails]  --[dbo].[SpRefundIteneryDetails] '33PDH3'

@RiyaPNR varchar(50)=null
as
begin

select * into #temp
from(
select bkmstr.pkId, bkmstr.riyaPNR,inserteddate as bookingdt,BookingReference
,LeaderTitle,LeaderFirstName as PassengerName,LeaderLastName
, PassengerPhone,CheckInDate,CheckOutDate,cityName,HotelName
,payment.order_status as paymentStatus,

bkmstr.ExpirationDate,isnull(bkmstr.CancelDate,'') as CancelDate ,bkmstr.SupplierRate,bkmstr.ROEValue,
 payment.order_id as orderid,payment.tracking_id as trackingid,payment.payment_mode as Paymentmode,
 payment.card_name as cardname,payment.mer_amount as merchantamount,

case when FullRefund=1 then  payment.amount
else (payment.amount-ISNULL(CancellationCharge,0)) end as Refund ,CancellationPolicy,payment



.tracking_id ,
payment.CardNumber,
payment.ExpiryDate,
payment.CVV,
payment.CardType,
payment.Type,
isnull(bkmstr.CancellationCharge,0) as CancellationCharge
 From Hotel_BookMaster bkmstr 
 left join [Paymentmaster] payment
 ON bkmstr.riyaPNR=payment.riyaPNR
 where bkmstr.riyaPNR=@RiyaPNR)p

 select * from #temp

 select room_fk_id,Salutation,FirstName,LastName,PassengerType,Age,PassportNum,IssueDate,pax.Expirydate,Nationality from Hotel_Pax_master pax
 join  #temp  t on pax.book_fk_id=t.pkId

 drop table #temp



end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpRefundIteneryDetails] TO [rt_read]
    AS [dbo];

