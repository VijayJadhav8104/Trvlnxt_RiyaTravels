Create proc Hotel.usp_HotelDestinationRPT_log

@Date varchar(200)
as 
begin

insert into Hotel.HotelDestinationRPT_log (InsertedDate,MailStatus) values (@Date,'Success')

end