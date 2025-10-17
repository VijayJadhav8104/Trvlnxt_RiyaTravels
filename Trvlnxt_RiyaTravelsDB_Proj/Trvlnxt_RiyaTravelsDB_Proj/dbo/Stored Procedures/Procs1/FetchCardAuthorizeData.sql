
CREATE PROCEDURE [dbo].[FetchCardAuthorizeData]
	-- Add the parameters for the stored procedure here
	@FROMDate Date,
	@ToDate Date,
	@Type int,
	@Start int=null,
	@Pagesize int=null,
	@Country varchar(50)=null,
	@RecordCount INT OUTPUT
AS




BEGIN

 -- declare 
	--@FROMDate Date = '2/1/2018 12:00:00 AM',
	--@ToDate Date= '2/9/2018 12:00:00 AM' ,
	--@Type int=0,
	--@Start int=0,
	--@Pagesize int=50,
	--@RecordCount INT OUTPUT

	IF (@Type=1)
		BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
	DROP table  #tempTableC
	 SELECT * INTO #tempTableC 
	from
	(  
	
			SELECT id,Booking_Reference_No,NameOfSalesPerson,
			CustomerName,CardHolderName,CardNo,Card_Expiry,
			Ticketed_Amount,NameOfPaxOtherCard,
			BillingAddress,WorkPhone_No,HomePhone_No,Mobile_No,
			EmailId,DriveryLicence_No,state,Uploaded_DocumentPath,
			FORMAT(dtSubmittedDate, 'dd-MMM-yyyy') AS dtSubmittedDate,
			--dtSubmittedDate,
			BookingCountry
			
			FROM Card_Authorization
		
		  ) p

		
		 where CONVERT(date,p.dtSubmittedDate) >= CONVERT(date,@FROMDate)
		  AND CONVERT(date,p.dtSubmittedDate) <= CONVERT(date, @ToDate)
		  AND p.BookingCountry=@Country 
		  ORDER BY P.dtSubmittedDate DESC
		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		SELECT * FROM #tempTableC
		ORDER BY  dtSubmittedDate  desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

END
	ELSE
		BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableP') IS NOT NULL
	DROP table  #tempTableP
	 SELECT * INTO #tempTableP
	from
	(  
			select distinct p1.pkid,order_id,billing_name,CardNumber,ExpiryDate,CVV,CardType,inserteddt,UserLogin.Address+' '+ UserLogin.City +' '+UserLogin.Province+' '+ UserLogin.Country+' ' +UserLogin.Pincode as billing_address , p1.Country
			 from Paymentmaster p1  join tblBookMaster b
			  on p1.order_id=b.orderId
			left outer join UserLogin on b.emailId=UserLogin.UserName
			--left outer join 
			
			WHERE P1.PaymentGateway != 'ccavenue'
			 ) p

		ORDER BY P.inserteddt DESC
		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		SELECT * FROM #tempTableP
		ORDER BY  inserteddt  desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
		END	
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchCardAuthorizeData] TO [rt_read]
    AS [dbo];

