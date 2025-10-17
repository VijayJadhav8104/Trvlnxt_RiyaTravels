
CREATE proc [dbo].[spCancellationProcessWithPaging] 
(
@PageIndex int=0,
@pagesize int=20,
@RecordCount INT OUTPUT
)
as
begin
with cte
		as(
select pkid,riyaPNR,inserteddate as canceldt,PassengerEmail,PassengerPhone,CheckInDate,CheckOutDate,cityName,CancellationCharge,TotalCharges,ExpirationDate,book_message
 From Hotel_BookMaster where IsCancelled=1 and IsRefunded is null
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
    ON OBJECT::[dbo].[spCancellationProcessWithPaging] TO [rt_read]
    AS [dbo];

