
CREATE PROCEDURE [dbo].[sp_UpdatePNRTF]
	@OrderId varchar(30),
	@PNR varchar(200),
	@TFBookingRef varchar(500),
	@TFBookingstatus varchar(500),
	@AgentId bigint
	
AS
BEGIN
 --declare @isGDS varchar(10)=''
	--select @isGDS=GDSPNR from tblBookMaster where orderId=@OrderId
	
	--if @isGDS is null or @isGDS=''
	
	--	begin
		if(@PNR<>'')
		begin
			UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=1,BookingStatus=1,IssueBy=@AgentId,IssueDate=GETDATE(),TFBookingstatus=@TFBookingstatus,TFBookingRef=@TFBookingRef
			WHERE orderId = @OrderId
			end
			else
			begin
				UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=0,BookingStatus=0,IssueBy=@AgentId,IssueDate=GETDATE(),TFBookingstatus=@TFBookingstatus,TFBookingRef=@TFBookingRef
			WHERE orderId = @OrderId
			end
	--	end
	
	
	UPDATE tblBookItenary SET airlinePNR = @PNR 
	WHERE orderId = @OrderId 
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdatePNRTF] TO [rt_read]
    AS [dbo];

