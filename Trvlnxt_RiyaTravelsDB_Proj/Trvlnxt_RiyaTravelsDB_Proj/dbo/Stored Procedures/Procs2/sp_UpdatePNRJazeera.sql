create PROCEDURE [dbo].[sp_UpdatePNRJazeera]
	@PNR varchar(200),
	@OrderId varchar(30),
	@AgentId bigint
	
AS
BEGIN
 declare @isGDS varchar(10)=''
	select @isGDS=GDSPNR from tblBookMaster where orderId=@OrderId
	
	if @isGDS is null or @isGDS=''
	
			begin
		if(@PNR<>'')
		begin
			UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=1,BookingStatus=1,IssueBy=@AgentId,IssueDate=GETDATE()
			WHERE orderId = @OrderId
			end
			else
			begin
				UPDATE tblBookMaster SET GDSPNR = @PNR,IsBooked=0,BookingStatus=0,IssueBy=@AgentId,IssueDate=GETDATE()
			WHERE orderId = @OrderId
			end
		end
	
	
	UPDATE tblBookItenary SET airlinePNR = @PNR 
	WHERE orderId = @OrderId 
END