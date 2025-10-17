



CREATE proc [dbo].[SpSearchdetailsWithPaging] -- [dbo].[SpSearchdetails] '2017-09-23 13:53:57.547','2017-09-27 18:27:18.077','','','','','',''
(
@frmdt varchar(50)=null,
@todt varchar(50)=null,
@paymentOrdId varchar(50)=null,
@mobNo varchar(50)=null,
@name varchar(50)=null,
@emailId varchar(50)=null,
@PageIndex int=0,
@pagesize int=20,
@bookingId varchar(50)=null,
@RecordCount INT OUTPUT,
@bookingRef varchar(50)=null
)
as
begin
with cte
		as(
--select 
--bkmstr.pkid,
--bkmstr.riyaPNR,bkmstr.inserteddate as bookingdt,hpm.FirstName+' ' +hpm.LastName as PassengerName ,
--PassengerPhone,PassengerEmail,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus, hpm.inserteddate 
--From Hotel_BookMaster bkmstr 
--left join[Hotel_Pax_master] hpm
--on bkmstr.pkId=hpm.book_fk_id
--left join [Paymentmaster] payment
--ON bkmstr.riyaPNR=payment.riyaPNR

select 
bkmstr.pkid,
bkmstr.riyaPNR,bkmstr.inserteddate as bookingdt,
(select top 1  hpm.FirstName+' ' +hpm.LastName from  [Hotel_Pax_master] hpm
where bkmstr.pkId=hpm.book_fk_id
)as PassengerName ,
PassengerPhone,PassengerEmail,CheckInDate,CheckOutDate,cityName,HotelName,payment.order_status as paymentStatus 
,bkmstr.book_message
From Hotel_BookMaster bkmstr 
inner join [Paymentmaster] payment
ON bkmstr.riyaPNR=payment.riyaPNR
 where ((convert(date,bkmstr.inserteddate) between convert(date,@frmdt) and convert(date,@todt) ) or ( @todt='' and @frmdt=''))
and (PassengerPhone=@mobNo or @mobNo='')
and (LeaderFirstName=@name or @name='')
and (PassengerEmail=@emailId or @emailId='')
and (bkmstr.riyaPNR=@bookingId or @bookingId='')
and (BookingReference=@bookingRef or @bookingRef='')
and (payment.order_id=@paymentOrdId or @paymentOrdId='')
 ) 

		select * 
			INTO #Results1  from cte   
			SELECT @RecordCount = COUNT(*)
			FROM #Results1
			select * from (select *,
			ROW_NUMBER() OVER (ORDER BY bookingdt desc) AS RowRank from 
			#Results1 
			)P 
			WHERE RowRank > (@PageIndex ) * @PageSize  AND RowRank <=(((@PageIndex ) * @PageSize ) + @PageSize) 
		SELECT @RecordCount = COUNT(*) FROM #Results1
end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SpSearchdetailsWithPaging] TO [rt_read]
    AS [dbo];

