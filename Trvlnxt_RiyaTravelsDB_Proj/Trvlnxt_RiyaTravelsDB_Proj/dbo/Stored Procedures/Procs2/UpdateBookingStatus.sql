CREATE PROCEDURE [dbo].[UpdateBookingStatus]   
	@GDSPNR varchar(10)=null,  
	@BookingStatus int,  
	@IssueBy int=0,  
	@IsHold bit=0,  
	@PaymentMode varchar(30)=null,  
	@RiyaPNR varchar(30)=null  
AS BEGIN  
 
	DECLARE @OrderID varchar(100) = null, @InsertedDateYear Int  
 
	if (ISNULL(@RiyaPNR, '') != '')  
	begin  
		set @OrderID = (select top 1 orderId from tblBookMaster(nolock) where riyaPNR=@RiyaPNR)   
  
		IF(@BookingStatus = 1) --Booking success  
		BEGIN
			-- Added by Hardik - 23.10.2024
			-- As per discussion with manavee mam if Year >= Current year update otherwise skip
			SELECT TOP 1 @InsertedDateYear = DATEPART(YEAR, inserteddate) FROM tblBookMaster WHERE riyaPNR=@RiyaPNR

			IF (@InsertedDateYear >= DATEPART(YEAR, GETDATE()))
			BEGIN
				UPDATE tblBookMaster SET IssueBy = @IssueBy, IssueDate = getdate(), BookingStatus = @BookingStatus   
				WHERE riyaPNR=@RiyaPNR  
			END
		END  
		ELSE IF((@BookingStatus = 4 or @BookingStatus = 8) AND @IssueBy !=0) -- Booking cancelled offline-4 / online-8  
		BEGIN  
			UPDATE tblBookMaster SET BookingStatus = @BookingStatus,Cancelledby = @IssueBy, CancelledDate = GETDATE()   
			WHERE riyaPNR=@RiyaPNR  
		END  
		ELSE  
		BEGIN  
			UPDATE tblBookMaster SET BookingStatus = @BookingStatus WHERE riyaPNR = @RiyaPNR  
		END  
	end  
	else --means GDSPNR is available  
	begin  
		set @OrderID = (select top 1 orderId from tblBookMaster(nolock) where gdspnr =@GDSPNR)   
  
		IF(@BookingStatus = 1 AND @IssueBy !=0)  
		BEGIN  
			-- Added by Hardik - 23.10.2024
			-- As per discussion with manavee mam if Year >= Current year update otherwise skip
			SELECT TOP 1 @InsertedDateYear = DATEPART(YEAR, inserteddate) FROM tblBookMaster WHERE GDSPNR = @GDSPNR

			IF (@InsertedDateYear >= DATEPART(YEAR, GETDATE()))
			BEGIN
				UPDATE tblBookMaster SET IssueBy = @IssueBy, IssueDate = getdate(),  BookingStatus = @BookingStatus   
				WHERE GDSPNR = @GDSPNR  
			END
		END  
		ELSE IF((@BookingStatus = 4 or @BookingStatus = 8) AND @IssueBy !=0)  
		BEGIN  
			UPDATE tblBookMaster SET BookingStatus = @BookingStatus,Cancelledby = @IssueBy, CancelledDate = GETDATE()   
			WHERE GDSPNR = @GDSPNR  
		END  
		ELSE  
		BEGIN  
			UPDATE tblBookMaster SET BookingStatus = @BookingStatus WHERE GDSPNR = @GDSPNR  
		END  
	end  
	
	if(@IsHold = 1)  
	BEGIN  
		Update p set IsHold = 1 from  tblBookMaster t  join Paymentmaster p on t.orderid= p.order_id WHERE GDSPNR = @GDSPNR  

		 declare @Country varchar(10);  
         Declare @utcdate Datetime;  
         Declare @Id int  
  
      select @Country=i.Country,@Id=i.pkId,  
        @utcdate =(case i.Country when 'US' THEN DATEADD(MINUTE,-570,getdate()) 
        when 'CA' THEN  DATEADD(MINUTE,-750,getdate()) 
       when 'AE' THEN DATEADD(MINUTE,-90,getdate())  ELSE  GETDATE() END) from tblBookMaster i;   
  
        UPDATE tblBookMaster SET HoldBookingDate = @utcdate ,inserteddate = @utcdate ,inserteddate_old = GETDATE() WHERE orderId = @OrderID  

	END  
  
	IF(@BookingStatus = 3  AND @OrderID is not null and @PaymentMode = 'Check')   
	BEGIN  
		Update Paymentmaster set order_status = 'Pending' WHERE order_id=@OrderID  
	END  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateBookingStatus] TO [rt_read]
    AS [dbo];

