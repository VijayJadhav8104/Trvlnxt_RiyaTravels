CREATE PROCEDURE [dbo].[sp_InsertAmendmentRequest]
    @AmendmentRef VARCHAR(50),
    @Type VARCHAR(50),
    @RequestBy VARCHAR(50),
    @RiyaPNR VARCHAR(50),
	@BookMasterId VARCHAR(50),
	@ItenaryId VARCHAR(50),
	@PassengerId VARCHAR(50),
	@Status VARCHAR(50),
	@ReIssueDate DateTime,
	@BookingClass VARCHAR(5),
	@IsReSchedule Bit = NULL
AS
BEGIN
   
	INSERT INTO tbl_AmendmentRequest (AmendmentRef
	, Type
	, RequestBy
	, RiyaPNR
	, Inserteddate
	, BookMasterId
	, ItenaryId
	, PassengerId
	, Status
	,RescheduleDate
	,Cabin
	,IsBooked
	, IsReSchedule)
	VALUES (@AmendmentRef
	, @Type
	, @RequestBy
	, @RiyaPNR
	, GETDATE()
	, @BookMasterId
	, @ItenaryId
	, @PassengerId
	, @Status
	,@ReIssueDate
	,@BookingClass
	,0
	, @IsReSchedule)

	UPDATE tblBookItenary SET ReIssueDate = @ReIssueDate
	, BookingClass = @BookingClass
	WHERE pkId = @ItenaryId

	
	UPDATE tblBookMaster SET BookingStatus = 7
	WHERE pkId = @BookMasterId

	
	UPDATE tblPassengerBookDetails SET BookingStatus = 7
	WHERE pid = @PassengerId
END