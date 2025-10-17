---exec UpdateInsCancellationStatus '','null','M54XU2','161'
CREATE PROCEDURE [dbo].[UpdateInsCancellationStatus] 
@BookingStatus int=null,
@orderNumber varchar(50)=null,
@RiyaPNR varchar(50)=null,
@paxID int
AS 
	BEGIN
	SET NOCOUNT ON
	IF(@orderNumber IS NOT NULL AND @orderNumber !='null')
	begin 
	
	UPDATE tblInspassengerdetails SET PaxStatus=2
	WHERE orderNumber= @orderNumber
	--pkid = @paxID 
		SELECT '4'
	IF(EXISTS(SELECT 1 FROM tblInspassengerdetails where orderNumber=@orderNumber and PaxStatus =1))
		BEGIN
		SELECT '1'
		END
		ELSE
		UPDATE tblInsBookMaster SET Bookingstatus=2
		WHERE orderNumber = @orderNumber and Bookingstatus=1
		SELECT '1'
	END
	ELSE 
	BEGIN
	Declare @orderNum varchar(50);

	SELECT  @orderNum =orderNumber FROM tblInsBookMaster WHERE RIYAPNR=@RiyaPNR;

	UPDATE tblInspassengerdetails SET PaxStatus=2
	WHERE orderNumber= @orderNum
	--pkid = @paxID 
	SELECT '3'
	IF(EXISTS(SELECT 1 FROM tblInspassengerdetails where orderNumber=@orderNum and PaxStatus =1))
		BEGIN
		SELECT '1'
		END
		ELSE
		UPDATE tblInsBookMaster SET Bookingstatus=2
		WHERE orderNumber = @orderNum and Bookingstatus=1
		SELECT '1'
        SELECT '2'
	END

	END
