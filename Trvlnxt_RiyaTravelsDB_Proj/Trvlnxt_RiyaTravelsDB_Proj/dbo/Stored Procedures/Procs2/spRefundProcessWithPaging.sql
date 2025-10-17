

CREATE proc [dbo].[spRefundProcessWithPaging]-- 0,20,100
(
@PageIndex int=0,
@pagesize int=20,
@RecordCount INT OUTPUT
)
as
begin
with cte
		as(

select Paymentmaster.PKID,Hotel_BookMaster.riyaPNR,inserteddate as refunddt,PassengerEmail,PassengerPhone,CheckInDate,CheckOutDate,isnull(HotelName,'') as HotelName ,cityName,orderId,tracking_id,CardNumber,
isnull(ExpiryDate,'') ExpiryDate,  ISNULL(CONVERT(varchar,SupplierRate),'NA')+' '+(SupplierCurrencyCode) as SupplierRate, ISNULL(CONVERT(varchar,ROEValue),'NA') as ROEValue,
CVV,
CardType,
inserteddate as canceldt,
CancellationCharge,TotalCharges, isnull(ExpirationDate,'')  ExpirationDate,Paymentmaster.order_status as paymentStatus 
,book_message
 From Hotel_BookMaster 
 left join Paymentmaster on Paymentmaster.order_id = Hotel_BookMaster.orderId where IsRefunded=1
 ) 

		select * 
			INTO #Results1  from cte   
			SELECT @RecordCount = COUNT(*)
			FROM #Results1
			select * from (select *,
			ROW_NUMBER() OVER (ORDER BY pkid desc) AS RowRank from 
			#Results1 
			)P 
			WHERE RowRank > (@PageIndex ) * @PageSize  AND RowRank <=(((@PageIndex ) * @PageSize ) + @PageSize) 

			
		SELECT @RecordCount = COUNT(*) FROM #Results1
end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spRefundProcessWithPaging] TO [rt_read]
    AS [dbo];

