


CREATE proc [dbo].[SpIteneryDetails] --'I78J7X'

@RiyaPNR varchar(50)=null
as
begin

select * into #temp
from(
select distinct bkmstr.pkId, bkmstr.riyaPNR,bkmstr.inserteddate as bookingdt,bkmstr.AgentRefNo,bkmstr.BookingReference,ISNULL(CONVERT(varchar,bkmstr.SupplierName),'NA') as SupplierName,
--LeaderTitle,LeaderFirstName as PassengerName,
hpm.FirstName+' ' +hpm.LastName as PassengerName ,--LeaderLastName,  ISNULL(bkmstr.CancelDate,'NA') as CancelDate
 PassengerPhone,bkmstr.CheckInDate,bkmstr.CheckOutDate,bkmstr.cityName,bkmstr.HotelName,ISNULL(payment.order_status,'NA') as paymentStatus ,
 ISNULL(bkmstr.CancellationPolicy,'NA')as CancellationPolicy,ISNULL(CONVERT(VARCHAR,bkmstr.ExpirationDate),'NA') as ExpirationDate ,ISNULL(CONVERT(varchar, bkmstr.CancelDate),'NA') as CancelDate ,bkmstr.TotalRooms,bkmstr.TotalAdults,bkmstr.TotalChildren,
 ISNULL(payment.order_id,'NA') as orderid,ISNULL(payment.tracking_id,'NA') as trackingid,ISNULL(payment.payment_mode,'NA') as Paymentmode,
 ISNULL(payment.card_name,'NA') as cardname,ISNULL(payment.mer_amount,'NA') as merchantamount,hrm.RoomTypeDescription,
 case when payment.order_status='Success' and bkmstr.IsBooked is null then 1 else 0 end as IsRefund,isnull(payment.amount,0) TotalCharges
 ,case HotelConfNumber when '0' then '' else HotelConfNumber end as HotelConfNumber
 --,isnull(HotelConfNumber,'0') HotelConfNumber
 , ISNULL(CONVERT(varchar,SupplierRate),'NA')+' '+(SupplierCurrencyCode) as SupplierRate, ISNULL(CONVERT(varchar,ROEValue),'NA') as ROEValue, bkmstr.expected_prize,bkmstr.PassengerEmail,
  history.HotelName as H_Hotel,
  REPLACE(convert(varchar(50),history.CheckInDate,106),' ', '-') as H_CIDate,
   REPLACE(convert(varchar(50),history.CheckOutDate,106),' ', '-') as H_CODate,




  history.cityName as H_City,
  history.OfflineRemark as H_Remark,
  history.CurrentStatus as H_CStatus,
  ISNULL(bkmstr.CancellationCharge,0) as CancellationCharge
  ,ISNULL(bkmstr.QtechCancelCharge,0) as QtechCancelCharge
   ,ISNULL(bkmstr.QtechTotalCharges,0) as QtechTotalCharges
    ,ISNULL(bkmstr.QtechAppliedAgentRate,0) as QtechAppliedAgentRate
	   ,ISNULL(bkmstr.QtechAppliedAgentCharges,0) as QtechAppliedAgentCharges
	   ,ContractComment
  

 --From Hotel_BookMaster bkmstr 
 --left join [Paymentmaster] payment
 --ON bkmstr.riyaPNR=payment.riyaPNR

  From Hotel_BookMaster bkmstr 
left join[Hotel_Pax_master] hpm
on bkmstr.pkId=hpm.book_fk_id
left join[Hotel_Room_master]hrm
on hpm.book_fk_id=hrm.book_fk_id
left join [Paymentmaster] payment
ON bkmstr.riyaPNR=payment.riyaPNR


left join [HotelBookMaster_UpdateHistory] history
 ON bkmstr.riyaPNR=history.RiyaPNR 


 where bkmstr.riyaPNR=@RiyaPNR)p

 select * from #temp

 select distinct room_fk_id,Salutation,FirstName,LastName,PassengerType,Age,PassportNum,IssueDate,Expirydate,Nationality,PassengerEmail from Hotel_Pax_master pax
 join  #temp  t on pax.book_fk_id=t.pkId

 drop table #temp
 end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpIteneryDetails] TO [rt_read]
    AS [dbo];

