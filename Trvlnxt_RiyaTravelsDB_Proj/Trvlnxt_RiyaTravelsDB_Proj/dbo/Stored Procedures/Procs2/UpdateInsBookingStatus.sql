CREATE PROCEDURE [dbo].[UpdateInsBookingStatus] 
@OrderID varchar(50)=null,
@BookingStatus int,
@IssueBy int=0,
@orderNumber varchar(50)=null,
@orderUniqueId nvarchar(MAX)=null,
@orderConfirmationFulfillmentUrl nvarchar(MAX)=null,
@invoiceNumber varchar(50)=null,
@invoiceDate varchar(50)=null,
@PaymentMode varchar(30)=null,
@RiyaPNR varchar(30)=null,
@ErrorMsg varchar(max)=null
AS BEGIN
		IF(@BookingStatus = 1)
		BEGIN
			UPDATE tblInsBookMaster SET IssueBy = @IssueBy, updatedDate = getdate(), Bookingstatus = @BookingStatus, orderNumber =@orderNumber,
			orderUniqueId=@orderUniqueId,orderConfirmationFulfillmentUrl=@orderConfirmationFulfillmentUrl,invoiceNumber=@invoiceNumber,invoiceDate=@invoiceDate,VendorBookingError=@ErrorMsg
			WHERE orderID = @OrderID

			UPDATE tblInsPassengerDetails SET PaxStatus=1
			WHERE orderID = @OrderID
		END
		ELSE IF(@BookingStatus = 3)
		BEGIN
			UPDATE tblInsBookMaster SET IssueBy = @IssueBy, updatedDate = getdate(), Bookingstatus = @BookingStatus, orderNumber =@orderNumber,
			orderUniqueId=@orderUniqueId,orderConfirmationFulfillmentUrl=@orderConfirmationFulfillmentUrl,invoiceNumber=@invoiceNumber,invoiceDate=@invoiceDate,VendorBookingError=@ErrorMsg
			WHERE orderID = @OrderID
			
			UPDATE tblInsPassengerDetails SET PaxStatus=3
			WHERE orderID = @OrderID
		END
END
