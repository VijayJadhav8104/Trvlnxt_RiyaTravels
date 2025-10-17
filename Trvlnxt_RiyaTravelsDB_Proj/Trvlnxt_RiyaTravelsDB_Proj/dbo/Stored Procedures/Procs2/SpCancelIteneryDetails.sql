



CREATE proc [dbo].[SpCancelIteneryDetails] --'BHT970'

@RiyaPNR varchar(50)=null
as
begin

select * into #temp
from(
select bkmstr.pkId, bkmstr.riyaPNR,bkmstr.ContractComment,inserteddate as bookingdt,LeaderTitle,LeaderFirstName as PassengerName,LeaderLastName, PassengerPhone,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus,AgentRate,CancellationPolicy,BookingReference,
payment.tracking_id ,
payment.CardNumber,
payment.ExpiryDate,
payment.CVV,
payment.CardType,
payment.Type,

bkmstr.ExpirationDate,bkmstr.CancelDate,
 payment.order_id as orderid,payment.tracking_id as trackingid,payment.payment_mode as Paymentmode,
 payment.card_name as cardname,payment.mer_amount as merchantamount, ISNULL(CONVERT(varchar,SupplierRate),'NA')+' '+(SupplierCurrencyCode) as SupplierRate, ISNULL(CONVERT(varchar,ROEValue),'NA') as ROEValue,
 isnull(bkmstr.CancellationCharge,0) as CancellationCharge,
 
  ISNULL(bkmstr.QtechCancelCharge,0) as QtechCancelCharge
   ,ISNULL(bkmstr.QtechTotalCharges,0) as QtechTotalCharges
    ,ISNULL(bkmstr.QtechAppliedAgentRate,0) as QtechAppliedAgentRate
	   ,ISNULL(bkmstr.QtechAppliedAgentCharges,0) as QtechAppliedAgentCharges
	   

 From Hotel_BookMaster bkmstr 
 left join [Paymentmaster] payment
 ON bkmstr.riyaPNR=payment.riyaPNR
 where bkmstr.riyaPNR=@RiyaPNR)p

 select * from #temp

 select room_fk_id,Salutation,FirstName,LastName,PassengerType,Age,PassportNum,IssueDate,pax.ExpiryDate as ExpiryDate,Nationality from Hotel_Pax_master pax
 join  #temp  t on pax.book_fk_id=t.pkId

 drop table #temp



end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpCancelIteneryDetails] TO [rt_read]
    AS [dbo];

