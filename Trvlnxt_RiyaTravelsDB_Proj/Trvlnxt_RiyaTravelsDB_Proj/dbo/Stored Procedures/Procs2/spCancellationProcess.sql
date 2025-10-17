CREATE proc [dbo].[spCancellationProcess]
as
begin
select riyaPNR,inserteddate as canceldt,PassengerEmail,PassengerPhone,CheckInDate,CheckOutDate,cityName
 From Hotel_BookMaster where IsCancelled=1 and IsRefunded is null
 end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spCancellationProcess] TO [rt_read]
    AS [dbo];

