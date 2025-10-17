CREATE PROCEDURE [dbo].[AmendmentRequest_Abort]
	@AbortedBy Int
	,@Remarks Varchar(1000) = NULL
	,@AmendmentRef Varchar(50)
	,@RiyaPNR Varchar(50)
	,@OUTVAL Int OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;

    UPDATE [tbl_AmendmentRequest] SET
	Status = 1
	, AbortedBy = @AbortedBy
	, AbortedDate = GETDATE()
	, Remarks = @Remarks
	WHERE AmendmentRef = @AmendmentRef AND RiyaPNR = @RiyaPNR

		
	UPDATE tblBookMaster SET BookingStatus = 1
	WHERE riyapnr = @RiyaPNR and BookingStatus != 18

	UPDATE tblPassengerBookDetails SET tblPassengerBookDetails.BookingStatus = 1
     FROM tblPassengerBookDetails tblPassengerBookDetails
     JOIN tblBookMaster tblBookMaster ON tblPassengerBookDetails.fkbookmaster = tblBookMaster.pkid 
     WHERE tblBookMaster.riyapnr = @RiyaPNR;

	SET @OUTVAL = 1

END
