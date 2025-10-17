

CREATE PROCEDURE [dbo].[sp_UpdatePNRSabreNDC]
	@OrderId varchar(30),
	@PNR varchar(200),
	@AirLinePNR varchar(200),
	@Trackid varchar(100)=''
	
AS
BEGIN
 declare @isGDS varchar(10)=''
	select @isGDS=GDSPNR from tblBookMaster where orderId=@OrderId
	
	if @isGDS is null or @isGDS=''
	
			begin
		if(@PNR<>'')
		begin
			UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=1,BookingStatus=1,IssueDate=GETDATE(),APITrackID=@Trackid
			WHERE orderId = @OrderId
			end
			else
			begin
				UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=0,BookingStatus=0,IssueDate=GETDATE(),APITrackID=@Trackid
			WHERE orderId = @OrderId
			end
		end
	
	
	UPDATE tblBookItenary SET airlinePNR = @AirLinePNR 
	WHERE orderId = @OrderId 
END


