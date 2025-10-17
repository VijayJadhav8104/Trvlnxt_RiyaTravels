  
  
  
CREATE proc [dbo].[spBookingProcess]  
as  
  
begin  
select bkmstr.riyaPNR,CheckInDate,CheckOutDate,HotelName,inserteddate as bookingdt,  
PassengerEmail,PassengerPhone,  
case when payment.order_status is null then 'Pending' else payment.order_status end as paymentStatus   
,ISNULL(payment.order_id,'NA') 'order_id'  
,case when IsBooked=1  and CurrentStatus in ('success', 'vouchered','OffLine')   then 'Booked'  when IsBooked is null or CurrentStatus in ('success', 'vouchered','OffLine')  then 'Pending'  end as BookStatus  
 From Hotel_BookMaster bkmstr WITH(NOLOCK)  
 left join [Paymentmaster] payment WITH(NOLOCK) 
 ON bkmstr.riyaPNR=payment.riyaPNR  
 where IsCancelled is null  and IsRefunded is null and IsClosed is null    
and payment.order_status is null and IsBooked is null or IsBooked=0  
  
 order by bookingdt desc  
end  
  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spBookingProcess] TO [rt_read]
    AS [dbo];

