CREATE proc [dbo].[UpdateTicketRecords] --UpdateTicketRecords 
 @PKID int
 ,@RiyaPNR nvarchar(100)=''
,@GDSPNR nvarchar(10)=''
,@Remark nvarchar(500)=''
,@TicketNum nvarchar(50)=''
,@AirlinePNR nvarchar(10)=''
,@BookingTrackModifiedBy nvarchar(10)=''
,@TicketNumber nvarchar(100)=''

AS 
  BEGIN
  declare @newticketno varchar(50)
      IF @GDSPNR != '' 
        BEGIN 
            UPDATE tblbookmaster 
            SET    gdspnr = @GDSPNR,Remarks=@Remark,IsBooked=1,BookingStatus=1
			       ,BookingTrackModifiedBy = @BookingTrackModifiedBy
				   ,BookingTrackModifiedOn= GETDATE()
            WHERE  riyaPNR = @RiyaPNR 
        END 

     else IF @TicketNum != '' 
        BEGIN 

        UPDATE tblpassengerbookdetails 
        SET    ticketnum = @TicketNum ,TicketNumber=@TicketNumber
        WHERE  pid = @PKID 
        END 

     else IF @AirlinePNR != '' 
        BEGIN 
            UPDATE tblbookitenary 
            SET    airlinepnr = @AirlinePNR 
            WHERE  pkid = @PKID 
        END 

END