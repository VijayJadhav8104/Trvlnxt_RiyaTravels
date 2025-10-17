create proc [dbo].[spInsertingBookingDetails]
	@mobileNo varchar(50) = null,
	@orderId varchar(50) = null,
	@emailId varchar(100) = null,
	@frmSector varchar(50) = null,
	@toSector varchar(50) = null,
	@deptDateTime Datetime = null,
	@IP varchar(50) = null,
	@airName varchar(50) = null,
	@Country varchar(50) = null,
	@GUID varchar(100) = null
AS 
BEGIN
		INSERT INTO tblB2CTrackingDetails  
		(  
			 ContactNo,OrderId,EmailId,frmSector,toSector,depDate,dashboard_Action  
			,IP,CreatedBy,Modifyby,CreatedDate,UpdatedDate,IsDelete,Airline,Country,
			BookingDate,Status,guid
		)  
		VALUES(  
			@mobileNo,@orderId,@emailId,@frmSector,@toSector, @deptDateTime, 1,  
			@IP, @emailId, @emailId, GETDATE(), GETDATE(), 1, @airName, @Country, 
			GETDATE(),'Flight Selected',@GUID
		)
END