
CREATE proc [dbo].[spRefundProcess]
as
begin
select Hotel_BookMaster.riyaPNR,inserteddate as refunddt,PassengerEmail,PassengerPhone,CheckInDate,CheckOutDate,HotelName,cityName,orderId,tracking_id,CardNumber,
ExpiryDate,
CVV,
CardType,
CardType
 From Hotel_BookMaster 
 left join Paymentmaster on Paymentmaster.order_id = Hotel_BookMaster.orderId
 where IsRefunded=1
 end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spRefundProcess] TO [rt_read]
    AS [dbo];

