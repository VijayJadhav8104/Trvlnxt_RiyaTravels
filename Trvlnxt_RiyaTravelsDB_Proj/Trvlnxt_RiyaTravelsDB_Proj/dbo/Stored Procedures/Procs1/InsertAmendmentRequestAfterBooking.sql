CREATE PROCEDURE [dbo].[InsertAmendmentRequestAfterBooking]
    @AmendmentRef VARCHAR(50),
    @Type VARCHAR(50),
    @RequestBy VARCHAR(50),
    @RiyaPNR VARCHAR(50),
	@ReIssueDate DateTime,
	@BookingClass VARCHAR(5),
	@ItineraryIDFs VARCHAR(500),
	@OrderID VARCHAR(100)
AS
BEGIN
	
	SELECT DISTINCT fkBookMaster INTO #mBookMaster
	FROM tblBookItenary WHERE pkId IN (SELECT Item FROM dbo.SplitString(@ItineraryIDFs, ','))

	SELECT Item AS ID INTO #mItineraryID FROM dbo.SplitString(@ItineraryIDFs, ',')

	SELECT pkId AS ItineraryID
	, tblBookItenary.fkBookMaster AS BookMasterID
	, tblPassengerBookDetails.pid AS PaxID
	INTO #mAmendment FROM dbo.SplitString(@ItineraryIDFs, ',')
	INNER JOIN tblBookItenary ON tblBookItenary.pkId = Item
	INNER JOIN tblPassengerBookDetails ON tblPassengerBookDetails.fkBookMaster = tblBookItenary.fkBookMaster

	INSERT INTO tbl_AmendmentRequest (AmendmentRef, Type, RequestBy, RiyaPNR, Inserteddate, BookMasterId, ItenaryId
	, PassengerId, Status, RescheduleDate, Cabin, IsBooked, IsReSchedule, AbortedBy, AbortedDate)
	SELECT @AmendmentRef, @Type, @RequestBy, @RiyaPNR , GETDATE(), BookMasterID, ItineraryID
	, PaxID, 0, @ReIssueDate, @BookingClass, 1, 1, @RequestBy, GETDATE()
	FROM #mAmendment

	-- UPDATE BOOK ITINERARY DATE AND CLASS
	UPDATE tblBookItenary SET ReIssueDate = @ReIssueDate
	, BookingClass = @BookingClass
	WHERE pkId IN (SELECT ID FROM #mItineraryID)

	-- UPDATE BOOK MASTER STATUS
	--UPDATE tblBookMaster SET BookingStatus = 18
	--WHERE pkId IN (SELECT fkBookMaster FROM #mBookMaster)

	-- UPDATE BOOK MASTER STATUS
	UPDATE tblBookMaster SET BookingFrom = 'Online'
	WHERE riyaPNR = @RiyaPNR AND orderId = @OrderID
	
	-- UPDATE PAX STATUS
	UPDATE tblPassengerBookDetails SET BookingStatus = 18
	WHERE fkBookMaster IN (SELECT fkBookMaster FROM #mBookMaster)

	-- Update Payment Master
	UPDATE paymentmaster SET [Source] = 'Online', AmendmentRefNo = @AmendmentRef
	WHERE order_id = @OrderID

END