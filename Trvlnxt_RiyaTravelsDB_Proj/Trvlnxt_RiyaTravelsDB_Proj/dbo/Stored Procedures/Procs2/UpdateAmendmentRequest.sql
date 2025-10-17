CREATE PROCEDURE [dbo].[UpdateAmendmentRequest]
    @RiyaPNR varchar(50)
    ,@BookedBy varchar(100)
    ,@AmendmentRef varchar(50)
	,@OrderID varchar(50)
	,@BookingTripType varchar(10)
	,@BookingStatus Int = NULL
AS
BEGIN
	
	IF (@BookingStatus = 1)
	BEGIN
		-- Update Amendment
		UPDATE tbl_AmendmentRequest SET IsBooked=1
		, AbortedBy = @BookedBy
		, AbortedDate = GETDATE() 
		WHERE RiyaPNR = @riyaPNR 
		AND AmendmentRef = @AmendmentRef
   
		-- Update Book Master
		UPDATE tblBookMaster SET BookingFrom = 'Online'
		WHERE riyaPNR = @RiyaPNR AND orderId = @OrderID

		-- Update Payment Master
		UPDATE paymentmaster SET [Source] = 'Online', AmendmentRefNo = @AmendmentRef
		WHERE order_id = @OrderID

		--IF (@BookingTripType = 'RO' OR @BookingTripType = 'RR' OR @BookingTripType = 'RB')
		--BEGIN
		--	-- UPDATE OLD OW PNR STATUS 7 TO 18 BECAUSE IT WILL NOT CHANGE FROM API SIDE
		--	UPDATE tblBookMaster SET BookingStatus = 18
		--	WHERE pkId IN 
		--	(
		--		SELECT DISTINCT BookMasterId FROM tbl_AmendmentRequest 
		--		INNER JOIN tblBookMaster ON tblBookMaster.pkId = tbl_AmendmentRequest.BookMasterId
		--		WHERE tbl_AmendmentRequest.RiyaPNR = @RiyaPNR
		--		AND AmendmentRef = @AmendmentRef
		--		AND BookingStatus = 7
		--		--AND BookingFrom IS NULL
		--	)
		--END
	END
	ELSE
	BEGIN
		-- Update Amendment
		UPDATE tbl_AmendmentRequest SET IsBooked = 0
		, AbortedBy = @BookedBy
		, AbortedDate = GETDATE()
		, Remarks = 'Ticket Issue Failed.'
		, Status = 1
		WHERE RiyaPNR = @riyaPNR
		AND AmendmentRef = @AmendmentRef

		-- CHANGE BOOKING STATUS 1 FROM 7 BECAUSE TICKET ISSUE FAILED
		-- USER WILL GENERATE NEW AMENDMENT REQUEST AND TRY AGAIN
		--UPDATE tblBookMaster SET BookingStatus = 1
		--WHERE pkId IN 
		--(
		--	SELECT DISTINCT BookMasterId FROM tbl_AmendmentRequest 
		--	INNER JOIN tblBookMaster ON tblBookMaster.pkId = tbl_AmendmentRequest.BookMasterId
		--	WHERE tbl_AmendmentRequest.RiyaPNR = @RiyaPNR
		--	AND AmendmentRef = @AmendmentRef
		--	AND BookingStatus = 7
		--)
	END
END