CREATE PROCEDURE [dbo].[fetchHotel_processData] 
AS
BEGIN

SELECT  book.[pkId] as Id
      ,book.[orderId] as orderId
      ,[book_Id] as QutechId
     ,[book_message] as bookingStatus
      ,book.[riyaPNR] as bookingId
        
      ,[HotelName]
    
      ,[CheckInDate]
      ,[CheckOutDate]
      ,book.[IsCancelled]
      ,book.[IsBooked]
      ,book.[inserteddate]
         ,[cityName]
		 ,pam.order_status as status
  FROM [dbo].[Hotel_BookMaster] book

  join  [dbo].[Hotel_Pax_master] pax on book.pkId=pax.book_fk_id
  join dbo.Paymentmaster pam on book.orderId=pam.order_id

  end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchHotel_processData] TO [rt_read]
    AS [dbo];

